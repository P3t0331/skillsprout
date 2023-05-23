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

import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/services/auth.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/services/user_service.dart';
import 'package:deadline_tracker/utils/date_formatter.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';

class AddEditDeadlinePage extends StatefulWidget {
  final Subject? subject;
  final Deadline? deadlineToEdit;
  AddEditDeadlinePage({super.key, this.subject, this.deadlineToEdit});

  @override
  State<AddEditDeadlinePage> createState() => _AddEditDeadlinePageState();
}

class _AddEditDeadlinePageState extends State<AddEditDeadlinePage> {
  final _subjectService = GetIt.I<SubjectService>();
  final _authService = GetIt.I<Auth>();
  final _deadlineService = GetIt.I<DeadlineService>();
  final _userService = GetIt.I<UserService>();

  final _deadlineTitleEditingController = TextEditingController();
  final _deadlineDescriptionEditingController = TextEditingController();

  DateTime _time = DateTime.now();
  String? _dropdownValue = null;
  bool _isButtonDisabled = true;
  bool _isEdit = false;

  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = _authService.currentUser!.uid;
    if (widget.subject != null) {
      _dropdownValue = widget.subject!.code;
    }
    // EDIT deadline
    if (widget.deadlineToEdit != null) {
      _deadlineTitleEditingController.text = widget.deadlineToEdit!.title;
      _deadlineDescriptionEditingController.text =
          widget.deadlineToEdit!.description;
      _time = widget.deadlineToEdit!.date;
      _isEdit = true;
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
            TitleText(text: _isEdit ? "Update deadline" : "Crete new deadline"),
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
                toReturn: _getSubjectIds),
            SizedBox(
              height: 10,
            ),
            InputField(
              controller: _deadlineTitleEditingController,
              hintText: "Name",
              maxLength: 100,
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                _buildDateTimeButton(
                  context: context,
                  text: "Select date",
                  minTime: DateTime(2023, 1, 1),
                  maxTime: DateTime(2030, 12, 31),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Date: ${DateFormatter.formatDate(_time)}",
                  style: TextStyle(fontSize: 16),
                )
              ],
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
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return HorizontalButton(
      text: _isEdit ? "Update" : "Create",
      isDisabled: _isButtonDisabled,
      onTap: () {
        if (_dropdownValue == null) {
          ShowDialogUtils.showInfoDialog(
              context, "Error", "Subject can't be empty");
        } else if (_deadlineTitleEditingController.text.trim().isEmpty) {
          ShowDialogUtils.showInfoDialog(
              context, "Error", "Name can't be empty");
          _deadlineTitleEditingController.clear();
        } else {
          _isEdit ? _updateDeadline(context) : _createDeadline(context);
        }
      },
    );
  }

  void _createDeadline(BuildContext context) {
    _deadlineService.createDeadline(
        title: _deadlineTitleEditingController.text,
        date: _time,
        code: _dropdownValue!,
        description: _deadlineDescriptionEditingController.text,
        authorId: _uid);
    ShowDialogUtils.showInfoDialog(
        context, 'Success', 'Deadline added successfully');
    Navigator.of(context).pop();
  }

  void _updateDeadline(BuildContext context) {
    _deadlineService.updateDeadline(
        deadlineId: widget.deadlineToEdit!.id,
        title: _deadlineTitleEditingController.text,
        date: _time,
        code: _dropdownValue!,
        description: _deadlineDescriptionEditingController.text);

    ShowDialogUtils.showInfoDialog(
        context, 'Success', 'Deadline updated successfully');
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  Widget _buildDateTimeButton(
      {required BuildContext context,
      required String text,
      DateTime? minTime,
      DateTime? maxTime}) {
    return ElevatedButton(
      onPressed: () {
        DatePicker.showDateTimePicker(context,
            showTitleActions: true,
            minTime: DateTime(2023, 1, 1),
            maxTime: DateTime(2030, 12, 31),
            onChanged: (date) {}, onConfirm: (date) {
          setState(() {
            _time = date;
          });
        }, currentTime: _time, locale: LocaleType.en);
      },
      child: Text(text),
    );
  }

  Widget _getSubjectIds(AsyncSnapshot<List<String>> subjectIdsSnapshot) {
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
        toReturn: _drawDropdownFilterValuesAfterChecks);
  }

  Widget _drawDropdownFilterValuesAfterChecks(
      AsyncSnapshot<List<Subject>> subjectSnapshot) {
    final data = subjectSnapshot.data!;
    if (data.length == 0) {
      return Center(child: Text("There is no data to display"));
    }

    final subjects = subjectSnapshot.data!.map((e) => e.code).toList();
    return DecoratedContainer(
      isExpanded: false,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownFilter(
        onChanged: (String? value) {
          setState(
            () {
              _dropdownValue = value;
            },
          );
        },
        value: _dropdownValue,
        options: subjects,
      ),
    );
  }
}
