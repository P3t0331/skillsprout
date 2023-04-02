import 'package:deadline_tracker/widgets/deadline_card.dart';
import 'package:deadline_tracker/widgets/deadline_vote_card.dart';
import 'package:deadline_tracker/widgets/decorated_container.dart';
import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/home_header.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/search_field.dart';
import 'package:deadline_tracker/widgets/small_title_text.dart';
import 'package:deadline_tracker/widgets/subject_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          children: [
            DecoratedContainer(
              child: HorizontalButton(),
              useGradient: true,
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(
              height: 20,
            ),
            DecoratedContainer(child: HomeHeader(), useGradient: true),
            SizedBox(
              height: 20,
            ),
            DecoratedContainer(
              child: SearchField(),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SmallTitleText(text: "Subjects"),
            ),
            _drawSubjects(),
          ],
        ),
      ),
    );
  }

  Widget _drawSubjects() {
    return Expanded(
      child: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              DecoratedContainer(
                child: SubjectCard(),
              ),
              SizedBox(
                height: 20,
              ),
              DecoratedContainer(
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
                padding: EdgeInsets.zero,
              ),
              SizedBox(
                height: 20,
              ),
              DecoratedContainer(child: DeadlineCard()),
              SizedBox(
                height: 20,
              ),
              DecoratedContainer(child: DeadlineVoteCard()),
              SizedBox(
                height: 20,
              ),
              DecoratedContainer(
                child: DropdownFilter(),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
