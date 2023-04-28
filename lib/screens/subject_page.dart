import 'package:deadline_tracker/screens/add_deadline_page.dart';
import 'package:deadline_tracker/widgets/add_button.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../widgets/decorated_container.dart';
import '../widgets/page_container.dart';

class SubjectPage extends StatelessWidget {
  final Subject subject;
  final List<Deadline> deadlines = [
    Deadline(title: "HW4", date: DateTime.now()),
    Deadline(title: "HW2", date: DateTime.now()),
    Deadline(title: "HW10", date: DateTime.now()),
    Deadline(title: "HW15", date: DateTime.now()),
    Deadline(title: "HW27", date: DateTime.now()),
    Deadline(title: "HW37", date: DateTime.now()),
    Deadline(title: "HW45", date: DateTime.now()),
    Deadline(title: "HW55", date: DateTime.now()),
    Deadline(title: "HW87", date: DateTime.now()),
    Deadline(title: "HW98", date: DateTime.now()),
  ];

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
                        child: TabBarView(
                          children: [
                            DeadlineList(deadlines: deadlines),
                            DeadlineList(
                              deadlines: deadlines,
                              useVoteCards: true,
                            ),
                          ],
                        ),
                      )
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
}
