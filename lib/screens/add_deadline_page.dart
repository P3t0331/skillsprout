import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
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
            // TODO Add user subjects to drop down options
            DecoratedContainer(
              child: StreamBuilder(
                  stream: _subjectService.subjectStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
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
                  }),
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
                        Deadline(
                            title: _deadlineTitleEditingController.text,
                            date: time),
                        dropdownValue!);
                    showDialogSuccessful(context);
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

  Future<dynamic> showDialogSuccessful(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Deadline added successfully'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }
}
