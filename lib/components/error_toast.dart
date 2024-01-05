import "package:fluttertoast/fluttertoast.dart";
import 'package:flutter/material.dart';

void Error(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.TOP,
    textColor: Colors.white,
    backgroundColor: Colors.red[400],
  );
}

void Toast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    textColor: Colors.white,
    backgroundColor: Colors.grey[800],
  );
}
