import 'package:deadline_tracker/decorated_container.dart';
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
            child: Column(
          children: [
            DecoratedContainer(
              child: HorizontalButton(),
              gradient: LinearGradient(
                colors: [Color(0xFF1243BF), Color(0xFF4C6AD4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              padding: EdgeInsets.all(8.0),
            ),
            SizedBox(
              height: 20,
            ),
            DecoratedContainer(
              child: HomeHeader(),
              gradient: LinearGradient(
                colors: [Color(0xFF1243BF), Color(0xFF4C6AD4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
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
            ),
          ],
        )),
      ),
    );
  }
}
