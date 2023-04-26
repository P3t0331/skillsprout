import 'package:flutter/material.dart';

import 'decorated_container.dart';

class AddButton extends StatelessWidget {
  final MaterialPageRoute<dynamic> route;
  AddButton({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(route);
      },
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
