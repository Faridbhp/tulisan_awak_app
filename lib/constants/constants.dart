import 'package:flutter/material.dart';

class ColorStore {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;

  ColorStore({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
  });

  // Define dark theme colors
  static ColorStore dark = ColorStore(
    backgroundColor: Color.fromARGB(255, 80, 74, 74),
    textColor: Colors.white,
    borderColor: Colors.grey,
    iconColor: Colors.yellow,
  );

  // Define light theme colors
  static ColorStore light = ColorStore(
    backgroundColor: Colors.white,
    textColor: Colors.black,
    borderColor: Colors.black,
    iconColor: Colors.blue,
  );
}
