import 'package:deadline_tracker/models/subject.dart';
import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/utils/show_dialog_utils.dart';
import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_it/get_it.dart';

import '../services/auth.dart';
import '../services/subject_service.dart';
import '../services/user_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/decorated_container.dart';
import '../widgets/futurebuilder_handler.dart';
import '../widgets/input_field.dart';
import '../widgets/streambuilder_handler.dart';

class AddDeadlinePage extends StatefulWidget {
  final Subject? subject;
  AddDeadlinePage({super.key, this.subject});

  @override
  State<AddDeadlinePage> createState() => _AddDeadlinePageState();
}

class _AddDeadlinePageState extends State<AddDeadlinePage> {
  final _subjectService = GetIt.I<SubjectService>();
  final _authService = GetIt.I<Auth>();
  final _deadlineService = GetIt.I<DeadlineService>();
  final _userService = GetIt.I<UserService>();

  final _deadlineTitleEditingController = TextEditingController();
  final _deadlineDescriptionEditingController = TextEditingController();

  DateTime time = DateTime.now();
  String? dropdownValue = null;
  bool _isButtonDisabled = true;

  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = _authService.currentUser!.uid;
    if (widget.subject != null) {
      dropdownValue = widget.subject!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Crete new deadline"),
            SizedBox(
              height: 10,
            ),
            Text(
              "Select subject",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            StreamBuilderHandler(
                stream: _userService.getUserSubjectIds(_uid),
                toReturn: getSubjectIds),
            SizedBox(
              height: 10,
            ),
            InputField(
              controller: _deadlineTitleEditingController,
              hintText: "Name",
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                buildDateTimeButton(
                    context: context,
                    text: "Select date",
                    minTime: DateTime(2023, 1, 1),
                    maxTime: DateTime(2030, 12, 31),
                    isDate: true),
                SizedBox(
                  width: 20,
                ),
                buildDateTimeButton(
                    context: context, text: "Select time", isDate: false),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Date: ${DateFormatter.formatDate(time)}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            TitleText(
              text: "Deadline details",
              fontSize: 18,
            ),
            Expanded(
              child: DecoratedContainer(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  controller: _deadlineDescriptionEditingController,
                  maxLines: null,
                  expands: true,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildCreateButton(BuildContext context) {
    return HorizontalButton(
      text: "Create",
      isDisabled: _isButtonDisabled,
      onTap: () {
        if (dropdownValue == null) {
          ShowDialogUtils.showInfoDialog(
              context, "Error", "Subject can't be empty");
        } else if (_deadlineTitleEditingController.text.isEmpty) {
          ShowDialogUtils.showInfoDialog(
              context, "Error", "Name can't be empty");
        } else {
          _deadlineService.createDeadline(
              title: _deadlineTitleEditingController.text,
              date: time,
              code: dropdownValue!,
              description: _deadlineDescriptionEditingController.text,
              authorId: _uid);
          ShowDialogUtils.showInfoDialog(
              context, 'Success', 'Deadline added Successfully');
          Navigator.of(context).pop();
        }
      },
    );
  }

  Widget buildDateTimeButton(
      {required BuildContext context,
      required String text,
      DateTime? minTime,
      DateTime? maxTime,
      required bool isDate}) {
    return ElevatedButton(
      onPressed: () {
        if (isDate) {
          DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime(2023, 1, 1),
              maxTime: DateTime(2030, 12, 31),
              onChanged: (date) {}, onConfirm: (date) {
            setState(() {
              time = date;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        } else {
          DatePicker.showTimePicker(context,
              showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
            setState(() {
              time = date;
            });
          }, currentTime: DateTime.now(), locale: LocaleType.en);
        }
      },
      child: Text(text),
    );
  }

  Widget getSubjectIds(AsyncSnapshot<List<String>> subjectIdsSnapshot) {
    if (subjectIdsSnapshot.data!.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
            _isButtonDisabled = true;
          }));
      return Text("No subject registered");
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
          _isButtonDisabled = false;
        }));
    return StreamBuilderHandler(
        stream: _subjectService.getSubjectsById(subjectIdsSnapshot.data!),
        toReturn: drawDropdownFilterValuesAfterChecks);
  }

  Widget drawDropdownFilterValuesAfterChecks(
      AsyncSnapshot<List<Subject>> subjectSnapshot) {
    final data = subjectSnapshot.data!;
    if (data.length == 0) {
      return Center(child: Text("There is no data to display"));
    }

    final subjects = subjectSnapshot.data!.map((e) => e.code).toList();
    return DecoratedContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownFilter(
        onChanged: (String? value) {
          setState(
            () {
              dropdownValue = value;
            },
          );
        },
        value: dropdownValue,
        options: subjects,
      ),
    );
  }
}
