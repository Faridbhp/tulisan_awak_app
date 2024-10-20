import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ShowItemDialog extends StatelessWidget {
  final Function(ImageSource) onImageSourceSelected;
  final VoidCallback onCreatePdf;

  const ShowItemDialog({
    super.key,
    required this.onImageSourceSelected,
    required this.onCreatePdf,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: <Widget>[
          if (!kIsWeb && !Platform.isWindows) ...[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop(); // Menutup dialog
                onImageSourceSelected(ImageSource.camera); // Buka kamera
              },
            ),
          ],
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Gallery'),
            onTap: () {
              Navigator.of(context).pop(); // Menutup dialog
              onImageSourceSelected(ImageSource.gallery); // Buka galeri
            },
          ),
          ListTile(
            leading: Icon(Icons.picture_as_pdf), // Ikon untuk suara
            title: Text('Download PDF'),
            onTap: () {
              Navigator.of(context).pop(); // Menutup dialog
              onCreatePdf(); // Panggil callback untuk suara
            },
          ),
        ],
      ),
    );
  }
}
