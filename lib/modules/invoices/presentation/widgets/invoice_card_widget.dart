import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';

import '../../data/models/sell_invoice_model.dart';

class InvoiceCardWidget extends StatelessWidget {
  final SellInvoiceModel invoice;
  final VoidCallback onTap;

  const InvoiceCardWidget({
    super.key,
    required this.invoice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: AppCard(
          borderRadius: 0,
          backgroundColor: Colors.white,
          borderColor: Colors.grey.shade300,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      invoice.invoiceNo.trim().isEmpty ? 'Invoice #${invoice.id}' : invoice.invoiceNo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Text(
                      invoice.paymentStatus.trim().isEmpty ? '-' : invoice.paymentStatus,
                      style: const TextStyle(
                        color: const Color(0xFFD4AF37),
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                invoice.transactionDate.trim().isEmpty ? '-' : invoice.transactionDate,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      invoice.status.trim().isEmpty ? '-' : invoice.status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${invoice.finalTotal.toStringAsFixed(2)}',
                    style: textTheme.titleSmall?.copyWith(
                      color: const Color(0xFFD4AF37),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
