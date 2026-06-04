import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';

class HomeHeaderCircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const HomeHeaderCircleButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.brandSurface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.black87,
          size: 24,
        ),
      ),
    );
  }
}

class HomeHeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const HomeHeaderActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
            color: const ui.Color.fromARGB(84, 245, 4, 4).withOpacity(0.95),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: const ui.Color.fromARGB(255, 231, 225, 225).withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: const ui.Color.fromARGB(221, 2, 2, 2)),
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
