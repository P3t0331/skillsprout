import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/screens/add_subject_page.dart';
import 'package:deadline_tracker/screens/subject_page.dart';
import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/services/user_service.dart';
import 'package:deadline_tracker/widgets/futurebuilder_handler.dart';
import 'package:deadline_tracker/widgets/home_header.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:deadline_tracker/widgets/subject_card.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/subject.dart';
import '../services/auth.dart';
import '../widgets/add_button.dart';
import 'add_edit_deadline_page.dart';

class HomePage extends StatelessWidget {
  final _subjectService = GetIt.I<SubjectService>();
  final _deadlineService = GetIt.I<DeadlineService>();
  final _authService = GetIt.I<Auth>();
  final _userService = GetIt.I<UserService>();
  late final String _uid = _authService.currentUser!.uid;
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
                    builder: (BuildContext context) => AddEditDeadlinePage());
                Navigator.of(context).push(addDeadlinePage);
              },
            ),
            SizedBox(
              height: 20,
            ),
            getUserSubjectIds(toReturn: getRelevantDeadlines),
            SizedBox(
              height: 20,
            ),
            TitleText(text: "Joined Subjects"),
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
        ),
      ),
    );
  }

  Widget _drawSubjects() {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: getUserSubjectIds(toReturn: getSubjects),
        ),
      ),
    );
  }

  Widget getUserSubjectIds({required Function toReturn}) {
    return StreamBuilderHandler<List<String>>(
      stream: _userService.getUserSubjectIds(_uid),
      toReturn: toReturn,
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

  Widget getSubjects(AsyncSnapshot<List<String>> subjectIdsSnapshot) {
    return StreamBuilderHandler<List<Subject>>(
        stream: _subjectService.getSubjectsById(subjectIdsSnapshot.data!),
        toReturn: drawSubjectsAfterChecks);
  }

  Widget getRelevantDeadlines(AsyncSnapshot<List<String>> snapshot) {
    var subjectIds = snapshot.data!;
    return StreamBuilderHandler<List<Deadline>>(
        stream: _deadlineService.deadlineStream(),
        toReturn: (AsyncSnapshot<List<Deadline>> snapshot) {
          int deadlinesTodayCount = 0;
          int deadlinesThisWeekCount = 0;
          var deadlines = snapshot.data!;
          for (var deadline in deadlines) {
            if (subjectIds.contains(deadline.subjectRef)) {
              if (calculateDifference(deadline.date) == 0) {
                deadlinesTodayCount++;
              }
              if (calculateDifference(deadline.date) > 0 &&
                  calculateDifference(deadline.date) < 7) {
                deadlinesThisWeekCount++;
              }
            }
          }
          return HomeHeader(
              dueToday: deadlinesTodayCount, dueWeek: deadlinesThisWeekCount);
        });
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
