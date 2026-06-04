import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

class JobOrderCardModel {
  final int jobOrderId;
  final String? plateNumber;
  final String jobSheetNo;
  final String status;
  final String branch;
  final String carType;
  final String? bookingDate;

  JobOrderCardModel({
    required this.jobOrderId,
    required this.plateNumber,
    required this.jobSheetNo,
    required this.status,
    required this.branch,
    required this.carType,
    required this.bookingDate,
  });
}

class JobOrderCard extends StatelessWidget {
  const JobOrderCard({super.key, required this.model, this.onTap});

  final JobOrderCardModel model;
  final VoidCallback? onTap;

  _PlateParts _parsePlate(String plate) {
    final cleaned = plate.trim();
    final letters = StringBuffer();
    final numbers = StringBuffer();

    for (final codePoint in cleaned.runes) {
      final ch = String.fromCharCode(codePoint);

      final isDigit = RegExp(r'[0-9\u0660-\u0669]').hasMatch(ch);
      if (isDigit) {
        numbers.write(ch);
        continue;
      }

      final isLetter = RegExp(r'[A-Za-z\u0600-\u06FF]').hasMatch(ch);
      if (isLetter) {
        letters.write(ch);
      }
    }

    return _PlateParts(
      letters: letters.toString(),
      numbers: numbers.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final plate = model.plateNumber?.trim() ?? '';
    final parts = plate.isEmpty ? const _PlateParts(letters: '', numbers: '') : _parsePlate(plate);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        borderRadius: 0,
        backgroundColor: const Color(0xFF050505),
        borderColor: const Color(0xFFD4AF37).withOpacity(0.25),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(13, 0, 0, 0),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          children: [
            /// ====== CARD SMALL TABLE ======
            Container(
              width: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF050505),
                borderRadius: BorderRadius.zero,
                border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  children: [
                    /// HEADER
                    Container(
                      height: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD4AF37),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'EGYPT',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'مصر',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// BODY
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            child: Text(
                              (parts.numbers.trim().isEmpty ? '-' : parts.numbers.trim()),
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 34,
                            alignment: Alignment.center,
                            child: Text(
                              (parts.letters.trim().isEmpty ? '-' : parts.letters.trim()),
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
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

            const SizedBox(height: 14),

            Text(
              '${'job_order.maintenance.card.operation_order_no'.tr()}: ${model.jobSheetNo}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${'job_order.maintenance.card.location'.tr()}: ${model.branch.trim().isEmpty ? '-' : model.branch}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${'job_order.maintenance.card.car_type'.tr()}: ${model.carType.trim().isEmpty ? '-' : model.carType}',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlateParts {
  final String letters;
  final String numbers;

  const _PlateParts({
    required this.letters,
    required this.numbers,
  });
}
