// services/auth_service.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      id: '1',
      name: 'Ahmed Benali',
      email: email,
      phone: '+213 555 123 456',
      addresses: ['123 Rue Didouche Mourad, Algiers'],
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    notifyListeners();
  }
}
