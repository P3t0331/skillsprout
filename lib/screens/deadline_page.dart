import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/small_title_text.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/widgets/decorated_container.dart';

import 'package:deadline_tracker/widgets/dropdown_filter.dart';

import '../models/deadline.dart';

class DeadlinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SmallTitleText(text: "Sort by"),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: DecoratedContainer(
              child: DropdownFilter(
                options: ["Date", "Subject"],
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          SizedBox(height: 10),
          DecoratedContainer(
            child: InputField(),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          SizedBox(height: 40),
          DecoratedContainer(
              child: DeadlineCard(
            subjectName: 'subject1',
            deadline: Deadline(title: 'deadline 1', date: DateTime.now()),
          )),
          SizedBox(height: 10),
          DecoratedContainer(
              child: DeadlineCard(
            subjectName: 'subject2',
            deadline: Deadline(title: 'deadline 1', date: DateTime.now()),
          )),
          SizedBox(height: 10),
          DecoratedContainer(
              child: DeadlineCard(
            subjectName: 'subject1',
            deadline: Deadline(title: 'deadline 2', date: DateTime.now()),
          )),
        ],
      ),
    );
  }
}
