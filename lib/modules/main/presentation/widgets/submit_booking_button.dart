import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/core/widgets/primary_button.dart';

class SubmitBookingButton extends StatelessWidget {
  const SubmitBookingButton({
    super.key,
    required this.onPressed,
    this.isError = false,
  });

  final VoidCallback onPressed;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: 'booking.book_now'.tr(),
      onPressed: onPressed,
      isError: isError,
    );
  }
}
