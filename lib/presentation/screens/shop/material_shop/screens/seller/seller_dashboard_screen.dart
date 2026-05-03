// screens/seller/seller_dashboard_screen.dart
import 'package:flutter/material.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seller Dashboard", style: TextStyle(fontFamily: 'Inter'))),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _dashboardCard(context, Icons.add_box, "Add Product", const AddProductScreen()),
          _dashboardCard(context, Icons.list_alt, "My Products", null),
          _dashboardCard(context, Icons.shopping_cart, "Orders", null),
          _dashboardCard(context, Icons.analytics, "Analytics", null),
        ],
      ),
    );
  }

  Widget _dashboardCard(BuildContext ctx, IconData icon, String label, Widget? screen) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: InkWell(
        onTap: screen != null ? () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => screen)) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFFFF7643)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }
}
