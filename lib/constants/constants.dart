import 'package:flutter/material.dart';

class ColorStore {
  final Color backgroundColor;
  final Color searchColor;
  final Color bottomColor;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final Color sideColor;
  final Color hoverColor;
  final Color buttonPlusColor;

  ColorStore({
    required this.backgroundColor,
    required this.searchColor,
    required this.bottomColor,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
    required this.sideColor,
    required this.hoverColor,
    required this.buttonPlusColor,
  });

  // Define dark theme colors
  static ColorStore dark = ColorStore(
    backgroundColor: Color(0xFF000000),
    searchColor: Color(0xFF2B2B2B),
    bottomColor: Color(0xFF2B2B2B),
    textColor: Colors.white,
    borderColor: Colors.grey,
    iconColor: Colors.white,
    sideColor: Color(0xFF2B2B2B),
    hoverColor: Color(0xFF2B2B2B),
    buttonPlusColor: Color(0xFF423F3E),
  );

  // Define light theme colors
  static ColorStore light = ColorStore(
    backgroundColor: Color(0xFFFAF6F0),
    searchColor: Color(0xFFF4EAE0),
    bottomColor: Color(0xFFF4EAE0),
    textColor: Colors.black,
    borderColor: Colors.black,
    iconColor: Colors.black,
    sideColor: Color.fromARGB(255, 213, 201, 196),
    hoverColor: Color(0xFFF4EAE0),
    buttonPlusColor: Color(0xFFF4DFC8),
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
  static FontStore extraSmall = FontStore(
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
