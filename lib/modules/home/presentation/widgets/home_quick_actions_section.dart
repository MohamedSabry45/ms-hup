import 'package:flutter/material.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({
    super.key,
    required this.onBookNow,
    required this.onMaintenance,
  });

  final VoidCallback onBookNow;
  final VoidCallback onMaintenance;

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);

    return Row(
      children: [
        // Support / Rescue Button
        Expanded(
          child: _ActionButton(
            icon: Icons.support_agent,
            label: isRtl ? 'دعم / إنقاذ' : 'Support / Rescue',
            onTap: onMaintenance,
          ),
        ),
        const SizedBox(width: 12),
        // Book Service Button
        Expanded(
          child: _ActionButton(
            icon: Icons.calendar_today_outlined,
            label: isRtl ? 'احجز صيانة' : 'Book Service',
            onTap: onBookNow,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}