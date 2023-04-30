import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/user_service.dart';

class JoinLeaveButton extends StatelessWidget {
  final AsyncSnapshot<bool?> snapshot;
  final String uid;
  final String subjectId;
  final _userService = GetIt.I<UserService>();

  JoinLeaveButton(
      {super.key,
      required this.snapshot,
      required this.uid,
      required this.subjectId});

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      print(snapshot.error);
      print("UID: ${uid}");
      return Text("Error loading data");
    }
    if (!snapshot.hasData) {
      return Text("No Data");
    }
    if (snapshot.data!) {
      return JoinButton();
    }
    return LeaveButton();
  }

  Widget JoinButton() {
    return ElevatedButton(
        onPressed: () {
          _userService.leaveSubject(uid, subjectId);
        },
        child: Text("Leave"));
  }

  Widget LeaveButton() {
    return ElevatedButton(
        onPressed: () {
          _userService.joinSubject(uid, subjectId);
        },
        child: Text("Join"));
  }
}
