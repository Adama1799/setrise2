// material_shop/theme.dart
import 'package:flutter/material.dart';
import 'package:setrise/core/theme/app_colors.dart';
import 'constants.dart';

class ShopTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      fontFamily: 'Inter',
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: kTextColor, fontFamily: 'Inter'),
        bodyMedium: TextStyle(color: kTextColor, fontFamily: 'Inter'),
        bodySmall: TextStyle(color: kTextColor, fontFamily: 'Inter'),
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: kTextColor),
          gapPadding: 10,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: kSecondaryColor),
          gapPadding: 10,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: kPrimaryColor),
          gapPadding: 10,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimaryColor,
        primary: AppColors.primary,
        secondary: AppColors.accent,
      ).copyWith(background: Colors.white),
    );
  }
}
