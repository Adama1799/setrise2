// models/payment_model.dart
class PaymentCard {
  final String id, cardNumber, expiry, cvv;
  PaymentCard({
    required this.id,
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
  });
}
