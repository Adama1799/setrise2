// material_shop/screens/account/notifications_screen.dart
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications", style: TextStyle(fontFamily: 'Inter'))),
      body: const Center(child: Text("No notifications", style: TextStyle(fontFamily: 'Inter'))),
    );
  }
}
