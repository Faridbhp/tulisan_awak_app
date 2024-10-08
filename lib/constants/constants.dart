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

class FontStore {
  final double fontTitle;
  final double fontHeader;
  final double fontContent;

  FontStore({
    required this.fontTitle,
    required this.fontHeader,
    required this.fontContent,
  });

  // Define extra small font
  static FontStore exstraSmall = FontStore(
    fontTitle: 18,
    fontHeader: 16,
    fontContent: 14,
  );

  // Define small font
  static FontStore small = FontStore(
    fontTitle: 20,
    fontHeader: 18,
    fontContent: 16,
  );

  // Define big font
  static FontStore big = FontStore(
    fontTitle: 22,
    fontHeader: 20,
    fontContent: 18,
  );
}
