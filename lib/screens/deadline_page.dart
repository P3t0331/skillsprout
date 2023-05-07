import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';
import '../services/auth.dart';
import '../utils/date_formatter.dart';
import '../utils/show_dialog_utils.dart';
import 'add_edit_deadline_page.dart';

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
            TitleText(text: deadline.title),
            SizedBox(
              height: 20,
            ),
            Text("Due: ${DateFormatter.formatDate(deadline.date)}"),
            SizedBox(
              height: 10,
            ),
            _canEdit
                ? Row(
                    children: [editButton(context), deleteButton(context)],
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
                child: Text(deadline.description),
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
        var subject =
            await _subjectService.getSubjectObjectById(deadline.subjectRef);
        final addDeadlinePage = MaterialPageRoute(
            builder: (BuildContext context) => AddEditDeadlinePage(
                  deadlineToEdit: deadline,
                  subject: subject,
                ));
        Navigator.of(context).push(addDeadlinePage);
      },
      child: Text("Edit"),
    );
  }
}
