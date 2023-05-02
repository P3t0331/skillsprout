import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/screens/add_deadline_page.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/futurebuilder_handler.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/join_leave_button.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../services/auth.dart';
import '../services/deadline_service.dart';
import '../services/user_service.dart';
import '../widgets/decorated_container.dart';
import '../widgets/page_container.dart';
import '../widgets/streambuilder_handler.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<SubjectPage> createState() => _SubjectPageState();

  final Subject subject;
  final List<Deadline> deadlines = [];

  final _deadlineService = GetIt.I<DeadlineService>();
  final _subjectService = GetIt.I<SubjectService>();
  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<Auth>();

  SubjectPage({super.key, required this.subject});
}

class _SubjectPageState extends State<SubjectPage> {
  late final Future<DocumentReference> _futureSubject;
  late final Stream<List<Deadline>> _deadlineListStream;
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = widget._authService.currentUser!.uid;
    _futureSubject = widget._subjectService.getSubject(widget.subject.code);
    _deadlineListStream = widget._deadlineService
        .subjectDeadlineStream(subjectCode: widget.subject.code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: FutureBuilderHandler(
          future: _futureSubject,
          toReturn: (AsyncSnapshot<DocumentReference<Object?>> snapshot) {
            final subjectId = snapshot.data!.id;
            return StreamBuilderHandler(
              stream: widget._userService.hasJoinedSubject(_uid, subjectId),
              toReturn: (AsyncSnapshot<bool?> joinedSubjectSnapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      text: widget.subject.code + " " + widget.subject.name,
                      fontSize: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "32 members",
                          style: TextStyle(color: Colors.grey),
                        ),
                        JoinLeaveButton(
                            snapshot: joinedSubjectSnapshot,
                            uid: _uid,
                            subjectId: subjectId),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    HorizontalButton(
                      text: "Create deadline",
                      isDisabled: !joinedSubjectSnapshot.data!,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddDeadlinePage()));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: deadlineTabs(joinedSubjectSnapshot.data!),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget deadlineTabs(bool enableVoting) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.blue,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Approved"),
              Tab(text: "Proposed"),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilderHandler<List<Deadline>>(
                stream: _deadlineListStream,
                toReturn: (AsyncSnapshot<List<Deadline>> snapshot) =>
                    showDeadlinesAfterChecks(snapshot, enableVoting)),
          )
        ],
      ),
    );
  }

  Widget showDeadlinesAfterChecks(
      AsyncSnapshot<List<Deadline>> snapshot, bool enableVoting) {
    final data = snapshot.data!;
    var approvedDeadlines =
        data.where((element) => element.upvoteIds.length >= 3).toList();
    var pendingDeadlines =
        data.where((element) => element.upvoteIds.length < 3).toList();
    return TabBarView(
      children: [
        approvedDeadlines.length != 0
            ? DeadlineList(
                deadlines: approvedDeadlines,
              )
            : Center(child: Text("There is no data to display")),
        pendingDeadlines.length != 0
            ? DeadlineList(
                deadlines: pendingDeadlines,
                useVoteCards: true,
                enableVoting: enableVoting,
              )
            : Center(child: Text("There is no data to display")),
      ],
    );
  }
}
