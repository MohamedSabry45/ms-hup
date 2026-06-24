import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';
import 'package:reservation_workshop/config/style/app_spacing.dart';
import 'package:reservation_workshop/core/components/toasters.dart';
import 'package:reservation_workshop/core/widgets/app_card.dart';
import 'package:reservation_workshop/modules/branch/domain/entities/branch.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_cubit.dart';
import 'package:reservation_workshop/modules/branch/presentation/cubits/branch_cubit/branch_state.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_cubit.dart';
import 'package:reservation_workshop/modules/customer/presentation/cubits/customer_info_cubit/customer_info_state.dart';
import 'package:reservation_workshop/modules/main/presentation/screens/booking_details_args.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/date_time_field.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notes_field.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/notification_card.dart';
import 'package:reservation_workshop/modules/main/presentation/widgets/submit_booking_button.dart';
import 'package:reservation_workshop/modules/service/domain/entities/service.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_cubit.dart';
import 'package:reservation_workshop/modules/service/presentation/cubits/service_cubit/service_state.dart';

class BarberBookingTab extends StatefulWidget {
  const BarberBookingTab({super.key});

  @override
  State<BarberBookingTab> createState() => _BarberBookingTabState();
}

class _BarberBookingTabState extends State<BarberBookingTab> {
  static const int _barberBranchId = 3; // barber branch
  int? _selectedServiceId;
  DateTime _selectedDateTime = DateTime.now();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load services for this specific branch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ServiceCubit>().load(locationId: _barberBranchId);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _selectedDateTime,
    );
    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (time == null) return;

    if (!mounted) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatBookingStart(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final customerState = context.watch<CustomerInfoCubit>().state;
    final customerName = customerState is CustomerInfoSuccess ? customerState.info.name : '';
    final greeting = customerName.isEmpty
        ? 'booking.greeting'.tr()
        : 'booking.greeting_named'.tr(args: [customerName]);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 18,
                  backgroundGradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF080808),
                      Color(0xFF111111),
                    ],
                  ),
                  borderColor: const Color(0xFFD4AF37).withOpacity(0.25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        greeting,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'booking.barber_subtitle'.tr(),
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionHeader(
                        icon: Icons.location_on_outlined,
                        label: 'booking.select_branch'.tr(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      BlocBuilder<BranchCubit, BranchState>(
                        builder: (context, branchState) {
                          final branches = branchState is BranchSuccess ? branchState.branches : const <Branch>[];
                          final barberBranch = branches.where((b) => b.id == _barberBranchId).toList();
                          final branchName = barberBranch.isNotEmpty ? barberBranch.first.name : 'Barber';

                          return _BranchInfoCard(name: branchName);
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BlocBuilder<ServiceCubit, ServiceState>(
                        builder: (context, serviceState) {
                          final services = serviceState is ServiceSuccess ? serviceState.services : const <Service>[];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _SectionHeader(
                                icon: Icons.spa_outlined,
                                label: 'booking.select_service'.tr(),
                                isRequired: true,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 2.55,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: services
                                    .map(
                                      (s) => _ServiceCard(
                                        title: s.name,
                                        selected: _selectedServiceId == s.id,
                                        onTap: () => setState(() => _selectedServiceId = s.id),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionHeader(
                        icon: Icons.calendar_today_outlined,
                        label: 'booking.select_datetime'.tr(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      DateTimeField(
                        label: '',
                        labelColor: Colors.white,
                        fillColor: const Color(0xFF141414),
                        textColor: Colors.white,
                        iconColor: Colors.white70,
                        valueText: _formatDateTime(_selectedDateTime),
                        onPick: _pickDateTime,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _SectionHeader(
                        icon: Icons.edit_note_outlined,
                        label: 'booking.describe_problem'.tr(),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      NotesField(
                        hintText: '',
                        fillColor: const Color(0xFF141414),
                        textColor: Colors.white,
                        hintColor: Colors.white54,
                        controller: _notesController,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    SubmitBookingButton(
                      onPressed: () {
                        final serviceId = _selectedServiceId;

                        if (serviceId == null) {
                          Toasters.show('booking.toast_select_service'.tr());
                          return;
                        }

                        final customerState = context.read<CustomerInfoCubit>().state;
                        final name = customerState is CustomerInfoSuccess ? customerState.info.name : '';
                        final phone = customerState is CustomerInfoSuccess ? customerState.info.mobile : '';

                        final branchState = context.read<BranchCubit>().state;
                        final branches = branchState is BranchSuccess ? branchState.branches : const <Branch>[];
                        final selectedBranch = branches.where((b) => b.id == _barberBranchId).toList();

                        final serviceState = context.read<ServiceCubit>().state;
                        final services = serviceState is ServiceSuccess ? serviceState.services : const <Service>[];
                        final selectedService = services.where((s) => s.id == serviceId).toList();

                        final note = _notesController.text.trim();
                        final bookingStart = _formatBookingStart(_selectedDateTime);

                        final model = NotificationCardModel(
                          workOrderNo: '-',
                          customer: '',
                          car: '-',
                          carModel: '-',
                          plate: '-',
                          status: '-',
                          dateTime: bookingStart,
                          service: selectedService.isNotEmpty ? selectedService.first.name : '-',
                          branch: selectedBranch.isNotEmpty ? selectedBranch.first.name : '-',
                          area: note.isEmpty ? '-' : note,
                          name: name,
                          phone: phone,
                        );

                        final args = BookingDetailsArgs(
                          model: model,
                          bookingStart: bookingStart,
                          locationId: _barberBranchId,
                          serviceId: serviceId,
                          bookingNote: note,
                          bookingType: 'barber',
                        );

                        Navigator.pushNamed(
                          context,
                          RoutesName.bookingDetailsScreen,
                          arguments: args,
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'booking.can_edit_before_confirm'.tr(),
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.grey7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    this.isRequired = false,
  });

  final IconData icon;
  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37).withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFFD4AF37)),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD4AF37),
            ),
          ),
        ],
      ],
    );
  }
}

class _BranchInfoCard extends StatelessWidget {
  const _BranchInfoCard({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF141414)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storefront_outlined, size: 18, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفرع الحالي',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: textTheme.bodyMedium?.copyWith(
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
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD4AF37) : const Color(0xFF141414),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFFD4AF37) : const Color(0xFFD4AF37).withOpacity(0.15),
            width: 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.35),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (selected) ...[
              const Icon(Icons.check_circle, size: 14, color: Colors.black),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
