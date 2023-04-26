import 'package:flutter/material.dart';

import '../models/deadline.dart';

class DeadlineCard extends StatelessWidget {
  final String subjectName;
  final Deadline deadline;
  DeadlineCard({super.key, required this.subjectName, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subjectName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(deadline.title),
          Text(
            "Due: " + deadline.date.toIso8601String(),
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
