import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  HorizontalButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
