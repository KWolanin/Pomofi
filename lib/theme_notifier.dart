import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  Color lightColor = Color(0xFFfae9bd);
  Color darkColor = Color(0xFF07280C);
  late String currentTheme;

  ThemeNotifier() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    currentTheme = (prefs.getString('selected_theme') ?? 'standardGreen')!;

    final String jsonString = await rootBundle.loadString('assets/data/themes.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    if (jsonData.containsKey(currentTheme)) {
      _applyTheme(jsonData[currentTheme]);
    } else {
      _applyTheme(jsonData['standardGreen']);
    }
  }


  Future<void> changeTheme(String themeName) async {
    final String jsonString = await rootBundle.loadString('assets/data/themes.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    if (jsonData.containsKey(themeName)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_theme', themeName);
      currentTheme = themeName;
      _applyTheme(jsonData[themeName]);
      notifyListeners();
    }
  }


  void _applyTheme(Map<String, dynamic> themeData) {
    lightColor = Color(int.parse(themeData['light']));
    darkColor = Color(int.parse(themeData['dark']));
  }
}
