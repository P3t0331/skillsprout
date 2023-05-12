import 'package:flutter/material.dart';

import 'package:deadline_tracker/models/subject.dart';
import 'decorated_container.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return DecoratedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject.code + ": " + subject.name),
                  Text(
                      "${subject.deadlineIds.length.toString()}"
                      " ${subject.deadlineIds.length == 1 ? "deadline" : "deadlines"}",
                      style: TextStyle(color: Colors.grey))
                ]),
          ),
          Icon(Icons.arrow_forward_ios_outlined)
        ],
      ),
    );
  }
}
