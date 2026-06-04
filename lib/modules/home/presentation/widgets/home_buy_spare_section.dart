import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';

class HomeBuySpareSection extends StatelessWidget {
  const HomeBuySpareSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cardData = _CardData(
      icon: Icons.directions_car,
      label: tr('home.contact_cars'),
      route: RoutesName.buyCarScreen,
      imageAsset: 'assets/images/buy cars.png',
    );

    return _StaticCard(
      data: cardData,
    );
  }
}

class _CardData {
  final IconData icon;
  final String label;
  final String route;
  final String imageAsset;

  const _CardData({
    required this.icon,
    required this.label,
    required this.route,
    required this.imageAsset,
  });
}

class _StaticCard extends StatelessWidget {
  final _CardData data;

  const _StaticCard({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, data.route),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              Image.asset(
                data.imageAsset,
                fit: BoxFit.cover,
              ),
              // Overlay gradient for text readability
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
              // Content
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(
                          data.icon,
                          size: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            data.label,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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