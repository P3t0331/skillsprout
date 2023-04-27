import 'package:deadline_tracker/widgets/dropdown_filter.dart';
import 'package:deadline_tracker/widgets/horizontal_button.dart';
import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:deadline_tracker/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../widgets/decorated_container.dart';
import '../widgets/input_field.dart';

class AddDeadlinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleText(text: "Crete new deadline"),
            SizedBox(
              height: 20,
            ),
            Text(
              "Select subject",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 5,
            ),
            // TODO Add user subjects to drop down options
            DecoratedContainer(
              child: DropdownFilter(
                options: ["Math", "English", "History"],
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            SizedBox(
              height: 10,
            ),
            DecoratedContainer(
                child: InputField(
                  hintText: "Name",
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0)),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2023, 1, 1),
                      maxTime: DateTime(2030, 12, 31), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    print('confirm $date');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Text("Select date")),
            SizedBox(
              height: 10,
            ),
            TitleText(
              text: "Deadline details",
              fontSize: 18,
            ),
            DecoratedContainer(
                child: TextFormField(
              minLines: 6,
              keyboardType: TextInputType.multiline,
              maxLines: 6,
            )),
            SizedBox(
              height: 20,
            ),
            DecoratedContainer(
              child: HorizontalButton(
                text: "Create",
                onTap: () => {},
              ),
              useGradient: true,
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
