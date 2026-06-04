import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeTopBanner extends StatefulWidget {
  const HomeTopBanner({
    super.key,
    this.borderRadius,
    this.userName,
    this.isGuest = false,
  });

  final BorderRadius? borderRadius;
  final String? userName;
  final bool isGuest;

  @override
  State<HomeTopBanner> createState() => _HomeTopBannerState();
}

class _HomeTopBannerState extends State<HomeTopBanner> {
  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(18);
    final trimmedName = (widget.userName ?? '').trim();
    final greeting = widget.isGuest || trimmedName.isEmpty
        ? 'home.greeting_guest'.tr()
        : 'home.greeting_named'.tr(args: [trimmedName]);

    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFB31217),
            Color(0xFFD4AF37),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PositionedDirectional(
              start: -12,
              top: -18,
              child: Icon(
                Icons.electric_car_outlined,
                size: 140,
                color: Colors.white.withOpacity(0.12),
              ),
            ),
            PositionedDirectional(
              end: -26,
              bottom: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            PositionedDirectional(
              start: 14,
              top: 14,
              child: Container(
                width: 34,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'home.banner_side_label'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(64, 18, 20, 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      greeting,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      'home.banner_title'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      'home.banner_subtitle'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.90),
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BannerAction extends StatelessWidget {
  const _BannerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35), // 🔥 overlay احترافي
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}