import 'package:deadline_tracker/utils/show_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/user_service.dart';

class JoinLeaveButton extends StatelessWidget {
  final bool joinedSubject;
  final String uid;
  final String subjectId;
  final _userService = GetIt.I<UserService>();

  JoinLeaveButton(
      {super.key,
      required this.joinedSubject,
      required this.uid,
      required this.subjectId});

  @override
  Widget build(BuildContext context) {
    if (joinedSubject) {
      return LeaveButton(context);
    }
    return JoinButton(context);
  }

  Widget JoinButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _userService.joinSubject(uid, subjectId).then((value) {
            ShowDialogUtils.showInfoDialog(context, "Joined subject",
                "You will receive push notifications when a new deadline is approved");
          });
        },
        child: Text("Join"));
  }

  Widget LeaveButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          ShowDialogUtils.showConfirmDialog(context, "Leave subject",
              "Are you sure you want to leave this subject?", () {
            _userService.leaveSubject(uid, subjectId);
          });
        },
        child: Text("Leave"));
  }
}
