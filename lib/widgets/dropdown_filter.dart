import 'package:flutter/material.dart';

class DropdownFilter extends StatelessWidget {
  final List<String> options;
  final Function(String?) onChanged;
  final String? value;
  DropdownFilter(
      {super.key,
      required this.options,
      required this.onChanged,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(12),
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down),
        value: value,
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
