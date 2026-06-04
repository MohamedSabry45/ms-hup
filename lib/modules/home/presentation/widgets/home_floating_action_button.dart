import 'package:flutter/material.dart';

class HomeFloatingActionButton extends StatelessWidget {
  final VoidCallback onTap;

  const HomeFloatingActionButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: const BoxDecoration(
        color: const Color(0xFFD4AF37),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(36),
          onTap: onTap,
          child: const Center(
            child: Icon(
              Icons.home,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
