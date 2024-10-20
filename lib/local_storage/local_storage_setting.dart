// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveThemeToLocalStorage(String theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('theme', theme);
}

Future<void> saveFontSizeToLocalStorage(String fontSize) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('fontSize', fontSize);
}

Future<void> saveShowGridCountToLocalStorage(int showGridCount) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('showGridCount', showGridCount);
}

Future<String> loadThemeFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('theme') ?? 'Light'; // Default theme is 'Light'
}

Future<String> loadFontSizeFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('fontSize') ?? 'Small'; // Default fontSize is 'Small'
}

Future<int> loadShowGridCountFromLocalStorage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('showGridCount') ?? 1; // Default fontSize is 'Small'
}
