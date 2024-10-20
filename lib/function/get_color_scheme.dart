import 'package:flutter/material.dart';
import 'package:tulisan_awak_app/constants/constants.dart';

ColorStore getColorScheme(BuildContext context, String theme,
    [Color? selectedColor]) {
  final brightness = MediaQuery.of(context).platformBrightness;
  // Tentukan color scheme berdasarkan theme
  if (theme == 'System') {
    return brightness == Brightness.dark ? ColorStore.dark : ColorStore.light;
  }
  // jika dia memiliki warna yang dia pilih
  if (selectedColor != null) {
    if (selectedColor == Colors.white &&
        (theme == 'Light' || brightness == Brightness.light)) {
      return ColorStore.light;
    }
  }
  return theme == 'Light' ? ColorStore.light : ColorStore.dark;
}
