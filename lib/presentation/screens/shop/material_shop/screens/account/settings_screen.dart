// screens/account/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings", style: TextStyle(fontFamily: 'Inter'))),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Manage Addresses", style: TextStyle(fontFamily: 'Inter')),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddressScreen())),
          ),
          ListTile(title: const Text("Notification Settings", style: TextStyle(fontFamily: 'Inter')), onTap: () {}),
          ListTile(title: const Text("Currency: USD", style: TextStyle(fontFamily: 'Inter')), onTap: () {}),
        ],
      ),
    );
  }
}
