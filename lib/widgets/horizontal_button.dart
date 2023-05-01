import 'package:flutter/material.dart';

import 'decorated_container.dart';

class HorizontalButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  HorizontalButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      useGradient: true,
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
