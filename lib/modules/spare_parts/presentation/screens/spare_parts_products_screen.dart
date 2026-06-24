import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/spare_parts/domain/entities/taxonomy_category.dart';
import 'package:reservation_workshop/modules/spare_parts/domain/entities/spare_product.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/spare_parts/presentation/cubits/cart_cubit/cart_cubit_exports.dart';
import 'package:reservation_workshop/modules/spare_parts/presentation/cubits/products_cubit/products_cubit.dart';
import 'package:reservation_workshop/modules/spare_parts/presentation/cubits/products_cubit/products_state.dart';
import 'package:reservation_workshop/modules/spare_parts/presentation/screens/spare_parts_cart_screen.dart';

class SparePartsProductsScreen extends StatefulWidget {
  final TaxonomyCategory category;

  const SparePartsProductsScreen({
    super.key,
    required this.category,
  });

  @override
  State<SparePartsProductsScreen> createState() => _SparePartsProductsScreenState();
}

class _SparePartsProductsScreenState extends State<SparePartsProductsScreen> {
  TaxonomyCategory? _selectedSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        context.read<ProductsCubit>().load(perPage: 30, businessId: 1, locationId: 1);
      } catch (_) {}
    });
  }

  void _selectSub(TaxonomyCategory? sub) {
    setState(() => _selectedSub = sub);
  }

  void _addToCart(SpareProduct product) {
    final variationId = product.id;
    context.read<CartCubit>().addProduct(product: product, variationId: variationId);
  }

  void _openCart() {
    CustomerInfoCubit? customerInfo;
    try {
      customerInfo = context.read<CustomerInfoCubit>();
    } catch (_) {
      customerInfo = null;
    }

    try {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute<void>(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CartCubit>.value(value: context.read<CartCubit>()),
              if (customerInfo != null) BlocProvider<CustomerInfoCubit>.value(value: customerInfo),
            ],
            child: const SparePartsCartScreen(),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> _openCompatibilitySheet(SpareProduct product) async {
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        final items = product.compatibility;
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + MediaQuery.of(ctx).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.brandDark,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Compatibility',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.grey7,
                  ),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'No compatibility data found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.grey7),
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white3,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.brandOutline),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 44,
                          dataRowMinHeight: 44,
                          dataRowMaxHeight: 64,
                          columnSpacing: 16,
                          headingTextStyle: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.brandDark,
                          ),
                          dataTextStyle: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.brandDark,
                          ),
                          columns: const [
                            DataColumn(label: Text('Brand')),
                            DataColumn(label: Text('Model')),
                            DataColumn(label: Text('From')),
                            DataColumn(label: Text('To')),
                          ],
                          rows: items
                              .map(
                                (c) => DataRow(
                                  cells: [
                                    DataCell(Text(c.brand)),
                                    DataCell(Text(c.model)),
                                    DataCell(Text(c.fromYear?.toString() ?? '-')),
                                    DataCell(Text(c.toYear?.toString() ?? '-')),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Set<int> _collectIds(TaxonomyCategory root) {
    final ids = <int>{};
    final stack = <TaxonomyCategory>[root];
    while (stack.isNotEmpty) {
      final current = stack.removeLast();
      ids.add(current.id);
      if (current.subCategories.isNotEmpty) {
        stack.addAll(current.subCategories);
      }
    }
    return ids;
  }

  List<SpareProduct> _filter({required List<SpareProduct> products}) {
    final allowed = _selectedSub == null ? _collectIds(widget.category) : _collectIds(_selectedSub!);
    return products.where((p) {
      final subId = p.subCategoryId;
      if (subId != null) {
        return allowed.contains(subId);
      }

      // منتجات بدون sub-category: نعرضها فقط على مستوى الكاتيجوري (All)
      // وده مهم خصوصًا لكتير من منتجات Spare Parts اللي sub_category=null.
      if (_selectedSub != null) return false;
      return p.categoryId != null && p.categoryId == widget.category.id;
    }).toList();
  }

  String _fitsText(SpareProduct product) {
    final compatibility = product.compatibility;
    if (compatibility.isEmpty) return '-';
    final first = compatibility.first;
    return '${first.brand} ${first.model}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final items = category.subCategories;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF050505), Color(0xFF0A0A0A)],
                ),
              ),
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  return CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(child: _buildHero(context)),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: _buildFilterChips(items),
                        ),
                      ),
                      if (state is ProductsLoading)
                        const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator(color: _msOrange)),
                        )
                      else if (state is ProductsError)
                        SliverFillRemaining(child: _buildError(context, state.message))
                      else
                        _buildProductsGrid(state),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  );
                },
              ),
            ),
            _buildBackButton(context),
            _buildCartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context) {
    final category = widget.category;
    return SizedBox(
      height: 360,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildHeroImage(category.logo),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _msOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'spare_parts_products.description'.tr(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.55),
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(String? logo) {
    if (logo != null && logo.isNotEmpty) {
      return Image.network(
        logo,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover),
      );
    }
    return Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover);
  }

  Widget _buildFilterChips(List<TaxonomyCategory> items) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'spare_parts_products.all'.tr(),
            selected: _selectedSub == null,
            onTap: () => _selectSub(null),
          ),
          ...items.map((item) {
            final selected = _selectedSub?.id == item.id;
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: _FilterChip(
                label: item.name,
                selected: selected,
                onTap: () => _selectSub(item),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey7, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<ProductsCubit>().load(perPage: 30, businessId: 1, locationId: 1),
              child: Text('spare_parts_products.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsGrid(ProductsState state) {
    final all = state is ProductsSuccess ? state.products : const <SpareProduct>[];
    final filtered = _filter(products: all);
    if (filtered.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'spare_parts_products.no_products'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final p = filtered[index];
            return _ProductCard(
              product: p,
              fits: _fitsText(p),
              onAdd: () => _addToCart(p),
              onTap: () => _openCompatibilitySheet(p),
            );
          },
          childCount: filtered.length,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 8,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
    );
  }

  Widget _buildCartButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 16,
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final count = state is CartUpdated ? state.totalQuantity : 0;
          return _CartActionButton(
            count: count,
            pulseTick: count,
            onTap: _openCart,
          );
        },
      ),
    );
  }
}

