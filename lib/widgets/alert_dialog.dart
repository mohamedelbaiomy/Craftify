import 'package:flutter/cupertino.dart';

class MyAlertDilaog {
  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() tabNo,
    required Function() tabYes,
  }) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Dosis',
            letterSpacing: 1,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'Dosis',
            letterSpacing: 1,
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: tabNo,
            child: const Text(
              'No',
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1,
              ),
            ),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: tabYes,
            child: const Text(
              'Yes',
              style: TextStyle(
                fontFamily: 'Dosis',
                letterSpacing: 1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
