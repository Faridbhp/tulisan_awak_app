import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          title,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 40,
          ),
          SizedBox(width: 10), // Add space between icon and text
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
