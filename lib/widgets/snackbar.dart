import 'package:flutter/material.dart';
import 'package:customers_app_google_play/providers/constants2.dart';

class MyMessageHandler {
  static void showSnackBar(
    var scaffoldKey,
    String message,
  ) {
    scaffoldKey.currentState!.hideCurrentSnackBar();
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: textColor,
        elevation: 2,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Dosis',
            fontSize: 19,
            letterSpacing: 1,
            color: scaffoldColor,
          ),
        ),
      ),
    );
  }
}
