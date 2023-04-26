import 'package:deadline_tracker/widgets/page_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:deadline_tracker/services/auth.dart';

class SettingsPage extends StatelessWidget {
  Future<void> _singOut(BuildContext context) async {
    try {
      await Auth().signOut();
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(e.message, context);
    }
  }

  Future<void> _showErrorDialog(String? text, BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(text ?? 'An unknown error occurred'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageContainer(
      child: ElevatedButton(
        onPressed: () {
          _singOut(context);
        },
        child: Text('Sign Out'),
      ),
    );
  }
}
