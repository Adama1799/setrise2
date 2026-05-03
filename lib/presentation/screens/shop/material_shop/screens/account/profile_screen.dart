// screens/account/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/auth_service.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final user = auth.currentUser!;
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile", style: TextStyle(fontFamily: 'Inter'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundColor: const Color(0xFFFF7643), child: Text(user.name[0], style: const TextStyle(fontSize: 40, color: Colors.white))),
            const SizedBox(height: 16),
            Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(fontFamily: 'Inter')),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings", style: TextStyle(fontFamily: 'Inter')),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out", style: TextStyle(fontFamily: 'Inter')),
              onTap: () {
                auth.logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
