import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool useSearchIcon;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  InputField(
      {super.key,
      this.useSearchIcon = false,
      this.hintText = "",
      this.controller,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (String value) => onChanged,
      decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: useSearchIcon ? Icon(Icons.search) : null),
    );
  }
}
