import 'package:deadline_tracker/models/subject.dart';
import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/utils/show_dialog_utils.dart';
import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get_it/get_it.dart';

import '../services/subject_service.dart';
import '../widgets/decorated_container.dart';
import '../widgets/input_field.dart';

class AddDeadlinePage extends StatefulWidget {
  @override
  State<AddDeadlinePage> createState() => _AddDeadlinePageState();
}

class _AddDeadlinePageState extends State<AddDeadlinePage> {
  final _subjectService = GetIt.I<SubjectService>();

  final _deadlineService = GetIt.I<DeadlineService>();

  final _deadlineTitleEditingController = TextEditingController();
  final _deadlineDescriptionEditingController = TextEditingController();

  DateTime time = DateTime.now();
  String? dropdownValue = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Crete new deadline"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Select subject",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            DecoratedContainer(
              child: StreamBuilderHandler<List<Subject>>(
                  stream: _subjectService.subjectStream,
                  toReturn: drawDropdownFilterValuesAfterChecks),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            SizedBox(
              height: 10,
            ),
            DecoratedContainer(
                child: InputField(
                  controller: _deadlineTitleEditingController,
                  hintText: "Name",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2023, 1, 1),
                      maxTime: DateTime(2030, 12, 31), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    setState(() {
                      time = date;
                    });
                    print('confirm $date');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text("Select date")),
            SizedBox(
              height: 10,
            ),
            TitleText(
              text: "Deadline details",
              fontSize: 18,
            ),
            DecoratedContainer(
                child: TextFormField(
              minLines: 6,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
              controller: _deadlineDescriptionEditingController,
            )),
            SizedBox(
              height: 20,
            ),
            DecoratedContainer(
              child: HorizontalButton(
                text: "Create",
                onTap: () {
                  if (dropdownValue != null) {
                    _deadlineService.createDeadline(
                        title: _deadlineTitleEditingController.text,
                        date: time,
                        code: dropdownValue!,
                        description:
                            _deadlineDescriptionEditingController.text);
                    ShowDialogUtils.showInfoDialog(
                        context, 'Success', 'Deadline added Successfully');
                    Navigator.of(context).pop();
                  }
                },
              ),
              useGradient: true,
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawDropdownFilterValuesAfterChecks(
      AsyncSnapshot<List<Subject>> snapshot) {
    final data = snapshot.data!;
    if (data.length == 0) {
      return Center(child: Text("There is no data to display"));
    }

    final subjects = snapshot.data!.map((e) => e.code).toList();
    return DropdownFilter(
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value;
        });
      },
      value: dropdownValue,
      options: subjects,
    );
  }
}
