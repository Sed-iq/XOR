import 'package:flutter/material.dart';

class Signin extends StatelessWidget {
  final String btnText;
  final Function onPress;
  final double? size;
  final double? pad_Ver;
  final double? pad_Hor;
  final double? height;
  const Signin(
      {super.key,
      required this.btnText,
      required this.onPress,
      this.size,
      this.pad_Ver,
      this.height,
      this.pad_Hor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: pad_Ver ?? 30, horizontal: pad_Hor ?? 30),
      child: GestureDetector(
          onTap: () => onPress(),
          child: Container(
            height: height ?? 50,
            decoration: BoxDecoration(
                color: Color.fromRGBO(120, 56, 233, 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  btnText,
                  style: TextStyle(
                      fontSize: size ?? 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )
              ],
            ),
          )),
    );
  }
}
