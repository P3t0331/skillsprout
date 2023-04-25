import 'package:flutter/material.dart';

class DeadlineCard extends StatelessWidget {
  DeadlineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PV239 - Mobile application devel.."),
          Text("Homework 2"),
          Text(
            "Due: Friday May 5th 17:00",
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
