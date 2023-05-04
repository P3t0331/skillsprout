import 'package:flutter/material.dart';

import 'decorated_container.dart';

class HorizontalButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;
  HorizontalButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      useGradient: !isDisabled,
      padding: EdgeInsets.all(8.0),
      isDisabled: isDisabled,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
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
