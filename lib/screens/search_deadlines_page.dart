import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
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
  String dropdownValue = "Date";

  @override
  Widget build(BuildContext context) {
    return PageContainer(
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
              options: ["Date", "Subject"],
              value: dropdownValue,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
          SizedBox(height: 10),
          DecoratedContainer(
            child: InputField(
              hintText: "Search",
              useSearchIcon: true,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          SizedBox(height: 40),
          Expanded(
            child: StreamBuilder<List<Deadline>>(
                stream: widget._deadlineService.deadlineStream(),
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
                  final deadlines = snapshot.data!;
                  return DeadlineList(deadlines: deadlines);
                }),
          )
        ],
      ),
    );
  }
}
