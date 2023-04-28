import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeHeader extends StatelessWidget {
  final int dueToday;
  final int dueWeek;
  HomeHeader({super.key, required this.dueToday, required this.dueWeek});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.MMMMd().format(DateTime.now());

    return Align(
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
            "${dueToday.toString()} deadlines due today",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Text(
            "${dueWeek.toString()} deadlines due this week",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
