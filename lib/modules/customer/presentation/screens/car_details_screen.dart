import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/core/widgets/main_app_bar.dart';
import 'package:reservation_workshop/modules/customer/domain/entities/customer_car.dart';

class CarDetailsScreen extends StatefulWidget {
  final CustomerCar car;

  const CarDetailsScreen({
    super.key,
    required this.car,
  });

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = context.locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MainAppBar(
        onNotificationsPressed: () {},
        onMenuPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Car Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.brandSurface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Car Image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: widget.car.carImage != null && widget.car.carImage!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            widget.car.carImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.directions_car,
                              size: 50,
                              color: AppColors.brandPrimary,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.directions_car,
                          size: 50,
                          color: AppColors.brandPrimary,
                        ),
                ),
                const SizedBox(height: 16),
                // Car Name
                Text(
                  '${widget.car.device} ${widget.car.model}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Plate Number
                if (widget.car.plateNumber != null && widget.car.plateNumber!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.brandPrimary),
                    ),
                    child: Text(
                      widget.car.plateNumber!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brandPrimary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.brandPrimary,
                borderRadius: BorderRadius.circular(12),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: isRtl ? 'معلومات' : 'Info'),
                Tab(text: isRtl ? 'الصيانة' : 'Maintenance'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Info Tab
                _buildInfoTab(),
                // Maintenance Tab
                _buildMaintenanceTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.directions_car,
            title: 'car.model'.tr(),
            value: '${widget.car.device} ${widget.car.model}',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.color_lens,
            title: 'car.color'.tr(),
            value: widget.car.color,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.calendar_today,
            title: 'car.year'.tr(),
            value: widget.car.manufacturingYear,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.confirmation_number,
            title: 'car.chassis'.tr(),
            value: widget.car.chassisNumber,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.category,
            title: 'car.type'.tr(),
            value: widget.car.carType,
          ),
          if (widget.car.plateNumber != null && widget.car.plateNumber!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.pin,
              title: 'car.plate'.tr(),
              value: widget.car.plateNumber!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.brandSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.brandPrimary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTab() {
    final items = widget.car.tax;

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'No maintenance tips yet'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0A0A0A)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.brandSurface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.build,
                      color: AppColors.brandPrimary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title.isEmpty ? '-' : item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMaintenanceInfo({
    required IconData icon,
    required String label,
    required String date,
    required String km,
    bool isNext = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isNext ? AppColors.brandPrimary : Colors.white,
          ),
        ),
        Text(
          km,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

}
