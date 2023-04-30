import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/deadline_vote_card.dart';
import 'package:flutter/material.dart';

import '../models/deadline.dart';
import '../screens/deadline_page.dart';
import 'decorated_container.dart';

class DeadlineList extends StatelessWidget {
  final List<Deadline> deadlines;
  final bool useVoteCards;

  DeadlineList({super.key, required this.deadlines, this.useVoteCards = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: ListView.separated(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: deadlines.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  final subjectPage = MaterialPageRoute(
                    builder: (BuildContext context) => DeadlinePage(
                      deadline: deadlines[index],
                    ),
                  );
                  Navigator.of(context).push(subjectPage);
                },
                child: DecoratedContainer(
                  child: useVoteCards
                      ? DeadlineVoteCard(deadline: deadlines[index])
                      : DeadlineCard(
                          deadline: deadlines[index],
                        ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) => SizedBox(
                  height: 20,
                )),
      ),
    );
  }
}
