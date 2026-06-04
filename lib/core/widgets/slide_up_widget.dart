import 'package:flutter/material.dart';

/// Widget reusable بيعمل animation للعناصر تطلع من تحت
class SlideUpWidget extends StatefulWidget {
  final Widget child;
  final int delay; // in milliseconds
  final int duration; // in milliseconds
  final double startOffset; // how far from bottom (0.0 to 1.0)

  const SlideUpWidget({
    super.key,
    required this.child,
    this.delay = 0,
    this.duration = 600,
    this.startOffset = 0.5,
  });

  @override
  State<SlideUpWidget> createState() => _SlideUpWidgetState();
}

class _SlideUpWidgetState extends State<SlideUpWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, widget.startOffset),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
