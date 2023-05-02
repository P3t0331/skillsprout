import 'package:deadline_tracker/screens/add_subject_page.dart';
import 'package:deadline_tracker/screens/subject_page.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:deadline_tracker/widgets/home_header.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:deadline_tracker/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/subject.dart';
import '../widgets/add_button.dart';
import 'add_deadline_page.dart';

class HomePage extends StatelessWidget {
  final _subjectService = GetIt.I<SubjectService>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: PageContainer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HorizontalButton(
            text: "Quick add",
            onTap: () {
              final addDeadlinePage = MaterialPageRoute(
                  builder: (BuildContext context) => AddDeadlinePage());
              Navigator.of(context).push(addDeadlinePage);
            },
          ),
          SizedBox(
            height: 20,
          ),
          HomeHeader(
            dueToday: 1,
            dueWeek: 3,
          ),
          SizedBox(
            height: 20,
          ),
          TitleText(text: "Subjects"),
          _drawSubjects(),
          SizedBox(
            height: 20,
          ),
          AddButton(onTap: () {
            final addSubjectPage = MaterialPageRoute(
                builder: (BuildContext context) => AddSubjectPage());
            Navigator.of(context).push(addSubjectPage);
          })
        ],
      )),
    );
  }

  Widget _drawSubjects() {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: StreamBuilderHandler<List<Subject>>(
              stream: _subjectService.subjectStream,
              toReturn: drawSubjectsAfterChecks),
        ),
      ),
    );
  }

  Widget drawSubjectsAfterChecks(AsyncSnapshot<List<Subject>> snapshot) {
    final data = snapshot.data!;
    if (data.length == 0) {
      return Center(child: Text("There is no data to display"));
    }

    final subjects = snapshot.data!;
    return ListView.separated(
      shrinkWrap: true,
      physics: ScrollPhysics(),
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
          child: SubjectCard(
            subject: subjects[index],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(
        height: 10,
      ),
    );
  }
}
