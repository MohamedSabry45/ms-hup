import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:video_player/video_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/weather/presentation/cubits/weather_cubit/weather_cubit.dart';
import 'package:reservation_workshop/modules/weather/data/repositories/weather_repository.dart';

const Color _msOrange = Color(0xFFF78905);
const Color _msBlack = Color(0xFF000000);
const Color _msCharcoal = Color(0xFF0a0a0a);
const Color _msCarbon = Color(0xFF141414);

class HomeHeroSection extends StatefulWidget {
  final String greeting;
  final String carLabel;
  final List<CustomerCar> cars;
  final int? selectedCarId;
  final Function(int?) onCarSelected;
  final VoidCallback? onMenuTap;

  const HomeHeroSection({
    super.key,
    required this.greeting,
    required this.carLabel,
    required this.cars,
    required this.selectedCarId,
    required this.onCarSelected,
    this.onMenuTap,
  });

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection>
    with TickerProviderStateMixin {
  late final AnimationController _glowController;
  late final AnimationController _shimmerController;
  late final AnimationController _particleController;
  late VideoPlayerController _videoController;
  bool _videoReady = false;
  String _userLocation = 'cairo';
  Key _weatherKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _videoController = VideoPlayerController.asset('assets/videos/hero-cinematic-video.mp4')
      ..setLooping(true)
      ..setVolume(0.0)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _videoReady = true);
          _videoController.play();
        }
      }).catchError((_) {
        // Video failed to load; fallback gradient is already showing.
      });

    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        // Use geocoding to get city name from coordinates
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        String locationName = 'Cairo';
        if (placemarks.isNotEmpty) {
          locationName = placemarks.first.locality ?? 
                       placemarks.first.subAdministrativeArea ?? 
                       placemarks.first.administrativeArea ?? 
                       'Cairo';
        }

        setState(() {
          _userLocation = locationName;
          _weatherKey = UniqueKey(); // Force rebuild of weather widget
        });
      }
    } catch (e) {
      // Keep default city on error
      if (mounted) {
        setState(() {
          _userLocation = 'Cairo';
          _weatherKey = UniqueKey(); // Force rebuild of weather widget
        });
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 600;

        return SizedBox(
          height: constraints.maxHeight,
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _glowController,
              _shimmerController,
              _particleController,
            ]),
            builder: (context, child) {
              return Stack(
            children: [
              // Cinematic background layers
              Positioned.fill(
                child: _CinematicBackground(
                  shimmerValue: _shimmerController.value,
                  glowValue: _glowController.value,
                ),
              ),

              // Cinematic video background
              Positioned.fill(
                child: _videoReady
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _videoController.value.size.width,
                          height: _videoController.value.size.height,
                          child: VideoPlayer(_videoController),
                        ),
                      )
                    : Image.asset(
                        'assets/images/bgd.png',
                        fit: BoxFit.cover,
                      ),
              ),

              // Subtle bottom gradient so text stays readable
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        _msBlack.withOpacity(0.25),
                        _msBlack.withOpacity(0.65),
                      ],
                      stops: const [0.0, 0.5, 0.75, 1.0],
                    ),
                  ),
                ),
              ),

              // Dust / particle overlay
              Positioned.fill(
                child: _ParticleOverlay(
                  particleValue: _particleController.value,
                  isMobile: isMobile,
                ),
              ),

              // Top bar: Logo + Menu + Weather widget
              Positioned(
                top: isMobile ? 48 : 56,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logoappbar.png',
                      height: isMobile ? 48 : 56,
                    ),
                    const Spacer(),
                    if (widget.onMenuTap != null)
                      GestureDetector(
                        onTap: widget.onMenuTap,
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: _msCarbon.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: Icon(
                            Icons.menu,
                            color: _msOrange,
                            size: isMobile ? 20 : 22,
                          ),
                        ),
                      ),
                    BlocProvider(
                      key: _weatherKey,
                      create: (_) => WeatherCubit(WeatherRepository()),
                      child: _WeatherWidget(
                        isMobile: isMobile,
                        initialLocation: _userLocation,
                      ),
                    ),
                  ],
                ),
              ),

              // Hero Content (centered)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Small label
                          Text(
                            'home.hero_label'.tr(),
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 12,
                              color: Colors.white.withOpacity(0.65),
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),

                          // Headline
                          Text(
                            'home.hero_title'.tr(),
                            style: TextStyle(
                              fontSize: isMobile ? 36 : 52,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              height: 1.05,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          // Subtitle
                          SizedBox(
                            width: isMobile ? 300 : 480,
                            child: Text(
                              'home.hero_subtitle'.tr(),
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: Colors.white.withOpacity(0.65),
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Explore Button
                          _ExploreButton(
                            onTap: () => Navigator.pushNamed(
                              context,
                              RoutesName.exploreScreen,
                            ),
                            isMobile: isMobile,
                          ),
                        ],
                      ),
                    ),
                  ),

              // Bottom bar
              Positioned(
                bottom: 28,
                left: 20,
                right: 20,
                child: Text(
                  'home.scroll_to_discover'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
      },
    );
  }

}

