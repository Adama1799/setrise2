// screens/account/address_screen.dart
import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Addresses", style: TextStyle(fontFamily: 'Inter'))),
      body: ListView(
        children: const [
          ListTile(title: Text("Home - 123 Rue Didouche Mourad, Algiers", style: TextStyle(fontFamily: 'Inter'))),
          ListTile(title: Text("Work - 45 Boulevard Colonel Amirouche, Oran", style: TextStyle(fontFamily: 'Inter'))),
        ],
      ),
    );
  }
}
