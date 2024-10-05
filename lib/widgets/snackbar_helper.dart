import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ridesense/utils/extensions.dart';

class SnackbarHelper {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(String message) {
    try {
      scaffoldMessengerKey.currentState
        ?..clearSnackBars()
        ..showSnackBar(SnackBar(
          content: Text(message,
              style: TextStyle(fontSize: 15.sp, color: Colors.white)),
          backgroundColor: Colors.blueGrey,
        ));
    } catch (ex) {
      ex.logError();
    }
  }
}
