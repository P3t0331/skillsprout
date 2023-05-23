import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:flutter/material.dart';
import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/utils/date_formatter.dart';
import 'package:get_it/get_it.dart';

import '../models/subject.dart';
import '../services/subject_service.dart';
import '../utils/date_calculator.dart';
import 'futurebuilder_handler.dart';

class DeadlineCard extends StatelessWidget {
  final Deadline deadline;
  final bool showCode;
  final _subjectService = GetIt.I<SubjectService>();

  DeadlineCard({super.key, required this.deadline, this.showCode = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(deadline.title),
            showCode
                ? FutureBuilderHandler(
                    future: _subjectService
                        .getSubjectObjectById(deadline.subjectRef),
                    toReturn: (AsyncSnapshot<Subject> snapshot) {
                      return Text(
                        snapshot.data!.code,
                        style: TextStyle(color: Colors.grey),
                      );
                    },
                  )
                : Container(),
            Text(
              "Due: " + DateFormatter.formatDate(deadline.date),
              style: TextStyle(
                color: getDeadlineColor(deadline.date),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color getDeadlineColor(DateTime date) {
    final daysTillDeadline = DateCalculator.calculateDifference(date);

    if (daysTillDeadline >= 7) {
      return Colors.green;
    }
    if (daysTillDeadline >= 3) {
      return Colors.orange;
    }
    if (daysTillDeadline >= 0) {
      return Colors.redAccent;
    }
    return Colors.black;
  }
}
