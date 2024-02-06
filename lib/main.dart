import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:xor/components/txt.dart';
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
      home: const Loading()));
}
