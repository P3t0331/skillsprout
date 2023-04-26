import 'package:deadline_tracker/main.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/small_title_text.dart';
import 'package:flutter/material.dart';

import '../models/deadline.dart';
import '../models/subject.dart';
import '../widgets/decorated_container.dart';
import '../widgets/input_field.dart';
import '../widgets/subject_card.dart';

class AddSubjectPage extends StatelessWidget {
  final List<Subject> subjects = [
    Subject(
        name: "Math",
        deadlines: [Deadline(title: "arithmetics", date: DateTime.now())]),
    Subject(
        name: "English",
        deadlines: [Deadline(title: "grammar", date: DateTime.now())]),
    Subject(name: "History", deadlines: [
      Deadline(title: "essay", date: DateTime.now()),
      Deadline(title: "essay2", date: DateTime.now())
    ]),
  ];

  AddSubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallTitleText(text: "Crete new subject"),
            SizedBox(height: 20),
            DecoratedContainer(
                child: InputField(
                  hintText: "Code",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(height: 10),
            DecoratedContainer(
                child: InputField(
                  hintText: "Name",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(height: 20),
            DecoratedContainer(
              child: HorizontalButton(
                text: "Create",
                onTap: () => {},
              ),
              useGradient: true,
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            SmallTitleText(text: "Search community subjects"),
            SizedBox(height: 10),
            DecoratedContainer(
              child: InputField(
                hintText: "Search",
                useSearchIcon: true,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            SizedBox(height: 20),
            Text(
              "${subjects.length} Results found",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            _drawSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _drawSearchResults() {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: ListView.separated(
              shrinkWrap: true,
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedContainer(
                  child: Text(
                    subjects[index].name,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                    height: 10,
                  )),
        ),
      ),
    );
  }
}
