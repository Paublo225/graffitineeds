import 'package:flutter/material.dart';
import 'package:graffitineeds/helpers/styles.dart';

class ThemaMode with ChangeNotifier {
  static bool isDarkMode = false;
  ThemaMode() {
    if (box!.containsKey('currentTheme'))
      isDarkMode = box!.get('currentTheme');
    else
      box!.put('currentTheme', isDarkMode);
  }
  ThemeMode currentTheme() {
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    isDarkMode = !isDarkMode;
    box!.put('currentTheme', isDarkMode);
    notifyListeners();
  }
}
