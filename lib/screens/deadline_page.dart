import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:deadline_tracker/widgets/futurebuilder_handler.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/models/subject.dart';
import 'package:deadline_tracker/services/auth.dart';
import 'package:deadline_tracker/utils/date_formatter.dart';
import 'package:deadline_tracker/utils/show_dialog_utils.dart';
import 'package:deadline_tracker/screens/add_edit_deadline_page.dart';

class DeadlinePage extends StatelessWidget {
  final Deadline deadline;

  DeadlinePage({super.key, required this.deadline});

  final _deadlineService = GetIt.I<DeadlineService>();
  final _subjectService = GetIt.I<SubjectService>();
  late final String _uid = GetIt.I<Auth>().currentUser!.uid;
  late final bool _canEdit = _uid == deadline.authorId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DecoratedContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    text: deadline.title,
                  ),
                  FutureBuilderHandler(
                    future: _subjectService
                        .getSubjectObjectById(deadline.subjectRef),
                    toReturn: (AsyncSnapshot<Subject> snapshot) {
                      final subject = snapshot.data!;
                      return TitleText(
                        text: "${subject.code} ${subject.name}",
                        fontSize: 18,
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            FutureBuilderHandler(
              future: _subjectService.getSubjectObjectById(deadline.subjectRef),
              toReturn: (AsyncSnapshot<Subject> snapshot) {
                final subject = snapshot.data!;
                final voteAmount =
                    deadline.upvoteIds.length - deadline.downvoteIds.length;
                return Row(
                  children: [
                    Text(
                      "Votes: ${voteAmount}",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      "${voteAmount >= subject.requiredVotes ? "Approved" : "Not yet approved"}",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Due: ${DateFormatter.formatDate(deadline.date)}",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: _canEdit ? 10 : 0,
            ),
            _canEdit
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
            Divider(),
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
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SingleChildScrollView(
                  child: deadline.description.isEmpty
                      ? Text("No description provided")
                      : Text(deadline.description),
                ),
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
            "Delete deadline ${deadline.title}?",
            "This will permanently delete this deadline.", () {
          _deadlineService.deleteDeadline(deadline);
          Navigator.of(context).pop();
        });
      },
      child: Text("Delete"),
    );
  }

  Widget editButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final subject =
            await _subjectService.getSubjectObjectById(deadline.subjectRef);
        final addDeadlinePage = MaterialPageRoute(
          builder: (BuildContext context) => AddEditDeadlinePage(
            deadlineToEdit: deadline,
            subject: subject,
          ),
        );
        Navigator.of(context).push(addDeadlinePage);
      },
      child: Text("Edit"),
    );
  }
}
