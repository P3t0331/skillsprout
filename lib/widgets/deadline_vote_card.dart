import 'package:flutter/material.dart';

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
                "Due: " + deadline.date.toString(),
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
