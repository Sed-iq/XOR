import 'package:flutter/material.dart';

class Txt extends StatelessWidget {
  final Color? colors;
  final String text;
  final double? size;
  final dynamic weight;
  final dynamic align;
  final dynamic fontFamily;
  const Txt(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.align,
      this.fontFamily,
      this.colors});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          fontFamily: fontFamily,
          color: colors ?? Colors.white,
          fontSize: size,
          fontWeight: weight),
    );
  }
}

class BTxt extends StatelessWidget {
  final Color? colors;
  final String text;
  final double? size;
  final dynamic weight;
  final dynamic align;
  final dynamic fontFamily;
  const BTxt(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.align,
      this.fontFamily,
      this.colors});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      textAlign: align ?? TextAlign.start,
      style: TextStyle(
          fontFamily: fontFamily,
          color: colors ?? Colors.black,
          fontSize: size,
          fontWeight: weight),
    );
  }
}

class WTxt extends StatelessWidget {
  final Color? colors;
  final String text;
  final double? size;
  final dynamic weight;
  final dynamic align;
  final dynamic fontFamily;
  final TextOverflow overflow;
  const WTxt(
      {super.key,
      required this.text,
      this.size,
      this.weight,
      this.align,
      this.fontFamily,
      required this.overflow,
      this.colors});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            overflow: overflow,
            textAlign: align ?? TextAlign.start,
            style: TextStyle(
                fontFamily: fontFamily,
                color: colors ?? Colors.white,
                fontSize: size,
                fontWeight: weight),
          ),
        ),
      ],
    );
  }
}
