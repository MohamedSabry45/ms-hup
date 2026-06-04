import 'package:flutter/material.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({
    super.key,
    this.onLocator,
    this.onBookService,
    this.onClientCare,
    this.onRoadsideAssistance,
  });

  final VoidCallback? onLocator;
  final VoidCallback? onBookService;
  final VoidCallback? onClientCare;
  final VoidCallback? onRoadsideAssistance;

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);

    final services = [
      _ServiceData(
        icon: Icons.build_outlined,
        title: isRtl ? 'صيانة وإصلاح' : 'Maintenance & Repair',
        subtitle: isRtl ? 'كشف وصيانة' : 'Check & service',
        color: const Color(0xFF4A90D9),
        onTap: onBookService,
      ),
      _ServiceData(
        icon: Icons.search_outlined,
        title: isRtl ? 'تشخيص' : 'Diagnostic Service',
        subtitle: isRtl ? 'فحص شامل' : 'Full checkup',
        color: const Color(0xFFD4AF37),
        onTap: onBookService,
      ),
      _ServiceData(
        icon: Icons.calendar_month_outlined,
        title: isRtl ? 'حجز خدمة' : 'Service Booking',
        subtitle: isRtl ? 'مواعيد سريعة' : 'Fast slots',
        color: const Color(0xFFF39C12),
        onTap: onBookService,
      ),
      _ServiceData(
        icon: Icons.verified_user_outlined,
        title: isRtl ? 'ضمان ودعم' : 'Warranty & Support',
        subtitle: isRtl ? 'متابعة وخدمة عملاء' : 'Care & follow up',
        color: const Color(0xFF27AE60),
        onTap: onClientCare,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4, end: 4, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRtl ? 'خدماتنا' : 'Our Services',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
        ),
        // Horizontal Services List
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _ServiceCard(service: services[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _ServiceData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ServiceData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceData service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: service.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 125,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF21262D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  service.icon,
                  color: service.color,
                  size: 22,
                ),
              ),
              // Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    service.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 10,
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
