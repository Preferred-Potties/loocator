import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLight = Colors.blue;
  static const Color primaryDark = Colors.indigo;
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Colors.black;
  static const Color textDark = Colors.white;
  static const Color textLight = Colors.black;
}

class AppThemes {
  static final lightTheme = ThemeData(
      primaryColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.textLight)));

  static final darkTheme = ThemeData(
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: const TextTheme(bodyLarge: TextStyle(color: AppColors.textDark)));
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // ThemeData _currentTheme = AppThemes.lightTheme;
  // ThemeData get currentTheme => _currentTheme;
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
