import 'package:flutter/material.dart';

class DeadlineVoteCard extends StatelessWidget {
  DeadlineVoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Homework 4"),
              Text(
                "Due: Friday April 28th 17:00",
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Expanded(flex: 1, child: SizedBox()),
          Text(
            "3",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Icon(
                Icons.arrow_upward_rounded,
              ),
              Icon(
                Icons.arrow_downward_rounded,
              )
            ],
          )
        ],
      ),
    );
  }
}