class _ExploreButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isMobile;

  const _ExploreButton({required this.onTap, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _msOrange,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _msOrange.withOpacity(0.35),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 36 : 48,
          vertical: isMobile ? 14 : 16,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'home.explore_button'.tr(),
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: isMobile ? 18 : 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherWidget extends StatefulWidget {
  final bool isMobile;
  final String initialLocation;

  const _WeatherWidget({
    required this.isMobile,
    required this.initialLocation,
  });

  @override
  State<_WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<_WeatherWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().loadWeather(widget.initialLocation);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String location = widget.initialLocation;
        String condition = 'Clear';
        double temperature = 32.0;
        IconData icon = Icons.wb_sunny;

        if (state is WeatherLoaded) {
          location = state.weather.location;
          condition = state.weather.condition;
          temperature = state.weather.temperature;
          icon = _getIconFromString(state.weather.icon);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _msCarbon.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 10 : 11,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    condition,
                    style: TextStyle(
                      fontSize: widget.isMobile ? 9 : 10,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(
                icon,
                color: _msOrange,
                size: widget.isMobile ? 18 : 20,
              ),
              const SizedBox(width: 6),
              Text(
                '${temperature.toStringAsFixed(0)}°C',
                style: TextStyle(
                  fontSize: widget.isMobile ? 16 : 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIconFromString(String iconString) {
    switch (iconString) {
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'cloud':
        return Icons.cloud;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'grain':
        return Icons.grain;
      case 'ac_unit':
        return Icons.ac_unit;
      default:
        return Icons.wb_sunny;
    }
  }
}

class _ParticleOverlay extends StatelessWidget {
  final double particleValue;
  final bool isMobile;

  const _ParticleOverlay({
    required this.particleValue,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _ParticlePainter(
        particleValue: particleValue,
        isMobile: isMobile,
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double particleValue;
  final bool isMobile;

  _ParticlePainter({required this.particleValue, required this.isMobile});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final random = math.Random(42);
    final count = isMobile ? 28 : 48;

    for (var i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final speed = 0.2 + random.nextDouble() * 0.4;
      final y = (baseY + particleValue * size.height * speed) % size.height;
      final length = 20 + random.nextDouble() * 60;
      final angle = random.nextDouble() * 0.3 - 0.15;

      final opacity = 0.03 + random.nextDouble() * 0.08;
      paint.color = Colors.white.withOpacity(opacity);

      canvas.drawLine(
        Offset(x, y),
        Offset(x + length * math.sin(angle), y + length * math.cos(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

class _CinematicBackground extends StatelessWidget {
  final double shimmerValue;
  final double glowValue;

  const _CinematicBackground({
    required this.shimmerValue,
    required this.glowValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(
            -1.0 + 0.2 * math.sin(shimmerValue * 2 * math.pi),
            -1.0,
          ),
          end: Alignment(
            1.0 + 0.2 * math.cos(shimmerValue * 2 * math.pi),
            1.0,
          ),
          colors: [
            _msBlack,
            _msCharcoal,
            _msCarbon,
            _msCharcoal,
            _msBlack,
          ],
          stops: [
            0.0,
            0.25 + 0.05 * glowValue,
            0.5,
            0.75 - 0.05 * glowValue,
            1.0,
          ],
        ),
      ),
    );
  }
}

