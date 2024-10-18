import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerCustom extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorChanged;
  final Function() onClearColor;
  final Function() onClose;

  const ColorPickerCustom({
    super.key,
    required this.selectedColor,
    required this.onColorChanged,
    required this.onClearColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pilih Warna'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Menampilkan color picker
            BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: onColorChanged,
            ),
            SizedBox(height: 20),
            Text('Atau pilih warna lain:'),
            SizedBox(height: 20),
            // Menampilkan ColorPicker
            ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: onColorChanged,
              pickerAreaHeightPercent: 0.8,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onClearColor,
          child: Text('Clear'),
        ),
        TextButton(
          onPressed: onClose,
          child: Text('Tutup'),
        ),
      ],
    );
  }
}
