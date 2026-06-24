import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';

class BookingDetailsCard extends StatelessWidget {
  const BookingDetailsCard({
    super.key,
    required this.model,
    required this.onBack,
    required this.onConfirm,
    this.canConfirm = true,
    this.bookingType,
  });

  final NotificationCardModel? model;
  final VoidCallback onBack;
  final VoidCallback onConfirm;
  final bool canConfirm;
  final String? bookingType;

  bool get _showCarDetails => bookingType == null || bookingType!.isEmpty;

  String? get _formattedDate {
    final raw = model?.dateTime;
    if (raw == null || raw.isEmpty) return null;
    try {
      final dt = DateTime.parse(raw);
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      final hour = dt.hour.toString().padLeft(2, '0');
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$day-$month-$year $hour:$minute';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Center(
        child: Container(
          width: screenWidth > 420 ? 420 : screenWidth - 32,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ===== HEADER =====
              _buildHeader(),

              /// ===== CUSTOMER INFO =====
              _buildSection(
                context,
                icon: Icons.person_outline,
                title: 'booking_details.customer_info'.tr(),
                children: [
                  _DetailTile(
                    icon: Icons.person_outline,
                    label: 'booking_details.name'.tr(),
                    value: model?.name,
                  ),
                  _DetailTile(
                    icon: Icons.phone_outlined,
                    label: 'booking_details.phone'.tr(),
                    value: model?.phone,
                  ),
                ],
              ),

              _buildDivider(),

              /// ===== BOOKING INFO =====
              _buildSection(
                context,
                icon: Icons.event_available_outlined,
                title: 'booking_details.booking_info'.tr(),
                children: [
                  _DetailTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'booking_details.date'.tr(),
                    value: _formattedDate,
                  ),
                  _DetailTile(
                    icon: Icons.spa_outlined,
                    label: 'booking_details.service'.tr(),
                    value: model?.service,
                  ),
                  if (_showCarDetails) ...[
                    _DetailTile(
                      icon: Icons.branding_watermark_outlined,
                      label: 'booking_details.brand'.tr(),
                      value: model?.car,
                    ),
                    _DetailTile(
                      icon: Icons.directions_car_outlined,
                      label: 'booking_details.model'.tr(),
                      value: model?.carModel,
                    ),
                    _DetailTile(
                      icon: Icons.pin_outlined,
                      label: 'booking_details.plate'.tr(),
                      value: model?.plate,
                    ),
                  ],
                  _DetailTile(
                    icon: Icons.location_on_outlined,
                    label: 'booking_details.branch'.tr(),
                    value: model?.branch,
                  ),
                  _DetailTile(
                    icon: Icons.edit_note_outlined,
                    label: 'booking_details.notes'.tr(),
                    value: model?.area,
                  ),
                ],
              ),

              /// ===== ACTIONS =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: OutlinedButton(
                          onPressed: onBack,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFD4AF37),
                            side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            backgroundColor: const Color(0xFF0A0A0A),
                          ),
                          child: Text(
                            'booking_details.back'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: canConfirm ? onConfirm : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'booking_details.confirm'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF141414), Color(0xFF0A0A0A)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_note_outlined,
              size: 24,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'booking_details.title'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFD4AF37),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFD4AF37).withOpacity(0.1),
              ),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: const Color(0xFFD4AF37).withOpacity(0.12),
      ),
    );
  }
}

/// ===== DETAIL TILE =====
class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final displayValue = value?.isNotEmpty == true ? value! : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.08),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              icon,
              size: 13,
              color: const Color(0xFFD4AF37).withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
