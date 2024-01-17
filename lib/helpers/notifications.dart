import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';

class NotificationsToast {
  void displayWarningMotionToast(String text, BuildContext context) {
    MotionToast.warning(
      title: Text(
        'Внимание',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      dismissable: true,
      toastDuration: Duration(seconds: 5),
    ).show(context);
  }

  void displaySuccessfulMoationToast(String text, BuildContext context) {
    MotionToast.success(
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      width: 300,
      dismissable: true,
    ).show(context);
  }

  void displayErrorMotionToast(String text, BuildContext context) {
    MotionToast.error(
      title: Text(
        'Ошибка',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(text),
      animationType: AnimationType.fromLeft,
      position: MotionToastPosition.bottom,
      width: 300,
      dismissable: true,
    ).show(context);
  }
}
