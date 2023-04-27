import 'package:flutter/cupertino.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;

  TitleText({super.key, required this.text, this.fontSize = 24});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Color(0xFF1243BF), fontSize: fontSize),
    );
  }
}
