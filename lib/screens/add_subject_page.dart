import 'package:deadline_tracker/main.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../services/subject_service.dart';
import '../widgets/decorated_container.dart';
import '../widgets/input_field.dart';
import '../widgets/subject_card.dart';

class AddSubjectPage extends StatefulWidget {
  AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _subjectService = GetIt.I<SubjectService>();

  final _subjectCodeEditingController = TextEditingController();

  final _subjectNameEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Crete new subject"),
            SizedBox(height: 20),
            DecoratedContainer(
                child: InputField(
                  controller: _subjectCodeEditingController,
                  hintText: "Code",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(height: 10),
            DecoratedContainer(
                child: InputField(
                  controller: _subjectNameEditingController,
                  hintText: "Name",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(height: 20),
            DecoratedContainer(
              child: HorizontalButton(
                text: "Create",
                onTap: () {
                  if (_subjectCodeEditingController.text.isEmpty ||
                      _subjectNameEditingController.text.isEmpty) {
                    showEmptyInputFieldsErrorDialog(context);
                  } else {
                    _subjectService.createSubject(Subject(
                        code: _subjectCodeEditingController.text,
                        name: _subjectNameEditingController.text));
                    _subjectCodeEditingController.clear();
                    _subjectNameEditingController.clear();
                  }
                },
              ),
              useGradient: true,
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            TitleText(text: "Search community subjects"),
            SizedBox(height: 10),
            DecoratedContainer(
              child: InputField(
                hintText: "Search",
                useSearchIcon: true,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            SizedBox(height: 20),
            _drawSearchResults(),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showEmptyInputFieldsErrorDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Code and Name cant be empty'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  Widget _drawSearchResults() {
    return StreamBuilder<List<Subject>>(
        //TODO change stream to show only relevant subjects based on search
        stream: _subjectService.subjectStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final subjects = snapshot.data!;
          if (subjects.length == 0) {
            return Text(
              "${subjects.length} Results found",
              style: TextStyle(color: Colors.grey),
            );
          }
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${subjects.length == 1 ? subjects.length.toString() + " Result found" : subjects.length.toString() + " Results found"}",
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(8.0),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: subjects.length,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedContainer(
                            child: Text(
                              subjects[index].code + " " + subjects[index].name,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              height: 10,
                            )),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
