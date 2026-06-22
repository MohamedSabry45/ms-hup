import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeServicesHeaderSection extends StatelessWidget {
  const HomeServicesHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 96, horizontal: 16),
      child: Column(
        children: [
          Text(
            'home.services_header.title'.tr(),
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFFF78905),
              letterSpacing: 4,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'home.services_header.protection'.tr(),
                style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFF78905), Color(0xFFE07A00)],
                ).createShader(bounds),
                child: Text(
                  'home.services_header.redefined'.tr(),
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: isMobile ? 200 : 300,
            child: Text(
              'home.services_header.description'.tr(),
              style: TextStyle(
                fontSize: isMobile ? 12 : 14,
                color: Colors.white.withOpacity(0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  const Color(0xFFF78905),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
