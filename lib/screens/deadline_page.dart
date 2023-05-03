import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';

import '../models/deadline.dart';
import '../utils/date_formatter.dart';

class DeadlinePage extends StatelessWidget {
  final Deadline deadline;
  DeadlinePage({super.key, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: deadline.title),
            SizedBox(
              height: 20,
            ),
            Text("Due: ${DateFormatter.formatDate(deadline.date)}"),
            SizedBox(
              height: 20,
            ),
            TitleText(
              text: "Deadline details",
              fontSize: 18,
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(deadline.description),
              ),
            )
          ],
        ),
      ),
    );
  }
}
