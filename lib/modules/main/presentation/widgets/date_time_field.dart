import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class DateTimeField extends StatelessWidget {
  const DateTimeField({
    super.key,
    required this.label,
    required this.valueText,
    required this.onPick,
    this.labelColor,
    this.fillColor,
    this.textColor,
    this.iconColor,
  });

  final String label;
  final String valueText;
  final VoidCallback onPick;
  final Color? labelColor;
  final Color? fillColor;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveFill = fillColor ?? const Color(0xFFE5E7EB);
    final bool isDark = effectiveFill.computeLuminance() < 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: labelColor ?? AppColors.brandDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(14),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: effectiveFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? const Color(0xFFD4AF37).withOpacity(0.12) : AppColors.brandOutline.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.brandPrimary, width: 1.5),
                ),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: iconColor ?? AppColors.brandDark),
              ),
              child: Text(
                valueText,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? AppColors.brandDark,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
