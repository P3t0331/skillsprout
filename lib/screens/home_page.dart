import 'package:deadline_tracker/screens/add_subject_page.dart';
import 'package:deadline_tracker/screens/subject_page.dart';
import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/deadline_vote_card.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/home_header.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:deadline_tracker/widgets/subject_card.dart';
import 'package:flutter/material.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../widgets/add_button.dart';
import 'add_deadline_page.dart';

class HomePage extends StatelessWidget {
  final List<Subject> subjects = [
    Subject(
        name: "Math",
        deadlines: [Deadline(title: "arithmetics", date: DateTime.now())]),
    Subject(
        name: "English",
        deadlines: [Deadline(title: "grammar", date: DateTime.now())]),
    Subject(name: "History", deadlines: [
      Deadline(title: "essay", date: DateTime.now()),
      Deadline(title: "essay2", date: DateTime.now())
    ]),
  ];
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageContainer(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedContainer(
          child: HorizontalButton(
            text: "Quick add",
            onTap: () {
              final addDeadlinePage = MaterialPageRoute(
                  builder: (BuildContext context) => AddDeadlinePage());
              Navigator.of(context).push(addDeadlinePage);
            },
          ),
          useGradient: true,
          padding: EdgeInsets.all(8.0),
        ),
        SizedBox(
          height: 20,
        ),
        DecoratedContainer(
            child: HomeHeader(
              dueToday: 1,
              dueWeek: 3,
            ),
            useGradient: true),
        SizedBox(
          height: 20,
        ),
        TitleText(text: "Subjects"),
        SizedBox(
          height: 20,
        ),
        _drawSubjects(),
        SizedBox(
          height: 20,
        ),
        AddButton(
          route: MaterialPageRoute(
              builder: (BuildContext context) => AddSubjectPage()),
        )
      ],
    ));
  }

  Widget _drawSubjects() {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    final subjectPage = MaterialPageRoute(
                      builder: (BuildContext context) => SubjectPage(
                        subject: subjects[index],
                      ),
                    );
                    Navigator.of(context).push(subjectPage);
                  },
                  child: DecoratedContainer(
                    child: SubjectCard(
                      subject: subjects[index],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 20,
                  )),
        ),
      ),
    );
  }
}
