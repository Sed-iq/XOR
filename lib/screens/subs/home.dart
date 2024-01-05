import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/chat_history.dart';
import 'package:xor/components/listing.dart';
import 'package:xor/components/txt.dart';
import 'package:xor/screens/chat.dart';

Widget Home(BuildContext context, List conversation, name) {
  List<Widget> Conversations() {
    List<Widget> chats = [];
    if (conversation.length > 0) {
      for (var i = 0; i < conversation.length; i++) {
        if (i >= 3)
          break;
        else
          chats.add(GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Chat(
                            id: conversation[i]["id"],
                          )));
            },
            child: Chat_history(
              time: "07/06/23",
              title: conversation[i]["title"],
              icons: CupertinoIcons.bubble_left,
            ),
          ));
      }
    }
    if (chats.length == 0) {
      chats.add(empty());
    }
    return chats;
  }

  return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: Image(
                    image: AssetImage("images/welcome.gif"),
                    width: 40,
                    height: 40,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 2, color: Colors.white)),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    "Welcome $name",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ))
                ],
              )),
          SizedBox(
            height: 23,
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Txt(text: "Recent Conversations"),
                SizedBox(
                  height: 20,
                ),
                // Previous chats
                Column(children: Conversations())
              ],
            ),
          ),
        ],
      ));

  //Conversations();
}

Widget empty() {
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("images/empty.gif"),
              height: 180,
              width: 180,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Txt(
          text: "Oops... no recent conversations",
        ),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}
//Image(image: AssetImage("images/empty.png"))
