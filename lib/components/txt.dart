import 'package:flutter/material.dart';

class Txt extends StatelessWidget {
  final Color? colors;
  final String text;
  final double? size;
  final dynamic weight;
  final dynamic align;
  Txt(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.align,
      this.colors});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          color: colors ?? Colors.white, fontSize: size, fontWeight: weight),
    );
  }
}
