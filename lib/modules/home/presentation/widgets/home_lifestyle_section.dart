import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

const Color _msOrange = Color(0xFFF78905);
const Color _msCarbon = Color(0xFF141414);
const Color _msCharcoal = Color(0xFF1a1a1a);

class HomeLifestyleSection extends StatelessWidget {
  const HomeLifestyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final items = [
      _LifestyleItem(
        icon: Icons.shopping_bag_outlined,
        title: 'home.shop_spare_parts',
        subtitle: 'home.spare_parts_subtitle',
        route: RoutesName.sparePartsScreen,
      ),
      _LifestyleItem(
        icon: Icons.directions_car_filled_outlined,
        title: 'home.explore_vehicles',
        subtitle: 'home.showroom_subtitle',
        route: RoutesName.buyCarScreen,
      ),
      _LifestyleItem(
        icon: Icons.content_cut_outlined,
        title: 'home.premium_barber',
        subtitle: 'home.premium_barber_subtitle',
        route: RoutesName.barberDetailScreen,
      ),
      _LifestyleItem(
        icon: Icons.sports_esports_outlined,
        title: 'home.vip_playstation',
        subtitle: 'home.vip_playstation_subtitle',
        route: RoutesName.simulatorDetailScreen,
      ),
    ];

    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 48 : 80, horizontal: 16),
      child: Column(
        children: [
          Text(
            'home.lifestyle_title'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: _msOrange,
              letterSpacing: 4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'home.lifestyle_headline'.tr(),
            style: TextStyle(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isMobile ? 300 : 520,
            child: Text(
              'home.lifestyle_subtitle'.tr(),
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withOpacity(0.5),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: isMobile ? 0.85 : 1.0,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _LifestyleCard(item: items[index], isMobile: isMobile);
            },
          ),
        ],
      ),
    );
  }
}

class _LifestyleItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  _LifestyleItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}

class _LifestyleCard extends StatefulWidget {
  final _LifestyleItem item;
  final bool isMobile;

  const _LifestyleCard({required this.item, required this.isMobile});

  @override
  State<_LifestyleCard> createState() => _LifestyleCardState();
}

class _LifestyleCardState extends State<_LifestyleCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _onTap() {
    setState(() => _pressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      setState(() => _pressed = false);
      Navigator.pushNamed(context, widget.item.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.identity()..scale(_pressed ? 0.96 : 1.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _msCharcoal,
              _msCarbon,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _msOrange.withOpacity(_pressed ? 0.5 : 0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: _msOrange.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _msOrange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _msOrange.withOpacity(0.25),
                ),
              ),
              child: Icon(
                widget.item.icon,
                color: _msOrange,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              widget.item.title.tr(),
              style: TextStyle(
                fontSize: widget.isMobile ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.subtitle.tr(),
              style: TextStyle(
                fontSize: widget.isMobile ? 11 : 12,
                color: Colors.white.withOpacity(0.45),
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'home.book_shop'.tr(),
                  style: TextStyle(
                    fontSize: 11,
                    color: _msOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 12,
                  color: _msOrange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
