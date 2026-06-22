import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/config/style/app_colors.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    final cards = [
      _ExploreCardData(
        tag: 'home.explore.about_us',
        title: 'home.explore.what_is_ms_hub',
        image: 'assets/images/building.png',
        icon: Icons.arrow_outward,
        route: RoutesName.menuAboutCenterScreen,
        fullWidth: true,
        height: 550,
      ),
      _ExploreCardData(
        tag: 'home.explore.showroom',
        title: 'home.explore.car_of_the_month',
        image: 'assets/images/car of the month.png',
        icon: Icons.directions_car_filled,
        route: RoutesName.buyCarScreen,
        fullWidth: true,
      ),
      _ExploreCardData(
        tag: 'home.explore.signature_service',
        title: 'home.explore.gentleman_barber',
        image: 'assets/images/the gentlement baraber.png',
        icon: Icons.content_cut,
        route: RoutesName.mainScreen,
        arguments: 2,
        fullWidth: true,
      ),
      _ExploreCardData(
        tag: 'BMW / RR/MINI',
        title: 'Racing Simulator',
        image: 'assets/images/recing similator.png',
        icon: Icons.content_cut,
        route: RoutesName.mainScreen,
        arguments: 2,
        fullWidth: true,
      ),
      
      _ExploreCardData(
        tag: 'home.explore.shop',
        title: 'home.explore.oem_parts',
        image: 'assets/images/oem.png',
        icon: Icons.build,
        route: RoutesName.sparePartsScreen,
        fullWidth: false,
      ),
     
      _ExploreCardData(
        tag: 'home.explore.contact',
        title: 'home.explore.book_experience',
        image: 'assets/images/book exprience.png',
        icon: Icons.calendar_month,
        route: RoutesName.mainScreen,
        arguments: 2,
        fullWidth: true,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Image.asset(
            'assets/images/logoappbar.png',
          ),
        ),
        leadingWidth: 120,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, RoutesName.sparePartsCartScreen),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            children: _buildCardWidgets(cards, isMobile),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCardWidgets(List<_ExploreCardData> cards, bool isMobile) {
    final widgets = <Widget>[];
    int i = 0;
    while (i < cards.length) {
      if (cards[i].fullWidth) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ExploreCard(
              data: cards[i],
              height: cards[i].height ?? (isMobile ? 220 : 280),
            ),
          ),
        );
        i++;
      } else if (i + 1 < cards.length && !cards[i + 1].fullWidth) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                Expanded(
                  child: _ExploreCard(
                    data: cards[i],
                    height: isMobile ? 180 : 220,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _ExploreCard(
                    data: cards[i + 1],
                    height: isMobile ? 180 : 220,
                  ),
                ),
              ],
            ),
          ),
        );
        i += 2;
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ExploreCard(
              data: cards[i],
              height: cards[i].height ?? (isMobile ? 220 : 280),
            ),
          ),
        );
        i++;
      }
    }
    return widgets;
  }
}

class _ExploreCardData {
  final String tag;
  final String title;
  final String image;
  final IconData icon;
  final String route;
  final dynamic arguments;
  final bool fullWidth;
  final double? height;

  _ExploreCardData({
    required this.tag,
    required this.title,
    required this.image,
    required this.icon,
    required this.route,
    this.arguments,
    this.fullWidth = true,
    this.height,
  });
}

class _ExploreCard extends StatelessWidget {
  final _ExploreCardData data;
  final double height;

  const _ExploreCard({required this.data, required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.arguments != null) {
          Navigator.pushNamed(context, data.route, arguments: data.arguments);
        } else {
          Navigator.pushNamed(context, data.route);
        }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.brandDark,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(data.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.black.withOpacity(0.35),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Bottom gradient for text readability
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: height * 0.6,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.black.withOpacity(0.75),
                      AppColors.black.withOpacity(0.95),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom text + arrow
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.tag.tr().toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.brandPrimary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              data.icon,
                              color: AppColors.brandPrimary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                data.title.tr(),
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_outward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
