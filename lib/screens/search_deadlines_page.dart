import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/user_service.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/widgets/decorated_container.dart';

import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:get_it/get_it.dart';

import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/services/auth.dart';

class SearchDeadlinesPage extends StatefulWidget {
  final _deadlineService = GetIt.I<DeadlineService>();
  final _userService = GetIt.I<UserService>();
  final _authService = GetIt.I<Auth>();
  late final String _uid = _authService.currentUser!.uid;

  @override
  State<SearchDeadlinesPage> createState() => _SearchDeadlinesPageState();
}

class _SearchDeadlinesPageState extends State<SearchDeadlinesPage> {
  final _searchTextController = TextEditingController();
  String dropdownValue = "Date";

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64.0),
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Sort by"),
            SizedBox(height: 10),
            DecoratedContainer(
              isExpanded: false,
              child: DropdownFilter(
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                options: ["Date", "Title"],
                value: dropdownValue,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            SizedBox(height: 10),
            InputField(
              hintText: "Search",
              useSearchIcon: true,
              controller: _searchTextController,
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilderHandler<List<String>>(
                  stream: widget._userService.getUserSubjectIds(widget._uid),
                  toReturn: _drawDeadlinesAfterChecks),
            )
          ],
        ),
      ),
    );
  }

  Widget _drawDeadlinesAfterChecks(AsyncSnapshot<List<String>> snapshot) {
    final subjectIds = snapshot.data!;
    return StreamBuilderHandler(
        stream: widget._deadlineService.deadlineStream(),
        toReturn: (AsyncSnapshot<List<Deadline>> snapshot) {
          final deadlines = snapshot.data!
              .where((deadline) =>
                  subjectIds.contains(deadline.subjectRef) &&
                  deadline.title
                      .toLowerCase()
                      .contains(_searchTextController.text.toLowerCase()))
              .toList();
          if (deadlines.isEmpty) {
            return Center(child: Text("There is no data to display"));
          }
          if (dropdownValue == "Title") {
            deadlines.sort((a, b) => a.title.compareTo(b.title));
          } else {
            deadlines.sort((a, b) => a.date.compareTo(b.date));
          }
          return DeadlineList(
            deadlines: deadlines,
            showCode: true,
          );
        });
  }
}
