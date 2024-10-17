import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double fontSize;
  final Function(String) onSearchChanged;

  const SearchBarCustom({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor = Colors.white,
    this.borderRadius = 10.0,
    this.borderWidth = 1.0,
    required this.fontSize,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.all(8.0), // Menambahkan sedikit jarak di sekitar komponen
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Warna bayangan
            blurRadius: 2.0, // Besarnya blur pada bayangan
            offset: Offset(0, 1), // Posisi bayangan (x, y)
          ),
        ],
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: textColor,
                  size: fontSize,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Membuka drawer
                },
              );
            },
          ),
          Expanded(
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: textColor),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
