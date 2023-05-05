import 'package:deadline_tracker/screens/add_edit_deadline_page.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/utils/show_dialog_utils.dart';
import 'package:deadline_tracker/utils/string_formatter.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
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
import '../widgets/page_container.dart';
import '../widgets/streambuilder_handler.dart';

class SubjectPage extends StatefulWidget {
  @override
  State<SubjectPage> createState() => _SubjectPageState();

  final Subject subject;
  final List<Deadline> deadlines = [];

  final _subjectService = GetIt.I<SubjectService>();
  final _deadlineService = GetIt.I<DeadlineService>();
  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<Auth>();

  SubjectPage({super.key, required this.subject});
}

class _SubjectPageState extends State<SubjectPage> {
  late final Stream<List<Deadline>> _deadlineListStream;
  late final String _uid;
  late final bool _isAuthor;

  @override
  void initState() {
    super.initState();
    _uid = widget._authService.currentUser!.uid;
    _deadlineListStream = widget._deadlineService
        .subjectDeadlineStream(subjectId: widget.subject.id);
    _isAuthor = _uid == widget.subject.authorId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: StreamBuilderHandler(
          stream: widget._userService.hasJoinedSubject(_uid, widget.subject.id),
          toReturn: (AsyncSnapshot<bool?> joinedSubjectSnapshot) {
            final bool joinedSubject = joinedSubjectSnapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  text: widget.subject.code + ": " + widget.subject.name,
                  fontSize: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${StringFormatter.handlePlural(widget.subject.memberCount, "Member")}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacer(
                      flex: 5,
                    ),
                    _isAuthor ? deleteButton() : Container(),
                    Spacer(
                      flex: 1,
                    ),
                    JoinLeaveButton(
                        joinedSubject: joinedSubject,
                        uid: _uid,
                        subjectId: widget.subject.id),
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
                  isDisabled: !joinedSubject,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => AddEditDeadlinePage(
                              subject: widget.subject,
                            )));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: deadlineTabs(joinedSubject),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
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

  Widget deleteButton() {
    return ElevatedButton(
      onPressed: () {
        ShowDialogUtils.showConfirmDialog(
            context,
            "Delete subject ${widget.subject.code}?",
            "This will permanently delete this subject and all of it's deadlines",
            () {
          widget._subjectService.deleteSubject(widget.subject.id);
          Navigator.of(context).pop();
        });
      },
      child: Text("Delete"),
    );
  }
}
