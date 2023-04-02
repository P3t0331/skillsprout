import 'package:flutter/material.dart';

class DropdownFilter extends StatefulWidget {
  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<DropdownFilter> {
  String dropdownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(12),
        underline: SizedBox(),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down),
        value: dropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: <String>['Option 1', 'Option 2', 'Option 3', 'Option 4']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
