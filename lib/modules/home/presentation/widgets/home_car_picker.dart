import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';

class HomeCarPicker {
  static Future<CustomerCar?> show({
    required BuildContext context,
    required List<CustomerCar> cars,
    required int? selectedCarId,
    required String Function(CustomerCar) carLabel,
  }) async {
    if (cars.isEmpty) return null;

    return await showModalBottomSheet<CustomerCar>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        t(ctx, 'home.my_cars', ar: 'سياراتي', en: 'My cars'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: cars.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      final isSelected = selectedCarId != null ? car.id == selectedCarId : false;
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.pop(ctx, car),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.brandPrimarySoft2 : const Color(0xFFF7F7F9),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.brandPrimarySoft,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: (car.carImage != null && car.carImage!.isNotEmpty)
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.network(
                                          car.carImage!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return const Icon(Icons.directions_car_filled_outlined, color: AppColors.brandPrimary);
                                          },
                                        ),
                                      )
                                    : const Icon(Icons.directions_car_filled_outlined, color: AppColors.brandPrimary),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${car.device} ${car.model}'.trim(),
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (car.plateNumber ?? '').trim().isEmpty ? car.carType : (car.plateNumber ?? '').trim(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.grey7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check_circle, color: AppColors.brandPrimary)
                              else
                                const Icon(Icons.chevron_left, color: AppColors.grey7),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
