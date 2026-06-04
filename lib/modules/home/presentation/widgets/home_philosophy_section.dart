import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePhilosophySection extends StatelessWidget {
  const HomePhilosophySection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final principles = [
      {'text': 'home.philosophy.absolute_protection'.tr(), 'color': const Color(0xFFD4AF37)},
      {'text': 'home.philosophy.zero_compromise'.tr(), 'color': Colors.white},
      {'text': 'home.philosophy.concierge_care'.tr(), 'color': const Color(0xFFD4AF37)},
      {'text': 'home.philosophy.paint_perfection'.tr(), 'color': Colors.white},
      {'text': 'home.philosophy.unmatched_quality'.tr(), 'color': const Color(0xFFD4AF37)},
      {'text': 'home.philosophy.legendary_service'.tr(), 'color': Colors.white},
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 64 : 128, horizontal: 16),
      child: Column(
        children: [
          Text(
            'home.philosophy.title'.tr(),
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFFD4AF37).withOpacity(0.4),
              letterSpacing: 6,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFD4AF37), Color(0xFFB8942E)],
              stops: [0.0, 0.5, 1.0],
            ).createShader(bounds),
            child: Text(
              'home.hero_headline'.tr(),
              style: TextStyle(
                fontSize: isMobile ? 36 : 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 48),
          ...principles.map((principle) {
            final color = principle['color'] as Color;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                principle['text'] as String,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
