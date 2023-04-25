import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HorizontalButton extends StatelessWidget {
  HorizontalButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Quick add",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
