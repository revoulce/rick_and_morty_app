import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  static const _key = 'isDark';

  final Box<bool> _box = Hive.box<bool>('settings');

  bool get isDarkMode => _box.get(_key) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleThemeMode() {
    _box.put(_key, !isDarkMode);
    notifyListeners();
  }
}
