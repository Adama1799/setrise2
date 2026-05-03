// screens/review/write_review_screen.dart
import 'package:flutter/material.dart';

class WriteReviewScreen extends StatelessWidget {
  final String productId;
  const WriteReviewScreen({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text("Write Review", style: TextStyle(fontFamily: 'Inter'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Your Rating", style: TextStyle(fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => IconButton(
                icon: const Icon(Icons.star_border),
                onPressed: () {},
              )),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontFamily: 'Inter'),
              ),
              style: const TextStyle(fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Submit", style: TextStyle(fontFamily: 'Inter')),
            ),
          ],
        ),
      ),
    );
  }
}
