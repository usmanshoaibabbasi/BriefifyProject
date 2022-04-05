import 'package:briefify/data/constants.dart';
import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBarWithoutAction(context,
      {message = 'Error !', dismissDuration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: dismissDuration,
      backgroundColor: kPrimaryColorLight,
    ));
  }

  static void showSnackBarWithAction(
    context,
    onPressed, {
    message = 'Error !',
    actionMessage = 'Retry',
    dismissDuration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: dismissDuration,
      backgroundColor: kPrimaryColorLight,
      action: SnackBarAction(
        label: actionMessage,
        onPressed: onPressed,
        textColor: Colors.white,
      ),
    ));
  }
}
