import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Tip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: Colors.grey.shade900, width: 2),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                CupertinoIcons.lightbulb,
                color: Colors.yellow,
              ),
              SizedBox(
                width: 14,
              ),
              Txt(
                text: "Tips !",
                size: 16,
                weight: FontWeight.w500,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Txt(
              text:
                  "You can determine which Ai engine is the best by the usage metrics")
        ],
      ),
    );
  }
}
