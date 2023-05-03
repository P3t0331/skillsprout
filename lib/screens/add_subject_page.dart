import 'package:deadline_tracker/screens/subject_page.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/subject.dart';
import '../services/auth.dart';
import '../services/subject_service.dart';
import '../utils/show_dialog_utils.dart';
import '../widgets/decorated_container.dart';
import '../widgets/input_field.dart';

class AddSubjectPage extends StatefulWidget {
  AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _subjectService = GetIt.I<SubjectService>();
  final _authService = GetIt.I<Auth>();

  final _subjectCodeEditingController = TextEditingController();

  final _subjectNameEditingController = TextEditingController();

  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = _authService.currentUser!.uid;
  }

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
            InputField(
              controller: _subjectCodeEditingController,
              hintText: "Code",
            ),
            SizedBox(height: 10),
            InputField(
              controller: _subjectNameEditingController,
              hintText: "Name",
            ),
            SizedBox(height: 20),
            HorizontalButton(
              text: "Create",
              onTap: () {
                onCreatePressed(context);
              },
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            TitleText(text: "Search community subjects"),
            SizedBox(height: 10),
            InputField(
              hintText: "Search",
              useSearchIcon: true,
            ),
            SizedBox(height: 20),
            _drawSearchResults(),
          ],
        ),
      ),
    );
  }

  void onCreatePressed(BuildContext context) {
    if (_subjectCodeEditingController.text.isEmpty ||
        _subjectNameEditingController.text.isEmpty) {
      ShowDialogUtils.showInfoDialog(
          context, 'Error', 'Code or Name cant be empty');
    } else {
      _subjectService.createSubject(
        Subject(
            code: _subjectCodeEditingController.text,
            name: _subjectNameEditingController.text,
            authorId: _uid),
      );
      _subjectCodeEditingController.clear();
      _subjectNameEditingController.clear();
      ShowDialogUtils.showInfoDialog(
          context, "Success", "Successfully created subject");
    }
  }

  Widget _drawSearchResults() {
    //TODO change stream to show only relevant subjects based on search
    return StreamBuilderHandler<List<Subject>>(
        stream: _subjectService.subjectStream,
        toReturn: drawSearchResultHasData);
  }

  Widget drawSearchResultHasData(AsyncSnapshot<List<Subject>> snapshot) {
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
            '${subjects.length} ${subjects.length == 1 ? 'Result' : 'Results'} found',
            style: TextStyle(color: Colors.grey),
          ),
          Container(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: searchResultListView(subjects),
            ),
          ),
        ],
      ),
    );
  }

  ListView searchResultListView(List<Subject> subjects) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: subjects.length,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedContainer(
            child: InkWell(
              onTap: () {
                final subjectPage = MaterialPageRoute(
                  builder: (BuildContext context) => SubjectPage(
                    subject: subjects[index],
                  ),
                );
                Navigator.of(context).push(subjectPage);
              },
              child: Text(
                subjects[index].code + " " + subjects[index].name,
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => SizedBox(
              height: 10,
            ));
  }
}
