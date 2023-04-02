import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  SearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: InputBorder.none, suffixIcon: Icon(Icons.search)),
    );
  }
}
