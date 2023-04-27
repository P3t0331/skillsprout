import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/deadline.dart';

class DeadlineVoteCard extends StatelessWidget {
  final Deadline deadline;

  DeadlineVoteCard({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    final int voteSum = deadline.upvoteIds.length - deadline.downvoteIds.length;

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(deadline.title),
              Text(
                "Due: " +
                    DateFormat('E, d MMM yyyy HH:mm').format(deadline.date),
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
          Spacer(),
          Text(
            voteSum.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => {print("upvoted")},
                child: Icon(
                  Icons.arrow_upward_rounded,
                ),
              ),
              GestureDetector(
                onTap: () => {print("downvoted")},
                child: Icon(
                  Icons.arrow_downward_rounded,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
