import 'package:flutter/material.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

class NotesField extends StatelessWidget {
  const NotesField({
    super.key,
    required this.hintText,
    required this.controller,
    this.fillColor,
    this.textColor,
    this.hintColor,
  });

  final String hintText;
  final TextEditingController controller;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final effectiveFill = fillColor ?? const Color(0xFFE5E7EB);
    final bool isDark = effectiveFill.computeLuminance() < 0.5;

    return Container(
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
      child: TextFormField(
        controller: controller,
        minLines: 3,
        maxLines: 5,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.brandDark,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: effectiveFill,
          hintStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: hintColor ?? AppColors.grey7,
          ),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }
}
