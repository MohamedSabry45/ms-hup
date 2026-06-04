import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeServiceCardsSection extends StatelessWidget {
  const HomeServiceCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: isMobile ? 0.9 : 1.1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        final services = [
          {
            'tag': 'home.services.quick_maintenance.tag'.tr(),
            'icon': Icons.speed,
            'title': 'home.services.quick_maintenance.title'.tr(),
            'description': 'home.services.quick_maintenance.description'.tr(),
          },
          {
            'tag': 'home.services.electrical_mechanical.tag'.tr(),
            'icon': Icons.electrical_services,
            'title': 'home.services.electrical_mechanical.title'.tr(),
            'description': 'home.services.electrical_mechanical.description'.tr(),
          },
          {
            'tag': 'home.services.suspension.tag'.tr(),
            'icon': Icons.settings,
            'title': 'home.services.suspension.title'.tr(),
            'description': 'home.services.suspension.description'.tr(),
          },
          {
            'tag': 'home.services.emergency.tag'.tr(),
            'icon': Icons.emergency,
            'title': 'home.services.emergency.title'.tr(),
            'description': 'home.services.emergency.description'.tr(),
          },
          {
            'tag': 'home.services.inspection.tag'.tr(),
            'icon': Icons.search,
            'title': 'home.services.inspection.title'.tr(),
            'description': 'home.services.inspection.description'.tr(),
          },
          {
            'tag': 'home.services.diagnostics.tag'.tr(),
            'icon': Icons.build,
            'title': 'home.services.diagnostics.title'.tr(),
            'description': 'home.services.diagnostics.description'.tr(),
          },
        ];
        final service = services[index];
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF050505).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(isMobile ? 12 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                service['tag'] as String,
                style: TextStyle(
                  fontSize: isMobile ? 9 : 10,
                  color: const Color(0xFFD4AF37).withOpacity(0.6),
                  letterSpacing: 2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  service['icon'] as IconData,
                  color: const Color(0xFFD4AF37),
                  size: isMobile ? 18 : 20,
                ),
              ),
              SizedBox(height: isMobile ? 8 : 12),
              Text(
                service['title'] as String,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Text(
                service['description'] as String,
                style: TextStyle(
                  fontSize: isMobile ? 10 : 11,
                  color: Colors.white.withOpacity(0.4),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
