import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class BaseBtn extends StatefulWidget {
  final dynamic ico;
  final String text;
  final Function onTap;
  final String state;
  const BaseBtn(
      {super.key,
      required this.ico,
      required this.text,
      required this.onTap,
      required this.state});

  @override
  State<BaseBtn> createState() => _BaseBtnState();
}

class _BaseBtnState extends State<BaseBtn> {
  Color color(String name) {
    if (name == widget.state) {
      return Colors.white;
    } else
      return Colors.grey.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.transparent),
        onPressed: () {
          widget.onTap();
        },
        child: Column(children: [
          Icon(
            widget.ico,
            color: color(widget.text),
          ),
          Txt(
            colors: color(widget.text),
            text: widget.text,
            weight: FontWeight.w700,
          )
        ]),
      ),
    );
  }
}
