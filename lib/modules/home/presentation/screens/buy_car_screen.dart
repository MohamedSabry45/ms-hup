import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/network/local/cache_helper.dart';
import 'package:reservation_workshop/core/utils/strings/prefkeys.dart';
import 'package:reservation_workshop/core/widgets/login_required_view.dart';

import '../cubit/vehicles_cubit.dart';
import '../cubit/vehicles_state.dart';
import '../widgets/add_vehicle_dialog.dart';
import '../widgets/vehicle_filters_dialog.dart';
import 'vehicle_details_screen.dart';

class BuyCarScreen extends StatefulWidget {
  const BuyCarScreen({super.key});

  @override
  State<BuyCarScreen> createState() => _BuyCarScreenState();
}

class _BuyCarScreenState extends State<BuyCarScreen> {
  void _showFiltersDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (context) => const VehicleFiltersDialog(),
    );

    if (result != null && context.mounted) {
      // Apply filters to VehiclesCubit
      final brandId = result['brandId'] as int?;
      final modelId = result['modelId'] as int?;
      final cityName = result['cityName'] as String?;
      final colorName = result['colorName'] as String?;
      final bodyTypeName = result['bodyTypeName'] as String?;
      final yearRangeName = result['yearRangeName'] as String?;
      final priceRangeName = result['priceRangeName'] as String?;
      
      context.read<VehiclesCubit>().applyFilters(
        brandId: brandId,
        modelId: modelId,
        cityName: cityName,
        colorName: colorName,
        bodyTypeName: bodyTypeName,
        yearRangeName: yearRangeName,
        priceRangeName: priceRangeName,
      );
    }
  }

 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGuest = CacheHelper.getData<bool>(key: PrefKeys.kIsGuestMode) ?? false;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF050505),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: isGuest
              ? const LoginRequiredView()
              : BlocBuilder<VehiclesCubit, VehiclesState>(
                  builder: (context, state) {
                    if (state is VehiclesInitial) {
                      context.read<VehiclesCubit>().loadFirst();
                    }

                    if (state is VehiclesLoading || state is VehiclesInitial) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.brandPrimary),
                      );
                    }

                    if (state is VehiclesError) {
                      return _VehiclesErrorView(
                        message: state.message,
                        onRetry: () => context.read<VehiclesCubit>().loadFirst(),
                      );
                    }

                    if (state is VehiclesSuccess) {
                      if (state.vehicles.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'buy_car.no_vehicles'.tr(),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return VehicleDetailsScreen(
                        vehicles: state.vehicles,
                        onFilterPressed: isGuest ? null : () => _showFiltersDialog(context),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
        ),
      ),

      floatingActionButton: isGuest
          ? null
          : FloatingActionButton(
              backgroundColor: AppColors.brandPrimary,
              foregroundColor: Colors.white,
              onPressed: () async {
                final cubit = context.read<VehiclesCubit>();
                final created = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => BlocProvider.value(
                    value: cubit,
                    child: const AddVehicleDialog(),
                  ),
                );

                if (created == true && context.mounted) {
                  context.read<VehiclesCubit>().refresh();
                }
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}

class _VehiclesErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _VehiclesErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.grey, size: 44),
            const SizedBox(height: 12),
            Text(
              'buy_car.loading_error'.tr(),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('buy_car.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

