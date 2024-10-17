import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.searchColor,
    required this.textColor,
    required this.fontSize,
  });

  final Color searchColor;
  final Color textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: searchColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Warna bayangan
            blurRadius: 2.0, // Besarnya blur pada bayangan
            offset: Offset(0, 1), // Posisi bayangan (x, y)
          ),
        ],
      ),
      child: Row(children: [
        Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: textColor,
                size: fontSize,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        Expanded(
          child: Text(
            'Setting',
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]),
    );
  }
}
