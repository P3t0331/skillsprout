import 'package:deadline_tracker/screens/add_deadline_page.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../services/deadline_service.dart';
import '../widgets/decorated_container.dart';
import '../widgets/page_container.dart';
import '../widgets/streambuilder_handler.dart';

class SubjectPage extends StatelessWidget {
  final Subject subject;
  final List<Deadline> deadlines = [];

  final _deadlineService = GetIt.I<DeadlineService>();

  SubjectPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: PageContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                text: subject.code + " " + subject.name,
                fontSize: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "32 members",
                    style: TextStyle(color: Colors.grey),
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Join"))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              DecoratedContainer(
                useGradient: true,
                child: HorizontalButton(
                  text: "New deadline",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddDeadlinePage()));
                  },
                ),
                padding: EdgeInsets.all(8),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      TabBar(
                        dividerColor: Colors.blue,
                        indicatorColor: Colors.blue,
                        tabs: [
                          Tab(text: "Approved"),
                          Tab(text: "New"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                          child: StreamBuilderHandler<List<Deadline>>(
                              stream: _deadlineService.subjectDeadlineStream(
                                  subjectCode: subject.code),
                              toReturn: showDeadlinesAfterChecks))
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  Widget showDeadlinesAfterChecks(AsyncSnapshot<List<Deadline>> snapshot) {
    final data = snapshot.data!;
    var approvedDeadlines =
        data.where((element) => element.upvoteIds.length >= 3).toList();
    var pendingDeadlines =
        data.where((element) => element.upvoteIds.length < 3).toList();
    return TabBarView(
      children: [
        approvedDeadlines.length != 0
            ? DeadlineList(deadlines: approvedDeadlines)
            : Center(child: Text("There is no data to display")),
        pendingDeadlines.length != 0
            ? DeadlineList(
                deadlines: pendingDeadlines,
                useVoteCards: true,
              )
            : Center(child: Text("There is no data to display")),
      ],
    );
  }
}
