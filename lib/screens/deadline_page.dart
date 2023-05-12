import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/widgets/futurebuilder_handler.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../services/auth.dart';
import '../utils/date_formatter.dart';
import '../utils/show_dialog_utils.dart';
import 'add_edit_deadline_page.dart';

class DeadlinePage extends StatefulWidget {
  final Deadline deadline;
  DeadlinePage({super.key, required this.deadline});
  final _deadlineService = GetIt.I<DeadlineService>();
  final _subjectService = GetIt.I<SubjectService>();
  late final String _uid = GetIt.I<Auth>().currentUser!.uid;
  late final bool _canEdit = _uid == deadline.authorId;

  @override
  State<DeadlinePage> createState() => _DeadlinePageState();
}

class _DeadlinePageState extends State<DeadlinePage> {
  late final Future<Subject> _futureSubject;

  @override
  void initState() {
    super.initState();
    _futureSubject =
        widget._subjectService.getSubjectObjectById(widget.deadline.subjectRef);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(
              text: widget.deadline.title,
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilderHandler(
              future: _futureSubject,
              toReturn: (AsyncSnapshot<Subject> snapshot) {
                final subject = snapshot.data!;
                return TitleText(
                  text: "${subject.code} ${subject.name}",
                  fontSize: 18,
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilderHandler(
              future: _futureSubject,
              toReturn: (AsyncSnapshot<Subject> snapshot) {
                final subject = snapshot.data!;
                final voteAmount = widget.deadline.upvoteIds.length -
                    widget.deadline.downvoteIds.length;
                return Row(
                  children: [
                    Text(
                        "Status: ${voteAmount >= subject.requiredVotes ? "Approved" : "Proposed"}"),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Votes: ${voteAmount}"),
                  ],
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Due: ${DateFormatter.formatDate(widget.deadline.date)}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: widget._canEdit ? 10 : 0,
            ),
            widget._canEdit
                ? Row(
                    children: [
                      editButton(context),
                      SizedBox(
                        width: 20,
                      ),
                      deleteButton(context)
                    ],
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            TitleText(
              text: "Deadline details",
              fontSize: 18,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: widget.deadline.description.isEmpty
                    ? Text("No description provided")
                    : Text(widget.deadline.description),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget deleteButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ShowDialogUtils.showConfirmDialog(
            context,
            "Delete deadline ${widget.deadline.title}?",
            "This will permanently delete this deadline.", () {
          widget._deadlineService.deleteDeadline(widget.deadline);
          Navigator.of(context).pop();
        });
      },
      child: Text("Delete"),
    );
  }

  Widget editButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        var subject = await widget._subjectService
            .getSubjectObjectById(widget.deadline.subjectRef);
        final addDeadlinePage = MaterialPageRoute(
          builder: (BuildContext context) => AddEditDeadlinePage(
            deadlineToEdit: widget.deadline,
            subject: subject,
          ),
        );
        Navigator.of(context).push(addDeadlinePage);
      },
      child: Text("Edit"),
    );
  }
}
