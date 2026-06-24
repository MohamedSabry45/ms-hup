import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/login_required_view.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/add_booking_cubit/add_booking_cubit.dart';
import 'package:reservation_workshop/modules/bookings/presentation/cubits/add_booking_cubit/add_booking_state.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/booking_details_args.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/booking_details_card.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  Future<void> _showResultDialog(
    BuildContext context, {
    required String title,
    required String message,
    required bool popScreenAfter,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final isRtl = ctx.locale.languageCode == 'ar';
        return Directionality(
          textDirection: isRtl ? ui.TextDirection.rtl : ui.TextDirection.ltr,
          child: AlertDialog(
            backgroundColor: const Color(0xFF050505),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: const Color(0xFFD4AF37).withOpacity(0.25), width: 1.2),
            ),
            title: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
            ),
            content: Text(
              message.trim().isEmpty ? '-' : message,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (popScreenAfter) {
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'common.ok'.tr(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFFD4AF37)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    final BookingDetailsArgs? bookingArgs = args is BookingDetailsArgs ? args : null;
    final NotificationCardModel? model = bookingArgs?.model ?? (args is NotificationCardModel ? args : null);

    final canConfirm = bookingArgs != null;

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        elevation: 0,
        title: Text(
          'booking_details.title'.tr(),
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w900),
        ),
        foregroundColor: const Color(0xFFD4AF37),
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF050505),
              Color(0xFF000000),
            ],
          ),
        ),
        child: BlocConsumer<AddBookingCubit, AddBookingState>(
        listener: (context, state) {
          if (state is AddBookingSuccess) {
            _showResultDialog(
              context,
              title: 'booking_details.success_title'.tr(),
              message: state.message,
              popScreenAfter: true,
            );
          }
          if (state is AddBookingError) {
            _showResultDialog(
              context,
              title: 'booking_details.error_title'.tr(),
              message: state.message,
              popScreenAfter: false,
            );
          }
        },
        builder: (context, state) {
          if (state is AddBookingGuestNotAllowed) {
            return const LoginRequiredView();
          }
          final isLoading = state is AddBookingLoading;

          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Center(
                  child: BookingDetailsCard(
                    model: model,
                    canConfirm: canConfirm,
                    bookingType: bookingArgs?.bookingType,
                    onBack: () => Navigator.pop(context),
                    onConfirm: () {
                      if (!canConfirm || bookingArgs == null) {
                        return;
                      }
                      if (isLoading) {
                        return;
                      }

                      context.read<AddBookingCubit>().addBooking(
                            bookingStart: bookingArgs.bookingStart,
                            locationId: bookingArgs.locationId,
                            bookingNote: bookingArgs.bookingNote,
                            serviceId: bookingArgs.serviceId,
                            deviceId: bookingArgs.deviceId,
                            bookingType: bookingArgs.bookingType,
                          );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
      ),
    );
  }
}
