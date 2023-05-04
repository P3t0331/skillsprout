import 'package:flutter/material.dart';

import '../widgets/popup_dialog.dart';

class ShowDialogUtils {
  static Future<void> showInfoDialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
          ],
        );
      },
    );
  }

  static Future<void> showConfirmDialog(BuildContext context, String title,
      String content, VoidCallback onConfirm) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return PopupDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')),
            TextButton(
                onPressed: () => {onConfirm(), Navigator.of(context).pop()},
                child: Text('Confirm'))
          ],
        );
      },
    );
  }
}
