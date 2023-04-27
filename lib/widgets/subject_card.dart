import 'package:flutter/material.dart';

import '../models/subject.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;

  const SubjectCard({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject.name),
                Text(
                    "${subject.deadlines.length.toString()} ${subject.deadlines.length == 1 ? "deadline" : "deadlines"}",
                    style: TextStyle(color: Colors.grey))
              ]),
          Icon(Icons.arrow_forward_ios_outlined)
        ],
      ),
    );
  }
}
