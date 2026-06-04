import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

class HomeEstimatorsSection extends StatelessWidget {
  const HomeEstimatorsSection({
    super.key,
    required this.onRequestEstimatorNow,
  });

  final VoidCallback onRequestEstimatorNow;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      backgroundColor: Colors.white,
      borderRadius: 0,
      borderColor: Colors.grey.shade300,
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t(context, 'home.estimators_title', ar: 'المقايسات', en: 'Estimators'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t(context, 'home.estimators_cta', ar: 'اطلب مقايسة الآن', en: 'Request an estimator'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: onRequestEstimatorNow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    ),
                    child: Text(
                      t(context, 'home.estimators_cta', ar: 'اطلب مقايسة الآن', en: 'Request an estimator'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.15),
              borderRadius: BorderRadius.zero,
            ),
            child: const Icon(
              Icons.receipt_long,
              color: const Color(0xFFD4AF37),
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}
