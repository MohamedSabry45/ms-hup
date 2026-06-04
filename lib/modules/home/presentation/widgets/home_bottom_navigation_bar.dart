import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:reservation_workshop/config/routes/routes_name.dart';
import 'package:reservation_workshop/core/functions/localization_helper.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index, String route, dynamic arguments) onItemTapped;

  const HomeBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = !isLtr(context);

    final items = [
      _NavItem(
        icon: Icons.home,
        label: isRtl ? 'الرئيسية' : 'Home',
        route: RoutesName.homeScreen,
      ),
      _NavItem(
        icon: Icons.directions_car,
        label: isRtl ? 'سياراتي' : 'My Cars',
        route: RoutesName.chooseCarScreen,
      ),
      _NavItem(
        icon: Icons.calendar_today,
        label: isRtl ? 'الحجوزات' : 'Bookings',
        route: RoutesName.mainScreen,
        arguments: 2,
      ),
      _NavItem(
        icon: Icons.emergency,
        label: isRtl ? 'الإنقاذ' : 'Rescue',
        route: RoutesName.menuRescueScreen,
      ),
      _NavItem(
        icon: Icons.person,
        label: isRtl ? 'الملف' : 'Profile',
        route: RoutesName.menuAccountScreen,
      ),
    ];

    return SafeArea(
      top: false,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: const Color(0xFFD4AF37).withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = selectedIndex == index;

            return Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemTapped(index, item.route, item.arguments),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item.icon,
                          color: isSelected ? Colors.black : Colors.white.withOpacity(0.5),
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final dynamic arguments;

  _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.arguments,
  });
}
