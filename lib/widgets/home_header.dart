import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "March 5th",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            "0 deadlines due today",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "3 deadlines due this week",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
