import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

const Color _msOrange = Color(0xFFF78905);
const Color _msCharcoal = Color(0xFF1a1a1a);

class BarberDetailScreen extends StatelessWidget {
  const BarberDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHero(context, isMobile),
                  _buildDescription(context),
                  _buildServices(context),
                  _buildWhyBarber(context),
                  _buildTestimonial(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            _buildCloseButton(context),
            _buildBottomCta(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isMobile) {
    return SizedBox(
      height: isMobile ? 380 : 480,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/the gentlement baraber.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.95),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _msOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'barber.tag'.tr(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'barber.title'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 36 : 48,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Text(
        'barber.description'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.55),
          fontSize: 14,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildServices(BuildContext context) {
    final services = [
      _Service(
        icon: Icons.content_cut_outlined,
        title: 'barber.service_1_title'.tr(),
        duration: 'barber.service_1_duration'.tr(),
        price: 'barber.service_1_price'.tr(),
      ),
      _Service(
        icon: Icons.hot_tub_outlined,
        title: 'barber.service_2_title'.tr(),
        duration: 'barber.service_2_duration'.tr(),
        price: 'barber.service_2_price'.tr(),
      ),
      _Service(
        icon: Icons.face_outlined,
        title: 'barber.service_3_title'.tr(),
        duration: 'barber.service_3_duration'.tr(),
        price: 'barber.service_3_price'.tr(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'barber.services_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 18),
          ...services.map((s) => _ServiceCard(service: s)),
        ],
      ),
    );
  }

  Widget _buildWhyBarber(BuildContext context) {
    final features = [
      'barber.feature_1'.tr(),
      'barber.feature_2'.tr(),
      'barber.feature_3'.tr(),
      'barber.feature_4'.tr(),
      'barber.feature_5'.tr(),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'barber.why_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 18),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check, color: _msOrange, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildTestimonial(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _msOrange.withOpacity(0.15),
              _msOrange.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _msOrange.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(Icons.star, color: _msOrange, size: 16);
              }),
            ),
            const SizedBox(height: 12),
            Text(
              'barber.testimonial_quote'.tr(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'barber.testimonial_author'.tr(),
              style: const TextStyle(
                color: _msOrange,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 8,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCta(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0),
              Colors.black.withOpacity(0.9),
              Colors.black,
            ],
          ),
        ),
        child: SizedBox(
          height: 54,
          child: ElevatedButton(
            onPressed: () => _goToBooking(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _msOrange,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              'barber.book_appointment'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _goToBooking(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.requestsTabsScreen,
      arguments: {'mainTab': 2, 'bookingSubTab': 1},
    );
  }
}

class _Service {
  final IconData icon;
  final String title;
  final String duration;
  final String price;

  _Service({
    required this.icon,
    required this.title,
    required this.duration,
    required this.price,
  });
}

class _ServiceCard extends StatelessWidget {
  final _Service service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _msCharcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _msOrange.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(service.icon, color: _msOrange, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.4), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      service.duration,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                service.price,
                style: const TextStyle(
                  color: _msOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _goToBooking(context),
                child: Text(
                  'barber.book_now'.tr(),
                  style: const TextStyle(
                    color: _msOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _goToBooking(BuildContext context) {
    Navigator.pushNamed(
      context,
      RoutesName.requestsTabsScreen,
      arguments: {'mainTab': 2, 'bookingSubTab': 1},
    );
  }
}
