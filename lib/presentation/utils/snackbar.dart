import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

abstract class Snackbar{

  static triggerSnackbar({required String message, required BuildContext context, String? title}){
    if(title != null){
      Flushbar(
        title: title,
        message:  message,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        borderRadius: BorderRadius.circular(20),
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 600),
      ).show(context);
    } else {
      Flushbar(
        message:  message,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        borderRadius: BorderRadius.circular(20),
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 600),
      ).show(context);
    }
  }
}