const Color _msOrange = Color(0xFFF78905);

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _msOrange : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? _msOrange : Colors.white.withOpacity(0.12),
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final SpareProduct product;
  final String fits;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.fits,
    required this.onAdd,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildImage(product.imageUrl),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (product.categoryName ?? product.subCategoryName ?? '').toUpperCase(),
                    style: TextStyle(
                      color: _msOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${'spare_parts_products.fits'.tr()}: $fits',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${product.defaultSellPrice.toStringAsFixed(0)} EGP',
                        style: const TextStyle(
                          color: _msOrange,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      _AddButton(onTap: onAdd),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover),
      );
    }
    return Image.asset('assets/images/bummy.jpg', fit: BoxFit.cover);
  }
}

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;

  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _pressed = false;

  Future<void> _animate() async {
    if (!mounted) return;
    setState(() => _pressed = true);
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        widget.onTap();
        _animate();
      },
      child: AnimatedScale(
        scale: _pressed ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutBack,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _msOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _CartActionButton extends StatelessWidget {
  final int count;
  final int pulseTick;
  final VoidCallback onTap;

  const _CartActionButton({
    required this.count,
    required this.pulseTick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, anim) {
          final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
          return ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.15).animate(curved),
            child: child,
          );
        },
        child: Stack(
          key: ValueKey<int>(pulseTick),
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: onTap,
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            ),
            if (count > 0)
              PositionedDirectional(
                top: 6,
                end: 6,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, anim) {
                    return ScaleTransition(scale: anim, child: child);
                  },
                  child: Container(
                    key: ValueKey<int>(count),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.white.withOpacity(0.9), width: 1.2),
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
