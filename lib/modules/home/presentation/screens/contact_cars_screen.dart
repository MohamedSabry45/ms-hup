import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactCarsScreen extends StatelessWidget {
  const ContactCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        title: Text('home.contact_cars'.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        foregroundColor: Colors.white,
      ),
      body: const SizedBox.shrink(),
    );
  }
}
