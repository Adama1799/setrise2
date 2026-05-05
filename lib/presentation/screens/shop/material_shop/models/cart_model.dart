import 'product_model.dart';

class CartItem {
  final ProductModel product;
  final int quantity;
  double get subtotal => product.price * quantity;

  const CartItem({required this.product, this.quantity = 1});
}
