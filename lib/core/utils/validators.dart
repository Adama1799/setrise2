// lib/core/utils/validators.dart
class Validators {
  static String? validateEmail(String? value) {
    if (value?.isEmpty ?? true) return 'Email required';
    if (value?.isValidEmail ?? false) return null;
    return 'Invalid email';
  }

  static String? validatePassword(String? value) {
    if (value?.isEmpty ?? true) return 'Password required';
    if ((value?.length ?? 0) < 8) return 'Min 8 characters';
    return null;
  }

  static String? validateUsername(String? value) {
    if (value?.isEmpty ?? true) return 'Username required';
    if ((value?.length ?? 0) < 3) return 'Min 3 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value ?? '')) {
      return 'Only letters, numbers, underscore';
    }
    return null;
  }
}
