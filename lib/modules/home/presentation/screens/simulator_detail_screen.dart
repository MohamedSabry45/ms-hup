import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

const Color _msOrange = Color(0xFFF78905);
const Color _msCharcoal = Color(0xFF1a1a1a);

class SimulatorDetailScreen extends StatelessWidget {
  const SimulatorDetailScreen({super.key});

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
                  _buildExperiences(context, isMobile),
                  _buildSetup(context, isMobile),
                  _buildFeatures(context),
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
            'assets/images/recing similator.png',
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
                    'simulator.vip_tag'.tr(),
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
                  'simulator.title'.tr(),
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
        'simulator.description'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.55),
          fontSize: 14,
          height: 1.6,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildExperiences(BuildContext context, bool isMobile) {
    final experiences = [
      _Experience(
        icon: Icons.directions_car_outlined,
        title: 'simulator.experience_1_title'.tr(),
        subtitle: 'simulator.experience_1_subtitle'.tr(),
        price: 'simulator.experience_1_price'.tr(),
      ),
      _Experience(
        icon: Icons.landscape_outlined,
        title: 'simulator.experience_2_title'.tr(),
        subtitle: 'simulator.experience_2_subtitle'.tr(),
        price: 'simulator.experience_2_price'.tr(),
      ),
      _Experience(
        icon: Icons.donut_large_outlined,
        title: 'simulator.experience_3_title'.tr(),
        subtitle: 'simulator.experience_3_subtitle'.tr(),
        price: 'simulator.experience_3_price'.tr(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'simulator.choose_experience'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 18),
          ...experiences.map((e) => _ExperienceCard(experience: e)),
        ],
      ),
    );
  }

  Widget _buildSetup(BuildContext context, bool isMobile) {
    final setupItems = [
      _SetupItem(icon: Icons.trending_up_outlined, title: 'simulator.setup_motion'.tr()),
      _SetupItem(icon: Icons.refresh_outlined, title: 'simulator.setup_feedback'.tr()),
      _SetupItem(icon: Icons.timer_outlined, title: 'simulator.setup_telemetry'.tr()),
      _SetupItem(icon: Icons.people_outline, title: 'simulator.setup_suites'.tr()),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'simulator.setup_title'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 18),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
            children: setupItems.map((e) => _SetupCard(item: e)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    final features = [
      'simulator.feature_1'.tr(),
      'simulator.feature_2'.tr(),
      'simulator.feature_3'.tr(),
      'simulator.feature_4'.tr(),
      'simulator.feature_5'.tr(),
      'simulator.feature_6'.tr(),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((f) => Padding(
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
              children: [
                Icon(Icons.format_quote, color: _msOrange, size: 20),
                const SizedBox(width: 6),
                Text(
                  'simulator.testimonial_tag'.tr(),
                  style: const TextStyle(
                    color: _msOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'simulator.testimonial_quote'.tr(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'simulator.testimonial_author'.tr(),
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
              'simulator.book_session'.tr(),
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
      arguments: {'mainTab': 2, 'bookingSubTab': 2},
    );
  }
}

class _Experience {
  final IconData icon;
  final String title;
  final String subtitle;
  final String price;

  _Experience({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
  });
}

class _ExperienceCard extends StatelessWidget {
  final _Experience experience;

  const _ExperienceCard({required this.experience});

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
            child: Icon(experience.icon, color: _msOrange, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  experience.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  experience.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                experience.price,
                style: const TextStyle(
                  color: _msOrange,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'simulator.per_hour'.tr(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () => _goToBooking(context),
                child: Text(
                  'simulator.book_now'.tr(),
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
      arguments: {'mainTab': 2, 'bookingSubTab': 2},
    );
  }
}

class _SetupItem {
  final IconData icon;
  final String title;

  _SetupItem({required this.icon, required this.title});
}

class _SetupCard extends StatelessWidget {
  final _SetupItem item;

  const _SetupCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _msCharcoal,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: _msOrange, size: 28),
          const SizedBox(height: 10),
          Text(
            item.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
