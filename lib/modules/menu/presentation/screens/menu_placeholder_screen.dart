import 'package:flutter/material.dart';

class MenuPlaceholderScreen extends StatelessWidget {
  const MenuPlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF050505),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
