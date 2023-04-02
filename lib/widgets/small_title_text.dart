import 'package:flutter/cupertino.dart';

class SmallTitleText extends StatelessWidget {
  final String text;

  SmallTitleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Color(0xFF1243BF), fontSize: 24),
    );
  }
}
