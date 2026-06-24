import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';

import '../../domain/entities/vehicle.dart';
import '../cubit/vehicle_details_cubit.dart';
import '../cubit/vehicle_details_state.dart';
import '../widgets/vehicle_details/vehicle_inquiry_dialog.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final List<Vehicle> vehicles;
  final int initialIndex;
  final VoidCallback? onFilterPressed;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicles,
    this.initialIndex = 0,
    this.onFilterPressed,
  });

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void didUpdateWidget(VehicleDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.vehicles.length != oldWidget.vehicles.length ||
        widget.vehicles.isEmpty != oldWidget.vehicles.isEmpty ||
        (widget.vehicles.isNotEmpty && oldWidget.vehicles.isNotEmpty &&
         widget.vehicles.first.id != oldWidget.vehicles.first.id)) {
      _currentIndex = 0;
      _pageController.jumpToPage(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < widget.vehicles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          itemCount: widget.vehicles.length,
          itemBuilder: (context, index) {
            return BlocProvider<VehicleDetailsCubit>(
              create: (_) => VehicleDetailsCubit(id: widget.vehicles[index].id)..load(),
              child: _VehicleDetailPage(
                vehicle: widget.vehicles[index],
                onInquiry: () => _showInquiryDialog(context, widget.vehicles[index].id),
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _TopNavButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'buy_car.showroom'.tr().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: _msOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${_currentIndex + 1}/${widget.vehicles.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (widget.onFilterPressed != null) ...[
                        const SizedBox(width: 8),
                        _TopNavButton(
                          icon: Icons.tune_outlined,
                          onTap: widget.onFilterPressed,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 16,
          child: Center(
            child: _NavArrow(
              icon: Icons.arrow_back_ios,
              onTap: _currentIndex > 0 ? _previous : null,
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 16,
          child: Center(
            child: _NavArrow(
              icon: Icons.arrow_forward_ios,
              onTap: _currentIndex < widget.vehicles.length - 1 ? _next : null,
            ),
          ),
        ),
      ],
    );
  }

  void _showInquiryDialog(BuildContext context, int vehicleId) {
    showDialog(
      context: context,
      builder: (context) => VehicleInquiryDialog(vehicleId: vehicleId),
    );
  }
}

const Color _msOrange = Color(0xFFF78905);

class _TopNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _TopNavButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Icon(
          icon,
          color: onTap != null ? Colors.white : Colors.white.withOpacity(0.3),
          size: 20,
        ),
      ),
    );
  }
}

class _VehicleDetailPage extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onInquiry;

  const _VehicleDetailPage({
    required this.vehicle,
    required this.onInquiry,
  });

  String _formatNumber(num value) {
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    final raw = buf.toString();
    return raw.endsWith(',') ? raw.substring(0, raw.length - 1) : raw;
  }

  String _formatPrice(String raw) {
    final parsed = double.tryParse(raw) ?? double.tryParse(raw.replaceAll(',', ''));
    if (parsed == null) return raw;
    return _formatNumber(parsed);
  }

  String _engineText(int cc, int cylinders) {
    final liters = (cc / 1000).toStringAsFixed(1);
    return '$liters\u200bL I$cylinders ${cylinders > 1 ? 'Twin-Turbo' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VehicleDetailsCubit, VehicleDetailsState>(
      builder: (context, state) {
        final d = state is VehicleDetailsSuccess ? state.details : null;

        return Stack(
          fit: StackFit.expand,
          children: [
            _buildImage(d?.primaryMedia?.filePath ?? vehicle.primaryImageUrl),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.65),
                    Colors.black.withOpacity(0.95),
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _msOrange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'buy_car.for_sale'.tr().toUpperCase(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          vehicle.year.toString(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${vehicle.make} ${vehicle.modelName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'buy_car.tagline'.tr(),
                      style: TextStyle(
                        color: _msOrange.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      d?.description ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 16,
                      runSpacing: 10,
                      children: [
                        _SpecPill(
                          icon: Icons.speed_outlined,
                          value: '${_formatNumber(vehicle.mileageKm)} KM',
                        ),
                        _SpecPill(
                          icon: Icons.settings_outlined,
                          value: d?.transmission ?? vehicle.bodyType,
                        ),
                        _SpecPill(
                          icon: Icons.calendar_today_outlined,
                          value: vehicle.year.toString(),
                        ),
                        if (d != null && d.engineCapacityCc > 0)
                          _SpecPill(
                            icon: Icons.bolt_outlined,
                            value: _engineText(d.engineCapacityCc, d.cylinderCount),
                          ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _formatPrice(vehicle.listingPrice),
                              style: const TextStyle(
                                color: _msOrange,
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vehicle.currency,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: onInquiry,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: _msOrange,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'buy_car.inquire'.tr(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String? url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderImage(),
      );
    }
    return _placeholderImage();
  }

  Widget _placeholderImage() {
    return Container(
      color: const Color(0xFF0A0A0A),
      alignment: Alignment.center,
      child: const Icon(Icons.directions_car, color: AppColors.grey7, size: 64),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _NavArrow({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.04),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: onTap != null ? Colors.white : Colors.white.withOpacity(0.3),
          size: 18,
        ),
      ),
    );
  }
}

class _SpecPill extends StatelessWidget {
  final IconData icon;
  final String value;

  const _SpecPill({
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: _msOrange),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            color: Colors.white.withOpacity(0.75),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
