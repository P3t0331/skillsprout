import 'package:deadline_tracker/utils/string_formatter.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final int dueToday;
  final int dueWeek;
  HomeHeader({super.key, required this.dueToday, required this.dueWeek});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.MMMMd().format(DateTime.now());

    return DecoratedContainer(
      useGradient: true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            Text(
              "${StringFormatter.handlePlural(dueToday, "Deadline")} due today",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "${StringFormatter.handlePlural(dueWeek, "Deadline")} due this week",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
