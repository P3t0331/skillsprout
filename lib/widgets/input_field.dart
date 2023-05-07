import 'package:flutter/material.dart';

import 'decorated_container.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final bool useSearchIcon;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  final int? maxLength;
  InputField(
      {super.key,
      this.useSearchIcon = false,
      this.maxLength,
      this.hintText = "",
      this.controller,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          maxLength: maxLength,
          onChanged: (String value) => onChanged,
          decoration: InputDecoration(
              counterText: "",
              hintText: hintText,
              border: InputBorder.none,
              suffixIcon: useSearchIcon ? Icon(Icons.search) : null),
        ));
  }
}
