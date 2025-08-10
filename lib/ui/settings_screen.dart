import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: const Center(
        child: Text(
          'Printer settings and configuration will go here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
