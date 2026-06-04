import 'dart:async';

import 'package:flutter/material.dart';

class StoryBackgroundSlider extends StatefulWidget {
  final Widget child;
  final List<String> images;
  final Widget Function(BuildContext context, int index)? overlayBuilder;
  final double overlayTopSpacingFromIndicator;
  final Duration autoSlideDuration;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color overlayColor;

  const StoryBackgroundSlider({
    super.key,
    required this.child,
    required this.images,
    this.overlayBuilder,
    this.overlayTopSpacingFromIndicator = 30,
    this.autoSlideDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 700),
    this.animationCurve = Curves.easeInOut,
    this.overlayColor = const Color(0x59000000),
  });

  @override
  State<StoryBackgroundSlider> createState() => _StoryBackgroundSliderState();
}

class _StoryBackgroundSliderState extends State<StoryBackgroundSlider> {
  late final PageController _controller;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    if (widget.images.length > 1) {
      _timer = Timer.periodic(widget.autoSlideDuration, (_) {
        if (!mounted) return;

        final next = (_currentIndex + 1) % widget.images.length;
        _currentIndex = next;

        _controller.animateToPage(
          next,
          duration: widget.animationDuration,
          curve: widget.animationCurve,
        );

        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const indicatorHeight = 3.0;
    const indicatorTopPadding = 10.0;
    const indicatorHorizontalPadding = 12.0;
    const indicatorSpacing = 2.0;

    const overlayHorizontalPadding = 18.0;

    final safeTop = MediaQuery.paddingOf(context).top;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.images.length,
          itemBuilder: (_, index) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.images[index],
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(color: widget.overlayColor),
                ),
              ],
            );
          },
        ),

        widget.child,

        if (widget.overlayBuilder != null)
          Positioned(
            left: 0,
            right: 0,
            top: safeTop +
                indicatorTopPadding +
                indicatorHeight +
                widget.overlayTopSpacingFromIndicator,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(
                start: overlayHorizontalPadding,
                end: overlayHorizontalPadding,
              ),
              child: widget.overlayBuilder!(context, _currentIndex),
            ),
          ),

        Positioned(
          left: 0,
          right: 0,
          top: safeTop + indicatorTopPadding,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: indicatorHorizontalPadding),
            child: Row(
              children: List.generate(
                widget.images.length,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: indicatorSpacing),
                    height: indicatorHeight,
                    decoration: BoxDecoration(
                      color: index == _currentIndex ? Colors.white : Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
