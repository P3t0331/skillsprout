import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/deadline_list.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/input_field.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/widgets/decorated_container.dart';

import 'package:deadline_tracker/widgets/dropdown_filter.dart';

import '../models/deadline.dart';

class SearchDeadlinesPage extends StatelessWidget {
  final List<Deadline> deadlines = [
    Deadline(
        title: "HW4",
        date: DateTime.now(),
        description:
            "A very long description: Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
            " Integer pellentesque quam vel velit. In enim a arcu imperdiet malesuada."
            " Integer lacinia. Aliquam id dolor. Curabitur vitae diam non enim vestibulum"
            " interdum. Nullam rhoncus aliquam metus. Nulla pulvinar eleifend sem. Nullam"
            " sapien sem, ornare ac, nonummy non, lobortis a enim. Sed elit dui, pellentesque"
            " a, faucibus vel, interdum nec, diam. Lorem ipsum dolor sit amet, consectetuer"
            " adipiscing elit. Integer pellentesque quam vel velit. In enim a arcu imperdiet"
            " malesuada. Integer lacinia. Aliquam id dolor. Curabitur vitae diam non enim"
            " vestibulum interdum. Nullam rhoncus aliquam metus. Nulla pulvinar eleifend sem."
            " Nullam sapien sem, ornare ac, nonummy non, lobortis a enim. Sed elit dui, pellentesque"
            " a, faucibus vel, interdum nec, diam. Lorem ipsum dolor sit amet, consectetuer "
            "adipiscing elit. Integer pellentesque quam vel velit. In enim a arcu imperdiet"
            " malesuada. Integer lacinia. Aliquam id dolor. Curabitur vitae diam non enim vestibulum"
            " interdum. Nullam rhoncus aliquam metus. Nulla pulvinar eleifend sem. Nullam sapien sem,"
            " ornare ac, nonummy non, lobortis a enim. Sed elit dui, pellentesque a, faucibus vel,"
            " interdum nec, diam."),
    Deadline(title: "HW2", date: DateTime.now()),
    Deadline(title: "HW10", date: DateTime.now()),
    Deadline(title: "HW15", date: DateTime.now()),
    Deadline(title: "HW27", date: DateTime.now()),
    Deadline(title: "HW37", date: DateTime.now()),
    Deadline(title: "HW45", date: DateTime.now()),
    Deadline(title: "HW55", date: DateTime.now()),
    Deadline(title: "HW87", date: DateTime.now()),
    Deadline(title: "HW98", date: DateTime.now()),
  ];

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
              options: ["Date", "Subject"],
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
            child: DeadlineList(deadlines: deadlines),
          )
        ],
      ),
    );
  }
}
