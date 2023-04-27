import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool useSearchIcon;
  InputField({super.key, this.useSearchIcon = false, this.hintText = ""});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: useSearchIcon ? Icon(Icons.search) : null),
    );
  }
}
