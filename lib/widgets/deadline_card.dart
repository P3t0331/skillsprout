import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:flutter/material.dart';
import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/utils/date_formatter.dart';

class DeadlineCard extends StatelessWidget {
  final String? subjectName;
  final Deadline deadline;
  DeadlineCard({super.key, this.subjectName = null, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      child: Align(
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
              "Due: " + DateFormatter.formatDate(deadline.date),
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
