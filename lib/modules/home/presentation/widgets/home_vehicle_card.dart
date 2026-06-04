import 'package:flutter/material.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';
import 'package:reservation_workshop/modules/customer/presentation/screens/car_details_screen.dart';

class HomeVehicleCard extends StatelessWidget {
  final CustomerCar? car;
  final VoidCallback? onTap;
  final VoidCallback? onSwitchPressed;

  const HomeVehicleCard({
    super.key,
    this.car,
    this.onTap,
    this.onSwitchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);
    final carImage = (car?.carImage ?? '').trim();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF050505),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Image with switch button on top
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  children: [
                    // Image
                    carImage.isNotEmpty
                        ? Image.network(
                            carImage,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Image.asset(
                                'assets/images/bannar-2.png',
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/bannar-2.png',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    // Switch button on top-right
                    if (car != null && onSwitchPressed != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: InkWell(
                          onTap: onSwitchPressed,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0A),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.20),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Vehicle Info
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Expanded(
                      child: Text(
                        car != null ? '${car!.device} ${car!.model}' : (isRtl ? 'عربية جولف' : 'GOLF CART'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // More options icon
                    if (car != null)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CarDetailsScreen(car: car!),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.more_horiz,
                            color: Colors.white54,
                            size: 24,
                          ),
                        ),
                      )
                    else
                      const Icon(
                        Icons.more_horiz,
                        color: Colors.white54,
                        size: 24,
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
}
