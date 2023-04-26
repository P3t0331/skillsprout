import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/deadline.dart';

class DeadlineCard extends StatelessWidget {
  final String? subjectName;
  final Deadline deadline;
  DeadlineCard({super.key, this.subjectName = null, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          subjectName != null
              ? Text(
                  subjectName!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : SizedBox(),
          Text(deadline.title),
          Text(
            "Due: " + DateFormat('E, d MMM yyyy HH:mm').format(deadline.date),
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
