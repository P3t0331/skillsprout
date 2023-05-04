import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String title;
  final String content;
  final List<Widget>? actions;

  PopupDialog(
      {required this.title, required this.content, required this.actions});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actions,
    );
  }
}
