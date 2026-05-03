// material_shop/screens/cart/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/services/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = CartService();
    return Scaffold(
      appBar: AppBar(title: const Text("Cart", style: TextStyle(fontFamily: 'Inter'))),
      body: cart.items.isEmpty
          ? const Center(child: Text("Your cart is empty", style: TextStyle(fontFamily: 'Inter')))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ListTile(
                        leading: Image.asset(item.product.images[0]),
                        title: Text(item.product.title, style: const TextStyle(fontFamily: 'Inter')),
                        subtitle: Text('\$${item.product.price} x ${item.quantity}', style: const TextStyle(fontFamily: 'Inter')),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(icon: const Icon(Icons.remove), onPressed: () => cart.decrement(index)),
                            Text('${item.quantity}', style: const TextStyle(fontFamily: 'Inter')),
                            IconButton(icon: const Icon(Icons.add), onPressed: () => cart.increment(index)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${cart.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("Check Out", style: TextStyle(fontFamily: 'Inter')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
