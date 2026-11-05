import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        foregroundColor: Color(0xffffffff),
        backgroundColor: const Color(0xFF0081FF),
      ),
      body: const Center(
        child: Text("No new notifications"),
      ),
    );
  }
}
