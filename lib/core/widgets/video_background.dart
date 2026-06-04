import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoBackground extends StatefulWidget {
  final String videoPath;
  final Widget child;
  final Color fallbackColor;
  final Color overlayColor;

  const VideoBackground({
    super.key,
    required this.videoPath,
    required this.child,
    this.fallbackColor = Colors.black,
    this.overlayColor = const Color(0x4D000000),
  });

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  Object? _initError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initController();
  }

  Future<void> _initController() async {
    try {
      final controller = VideoPlayerController.asset(widget.videoPath);
      _controller = controller;

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _initError = e;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller?.dispose();
      _controller = null;
      _initError = null;
      _initController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) {
      return;
    }

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (controller.value.isInitialized) {
        controller.play();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final isReady = controller != null &&
        controller.value.isInitialized &&
        _initError == null;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isReady)
          FittedBox(
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          )
        else
          ColoredBox(color: widget.fallbackColor),
        ColoredBox(color: widget.overlayColor),
        widget.child,
      ],
    );
  }
}
