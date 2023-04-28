import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String content;

  PopupDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
      ],
    );
  }
}
