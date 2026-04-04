import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text('Join SetRise today', style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontFamily: 'Inter')),
            const SizedBox(height: 32),
            _field('Full Name', nameCtrl, false),
            const SizedBox(height: 16),
            _field('Email', emailCtrl, false),
            const SizedBox(height: 16),
            _field('Password', passwordCtrl, true),
            const SizedBox(height: 28),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
              )),
            const SizedBox(height: 16),
            Center(child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: RichText(text: TextSpan(
                text: 'Already have an account? ',
                style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'),
                children: [TextSpan(text: 'Login', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))],
              )),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, bool obscure) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
      ),
    );
  }
}
