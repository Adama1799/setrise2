// screens/auction/auction_detail_screen.dart
import 'package:flutter/material.dart';

class AuctionDetailScreen extends StatefulWidget {
  const AuctionDetailScreen({Key? key}) : super(key: key);

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  final _bidCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auction Details", style: TextStyle(fontFamily: 'Inter'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vintage Rolex", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            const Text("Current Bid: \$6750", style: TextStyle(fontSize: 18, fontFamily: 'Inter')),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bidCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Your Bid',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(fontFamily: 'Inter'),
                    ),
                    style: const TextStyle(fontFamily: 'Inter'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Place Bid", style: TextStyle(fontFamily: 'Inter')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
