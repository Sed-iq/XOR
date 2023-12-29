import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Full_Load extends StatelessWidget {
  const Full_Load({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Center(
          child: Image(
            image: AssetImage("images/wait.gif"),
            height: 200,
            width: 200,
          ),
        ),
      ),
    );
  }
}
