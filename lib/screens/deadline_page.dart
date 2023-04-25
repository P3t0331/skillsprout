import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/search_field.dart';
import 'package:deadline_tracker/widgets/small_title_text.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/widgets/decorated_container.dart';

import 'package:deadline_tracker/widgets/dropdown_filter.dart';

class DeadlinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SmallTitleText(text: "Sort by"),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: DecoratedContainer(
                child: DropdownFilter(),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ),
            SizedBox(height: 10),
            DecoratedContainer(
              child: SearchField(),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            SizedBox(height: 40),
            DecoratedContainer(child: DeadlineCard()),
            SizedBox(height: 10),
            DecoratedContainer(child: DeadlineCard()),
            SizedBox(height: 10),
            DecoratedContainer(child: DeadlineCard()),
          ],
        ),
      ),
    );
  }
}
