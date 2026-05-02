// lib/presentation/screens/shop/checkout_models.dart
import 'package:flutter/cupertino.dart';

enum PaymentType { creditCard, paypal, cashOnDelivery }

class Address {
  final String id, name, fullName, street, city, state, zipCode, country, phone;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.phone,
    this.isDefault = false,
  });
}

class PaymentMethod {
  final String id, name, details;
  final PaymentType type;
  final IconData icon;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.icon,
    required this.details,
  });
}
