// models/user_model.dart
class User {
  final String id, name, email, phone;
  final List<String> addresses;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.addresses = const [],
  });
}
