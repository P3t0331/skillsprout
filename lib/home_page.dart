import 'package:deadline_tracker/deadline_card.dart';
import 'package:deadline_tracker/deadline_vote_card.dart';
import 'package:deadline_tracker/decorated_container.dart';
import 'package:deadline_tracker/dropdown_filter.dart';
import 'package:deadline_tracker/home_header.dart';
import 'package:deadline_tracker/horizontal_button.dart';
import 'package:deadline_tracker/search_field.dart';
import 'package:deadline_tracker/small_title_text.dart';
import 'package:deadline_tracker/subject_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Center(
            child: Container(
          constraints: BoxConstraints(maxWidth: 800),
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
        )),
      ),
    );
  }
}
