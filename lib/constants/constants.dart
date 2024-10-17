import 'package:flutter/material.dart';

class ColorStore {
  final Color backgroundColor;
  final Color searchColor;
  final Color bottomColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final Color sideColor;

  ColorStore({
    required this.backgroundColor,
    required this.searchColor,
    required this.bottomColor,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
    required this.sideColor,
  });

  // Define dark theme colors
  static ColorStore dark = ColorStore(
    backgroundColor: Color.fromARGB(255, 28, 17, 13),
    searchColor: Color.fromARGB(255, 45, 28, 21),
    bottomColor: Color.fromARGB(255, 40, 29, 23),
    textColor: Colors.white,
    borderColor: Colors.grey,
    iconColor: Colors.yellow,
    sideColor: Colors.white,
  );

  // Define light theme colors
  static ColorStore light = ColorStore(
    backgroundColor: Color.fromARGB(255, 246, 235, 229),
    searchColor: Color.fromARGB(255,248,230, 229),
    bottomColor: Color.fromARGB(255, 254,234,223),
    textColor: Colors.black,
    borderColor: Colors.black,
    iconColor: Colors.blue,
    sideColor: Color.fromARGB(255, 213,201,196),
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
