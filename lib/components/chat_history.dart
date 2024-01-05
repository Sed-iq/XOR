import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Chat_history extends StatelessWidget {
  final String time;
  final IconData? icons;
  final String title;
  const Chat_history(
      {super.key, required this.time, this.icons, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: EdgeInsets.symmetric(horizontal: 13, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icons,
              color: Colors.teal[400],
            ),
            SizedBox(
              width: 20,
            ),

            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 20,
            ),

            Txt(
              text: time,
              colors: Colors.grey.shade300,
              size: 12,
            ),
            //Txt(
            //  text: time,
            //  colors: Colors.grey.shade300,
            //  size: 12,
            //)
          ],
        ));
  }
}
