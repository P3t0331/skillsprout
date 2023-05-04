import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/streambuilder_handler.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/widgets/decorated_container.dart';

import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:get_it/get_it.dart';

import '../models/deadline.dart';

class SearchDeadlinesPage extends StatefulWidget {
  final _deadlineService = GetIt.I<DeadlineService>();

  @override
  State<SearchDeadlinesPage> createState() => _SearchDeadlinesPageState();
}

class _SearchDeadlinesPageState extends State<SearchDeadlinesPage> {
  late Stream<List<Deadline>> _deadlineStream;
  final _searchTextController = TextEditingController();
  String dropdownValue = "Date";

  @override
  void initState() {
    super.initState();
    _deadlineStream =
        widget._deadlineService.deadlineStream(orderBy: dropdownValue);

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
              child: StreamBuilderHandler<List<Deadline>>(
                  stream: _deadlineStream, toReturn: drawDeadlinesAfterChecks),
            )
          ],
        ),
      ),
    );
  }

  Widget drawDeadlinesAfterChecks(AsyncSnapshot<List<Deadline>> snapshot) {
    final data = snapshot.data!;
    if (data.length == 0) {
      return Center(child: Text("There is no data to display"));
    }

    final deadlines = snapshot.data!
        .where((deadline) => deadline.title
            .toLowerCase()
            .contains(_searchTextController.text.toLowerCase()))
        .toList();

    return DeadlineList(deadlines: deadlines);
  }
}
