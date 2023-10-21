import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class C {
  static navTo(context, Widget screen) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade, child: screen));
  }

  static navToDown(context, Widget screen) {
    Navigator.push(context,
        PageTransition(type: PageTransitionType.bottomToTop, child: screen));
  }

  static pop(context) {
    Navigator.pop(
      context,
    );
  }

  static navToRemove(context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade, child: screen),
        (route) => false);
  }

  static navToRemoveDown(context, Widget screen) {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(type: PageTransitionType.topToBottom, child: screen),
        (route) => false);
  }

  static snack(String content, BuildContext context,
      {Color color = Colors.red, SnackBarAction? action}) {
    SnackBar snack = SnackBar(
      content: Text(content),
      backgroundColor: color,
      action: action,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  static toast({required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(msg: msg, backgroundColor: color, gravity: gravity);
  }
}
