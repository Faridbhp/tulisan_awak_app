import 'package:flutter/material.dart';

class Header2 extends StatelessWidget {
  const Header2({
    super.key,
    required this.searchColor,
    required this.textColor,
    required this.fontSize,
    required this.gridCount,
    required this.onChangeGridCount,
  });

  final Color searchColor;
  final Color textColor;
  final double fontSize;
  final int gridCount;
  final Function() onChangeGridCount;

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
        IconButton(
          icon: Icon(
            gridCount == 1
                ? Icons.splitscreen_outlined
                : Icons.grid_view_outlined,
            color: textColor,
            size: fontSize,
          ),
          onPressed: onChangeGridCount,
        )
      ]),
    );
  }
}
