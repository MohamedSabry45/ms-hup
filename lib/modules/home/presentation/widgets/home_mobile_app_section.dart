import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

const Color _msOrange = Color(0xFFF78905);
const Color _msCarbon = Color(0xFF141414);

class HomeMobileAppSection extends StatelessWidget {
  const HomeMobileAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return Container(
      color: _msCarbon,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 56 : 80, horizontal: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _msOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _msOrange.withOpacity(0.25)),
            ),
            child: Icon(
              Icons.phone_iphone,
              size: 40,
              color: _msOrange,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'home.mobile_app_title'.tr(),
            style: TextStyle(
              fontSize: isMobile ? 26 : 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: isMobile ? 320 : 540,
            child: Text(
              'home.mobile_app_subtitle'.tr(),
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.white.withOpacity(0.55),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StoreButton(
                icon: Icons.apple,
                labelKey: 'home.app_store',
                sublabelKey: 'home.app_store_sublabel',
                isMobile: isMobile,
              ),
              const SizedBox(width: 16),
              _StoreButton(
                icon: Icons.android,
                labelKey: 'home.google_play',
                sublabelKey: 'home.google_play_sublabel',
                isMobile: isMobile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final String sublabelKey;
  final bool isMobile;

  const _StoreButton({
    required this.icon,
    required this.labelKey,
    required this.sublabelKey,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _msOrange.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: _msOrange.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 18 : 24,
          vertical: 14,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: _msOrange,
              size: 28,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sublabelKey.tr(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.55),
                  ),
                ),
                Text(
                  labelKey.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
