import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  const SubjectCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PV239 - Mobile Application dev..."),
                Text("2 deadlines", style: TextStyle(color: Colors.grey))
              ]),
          Icon(Icons.arrow_forward_ios_outlined)
        ],
      ),
    );
  }
}
