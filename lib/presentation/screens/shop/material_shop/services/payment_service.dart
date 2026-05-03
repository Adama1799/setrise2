// services/payment_service.dart
class PaymentService {
  Future<bool> processPayment({
    required String cardNumber,
    required String expiry,
    required String cvv,
    required double amount,
  }) async {
    // محاكاة عملية دفع
    await Future.delayed(const Duration(seconds: 2));
    return true;
  }
}
