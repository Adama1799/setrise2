import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(fontFamily: 'Inter'),
          ),
          style: const TextStyle(fontFamily: 'Inter'),
        ),
      ),
      body: const Center(child: Text('Search results will appear here', style: TextStyle(fontFamily: 'Inter'))),
    );
  }
}
