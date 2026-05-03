// screens/auction/auction_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

class AuctionScreen extends StatelessWidget {
  const AuctionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية لمزادات
    return Scaffold(
      appBar: AppBar(title: const Text("Live Auctions", style: TextStyle(fontFamily: 'Inter'))),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.gavel, color: Colors.orange),
          title: Text("Auction Item ${index + 1}", style: const TextStyle(fontFamily: 'Inter')),
          subtitle: const Text("Current Bid: \$100", style: TextStyle(fontFamily: 'Inter')),
          trailing: TextButton(
            onPressed: () {},
            child: const Text("Bid Now", style: TextStyle(fontFamily: 'Inter')),
          ),
        ),
      ),
    );
  }
}
