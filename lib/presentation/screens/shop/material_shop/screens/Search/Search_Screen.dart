// screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/product_service.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final productService = ProductService();
  final searchCtrl = TextEditingController();
  List<Product> results = [];

  void _search(String query) {
    setState(() {
      results = productService.searchProducts(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(fontFamily: 'Inter'),
          ),
          onChanged: _search,
          style: const TextStyle(fontFamily: 'Inter'),
        ),
      ),
      body: results.isEmpty
          ? const Center(child: Text("Search for something", style: TextStyle(fontFamily: 'Inter')))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: results.length,
              itemBuilder: (ctx, index) => ProductCard(
                product: results[index],
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: results[index]),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
