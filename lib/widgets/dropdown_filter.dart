import 'package:flutter/material.dart';

class DropdownFilter extends StatefulWidget {
  final List<String> options;
  DropdownFilter({super.key, required this.options});

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<DropdownFilter> {
  String dropdownValue = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      dropdownValue = widget.options.first;
    });
  }

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
        items: widget.options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
