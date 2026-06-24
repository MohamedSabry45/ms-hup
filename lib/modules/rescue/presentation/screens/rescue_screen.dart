import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/widgets/app_header.dart';
import 'package:reservation_workshop/core/widgets/login_required_view.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/date_time_field.dart';

import '../../data/models/pickup_request_model.dart';
import '../cubit/rescue_cubit.dart';
import '../cubit/rescue_state.dart';
import 'pick_location_screen.dart';

class RescueScreen extends StatefulWidget {
  const RescueScreen({super.key});

  @override
  State<RescueScreen> createState() => _RescueScreenState();
}

class _RescueScreenState extends State<RescueScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _deviceId;
  int? _locationId;
  int? _serviceId;
  DateTime? _bookingStart;

  double? _pickupLat;
  double? _pickupLng;

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.text = '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<RescueCubit>().load(customerInfoCubit: context.read<CustomerInfoCubit>());
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'rescue.select_datetime'.tr();
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm:00';
  }

  Future<void> _pickBookingStart() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _bookingStart ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_bookingStart ?? now),
    );
    if (time == null) return;

    setState(() {
      _bookingStart = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _pickLocationFromMap() async {
    final initialLat = _pickupLat;
    final initialLng = _pickupLng;

    final picked = await Navigator.of(context).push<PickedLocation>(
      MaterialPageRoute(
        builder: (_) => PickLocationScreen(
          initialLatitude: initialLat,
          initialLongitude: initialLng,
        ),
      ),
    );

    if (picked == null) return;

    setState(() {
      _pickupLat = picked.latitude;
      _pickupLng = picked.longitude;
      _locationController.text = _locationLabel();
    });
  }

  String _locationLabel() {
    if (_pickupLat == null || _pickupLng == null) return 'rescue.location_pick_on_map'.tr();
    return 'rescue.location_picked_success'.tr();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_deviceId == null ||
        _locationId == null ||
        _serviceId == null ||
        _bookingStart == null ||
        _pickupLat == null ||
        _pickupLng == null) {
      Toasters.show('rescue.toast_fill_required'.tr());
      return;
    }

    final request = PickupRequestModel(
      deviceId: _deviceId!,
      locationId: _locationId!,
      serviceId: _serviceId!,
      bookingStart: _formatDateTime(_bookingStart),
      pickupLatitude: _pickupLat!,
      pickupLongitude: _pickupLng!,
      bookingNote: _noteController.text,
    );

    context.read<RescueCubit>().submit(request: request);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: context.locale.languageCode == 'ar' ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: 'rescue.title'.tr(),
                onBack: () => Navigator.pop(context),
                titleColor: Colors.white,
              ),
              Expanded(
                child: BlocConsumer<RescueCubit, RescueState>(
                  listener: (context, state) {
                    if (state is RescueError) {
                      Toasters.show(state.message);
                    }
                    if (state is RescueSuccess) {
                      Toasters.show(state.message);
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is RescueLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.20),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'rescue.loading'.tr(),
                              style: textTheme.bodyMedium?.copyWith(
                                color: const Color.fromARGB(153, 255, 255, 255),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is RescueError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error_outline_rounded,
                                  size: 48,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is RescueGuestNotAllowed) {
                      return const LoginRequiredView();
                    }

                    if (state is! RescueLoaded) {
                      return const SizedBox.shrink();
                    }

                    final isGuest = state.isGuest;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        20,
                        16,
                        20,
                        MediaQuery.of(context).viewInsets.bottom + 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildSection(
                              title: 'rescue.section_request_data'.tr(),
                              icon: Icons.directions_car_rounded,
                              children: [
                                _buildSimpleDropdown(
                                  label: 'rescue.label_car'.tr(),
                                  value: _deviceId,
                                  items: state.cars
                                      .map(
                                        (c) => DropdownMenuItem<int>(
                                          value: c.id,
                                          child: Text(
                                            '${c.device} ${c.model} ${(c.plateNumber ?? '').trim()}'.trim(),
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => _deviceId = v),
                                ),
                                const SizedBox(height: 16),
                                _buildSimpleDropdown(
                                  label: 'rescue.label_branch'.tr(),
                                  value: _locationId,
                                  items: state.branches
                                      .where((b) => b.isCarStation == 1)
                                      .map(
                                        (b) => DropdownMenuItem<int>(
                                          value: b.id,
                                          child: Text(
                                            b.name,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      _locationId = v;
                                      _serviceId = null;
                                    });
                                    if (v != null) {
                                      context.read<RescueCubit>().loadServices(locationId: v);
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                _buildSimpleDropdown(
                                  label: 'rescue.label_service'.tr(),
                                  value: _serviceId,
                                  items: state.services
                                      .map(
                                        (s) => DropdownMenuItem<int>(
                                          value: s.id,
                                          child: Text(
                                            s.name,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => _serviceId = v),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              title: 'rescue.section_datetime_location'.tr(),
                              icon: Icons.access_time_rounded,
                              children: [
                                _buildSimpleField(
                                  label: 'rescue.label_booking_start'.tr(),
                                  value: _formatDateTime(_bookingStart),
                                  onTap: _pickBookingStart,
                                ),
                                const SizedBox(height: 16),
                                _buildSimpleField(
                                  label: 'rescue.label_location'.tr(),
                                  value: _locationLabel(),
                                  onTap: _pickLocationFromMap,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildSection(
                              title: 'rescue.section_notes'.tr(),
                              icon: Icons.note_alt_rounded,
                              children: [
                                TextFormField(
                                  controller: _noteController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'rescue.notes_hint'.tr(),
                                    hintStyle: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF1A1A1A),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.all(16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (isGuest)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'auth.login_required_message'.tr(),
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFD4AF37),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RoutesName.enterMobileScreen,
                                          (route) => false,
                                        );
                                      },
                                      child: Text(
                                        'auth.login_button'.tr(),
                                        style: textTheme.titleMedium?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFD4AF37),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: state.isSubmitting ? null : _submit,
                                  child: state.isSubmitting
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'rescue.submit'.tr(),
                                          style: textTheme.titleMedium?.copyWith(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFFD4AF37)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSimpleDropdown({
    required String label,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required void Function(int?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: (v) => (v == null) ? 'rescue.required_field'.tr() : null,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0A0A0A),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white54),
              ],
            ),
          ),
        ),
      ],
    );
  }

}