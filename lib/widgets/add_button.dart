import 'package:flutter/material.dart';

import 'decorated_container.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onTap;
  AddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedContainer(
        child: Center(
          child: Icon(
            Icons.add,
            size: 48,
            color: Colors.grey,
          ),
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
