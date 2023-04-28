import 'package:flutter/material.dart';

import '../widgets/popup_dialog.dart';

class ShowDialogUtils {
  static Future<void> showInfoDialog(
      BuildContext context, String title, String content) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return PopupDialog(title: title, content: content);
        });
  }
}
