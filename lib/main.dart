import 'package:flutter/material.dart';
import 'package:xor/screens/loading.dart';

class MyScrollBehaviour extends MaterialScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      title: "XOR",
      scrollBehavior: MyScrollBehaviour(),
      themeMode: ThemeMode.dark,
      //theme: ThemeData(fontFamily: "Roboto"),
      home: const Loading()));
}
