import 'package:flutter/material.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/modules/home/data/datasources/brands_remote_datasource.dart';
import 'package:reservation_workshop/modules/home/data/models/brand_model.dart';

class HomeBrandsSection extends StatefulWidget {
  const HomeBrandsSection({
    super.key,
    this.perPage = 12,
    this.selectedBrandName,
  });

  final int perPage;
  final String? selectedBrandName;

  @override
  State<HomeBrandsSection> createState() => _HomeBrandsSectionState();
}

class _HomeBrandsSectionState extends State<HomeBrandsSection> {
  late final BrandsRemoteDataSource _dataSource = BrandsRemoteDataSourceImpl();
  late Future<List<BrandModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _dataSource.getBrands();
  }

  Future<void> _showAllBrands() async {
    final allBrands = await _dataSource.getBrands();
    final featuredBrands = allBrands.where((b) => b.features == 1).toList();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => _BrandsDialog(
        brands: featuredBrands,
        selectedBrandName: widget.selectedBrandName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);

    return FutureBuilder<List<BrandModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final allBrands = snapshot.data ?? const <BrandModel>[];
        final brands = allBrands.where((b) => b.features == 1).toList();
        if (brands.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isRtl ? 'العلامات التجارية' : 'BRANDS WE SERVICE',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.2,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _showAllBrands,
                    child: Row(
                      children: [
                        Text(
                          isRtl ? 'عرض الكل' : 'View All',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD4AF37),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Color(0xFFD4AF37),
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF050505),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemCount: brands.length,
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      final isSelected = widget.selectedBrandName != null &&
                          brand.name.trim().toLowerCase() ==
                              widget.selectedBrandName!.trim().toLowerCase();
                      return _BrandTile(brand: brand, isSelected: isSelected);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BrandsDialog extends StatelessWidget {
  const _BrandsDialog({
    required this.brands,
    this.selectedBrandName,
  });

  final List<BrandModel> brands;
  final String? selectedBrandName;

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);

    return Dialog(
      backgroundColor: const Color(0xFF161B22),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isRtl ? 'العلامات التجارية' : 'All Brands',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  final isSelected = selectedBrandName != null &&
                      brand.name.trim().toLowerCase() ==
                          selectedBrandName!.trim().toLowerCase();
                  return _BrandTile(brand: brand, isSelected: isSelected);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandTile extends StatelessWidget {
  const _BrandTile({
    required this.brand,
    this.isSelected = false,
  });

  final BrandModel brand;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final name = brand.name.trim();
    final imageUrl = (brand.logo ?? '').trim();
    final hasLogo = imageUrl.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFD4AF37)
              : Colors.white.withOpacity(0.06),
          width: isSelected ? 3 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasLogo)
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallbackIcon(name),
            )
          else
            _fallbackIcon(name),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                name.isEmpty ? '-' : name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(String name) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
