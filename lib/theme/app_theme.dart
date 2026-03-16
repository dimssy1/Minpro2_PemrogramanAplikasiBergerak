import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        // ← Perbaikan: CardTheme → CardThemeData
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
