// Chat list screen
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/loginBtn.dart';
import 'package:xor/components/txt.dart';
import 'package:xor/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/screens/login.dart';
import 'package:xor/screens/subs/home.dart';
import "package:http/http.dart" as http;
import 'package:xor/components/error_toast.dart';
import "package:xor/components/json_conv.dart";

class Chat_overview extends StatefulWidget {
  final List conversations;
  final String token;
  final List engines;
  const Chat_overview(
      {super.key,
      required this.conversations,
      required this.token,
      required this.engines});
  @override
  State<Chat_overview> createState() => _Chat_overviewState();
}

class _Chat_overviewState extends State<Chat_overview> {
  // Lists of chats

  List<Widget> history() {
    List<Widget> arr = [];
    if (widget.conversations.length > 0) {
      for (var i = 0; i < widget.conversations.length; i++) {
        if (widget.conversations[i]['chats'].length > 0) {
          arr.add(HistoryModal(
              id: widget.conversations[i]["id"],
              title: widget.conversations[i]["title"],
              date: widget.conversations[i]["chats"]
                  [widget.conversations[i]["chats"].length - 1]["time"],
              engine: widget.conversations[i]["title"],
              history: widget.conversations[i]["chats"]
                      [widget.conversations[i]["chats"].length - 1]
                  ["message"])); // Adding Modal to the array stack
          // widget.conversations[i]["chats"].length -1 is to get the last element in the array
        } else {
          arr.add(HistoryModal(
            id: widget.conversations[i]["id"],
            title: widget.conversations[i]["title"],
            date: "...",
            engine: widget.conversations[i]["title"],
            history: ".......",
          ));
        }
      }
    }
    return arr;
  }

  late SharedPreferences cache;

  @override
  void initState() {
    super.initState();
    init();
    //iterateEngines();
  }

  Future init() async {
    cache = await SharedPreferences.getInstance();
  }

  String selectedEngine = "Ai21";
  List<String> engines() {
    List<String> $ = [];
    widget.engines.forEach((element) {
      $.add(element["engine"]);
    });
    return $;
  }

  Widget Base() {
    if (widget.conversations.length > 0) {
      return SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: history(),
        ),
      ));
    } else {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage("images/empty_box.gif")),
            SizedBox(
              height: 40,
            ),
            Txt(text: "Hmmm.... It's very desolate here")
          ],
        ),
      );
    }
  }
  // Base returns either the main content or the empty animation

  @override
  Widget build(BuildContext $context) {
    return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CreateConversationModal(
                      engines: engines(),
                      done: (String title) async {
                        if (title != "") {
                          try {
                            var res = await http.post(
                                Uri.parse(
                                    "http://192.168.43.71:5000/conversation"),
                                headers: {"x-token": widget.token},
                                body: {"title": title});
                            if (res.statusCode == 200) {
                              String data = json(res.body)["message"];
                              cache.setString(data, selectedEngine);

                              Navigator.of(context).pop(context);
                              Navigator.push(
                                  $context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => Chat(
                                            id: data,
                                          )));
                            } else
                              Error("There seems to be an error");
                          } catch (e) {
                            Error("There seems to be an error");
                          }
                        } else
                          Error("Title cannot be empty");

                        //cache.setString(, value)
                      },
                      onChanged: (String selected) {
                        setState(() {
                          selectedEngine = selected;
                        });
                      });
                });
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(120, 56, 233, 1),
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Txt(text: "Chats"),
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.sort_down,
                )),
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.refresh)),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Base());
  }
}

//onPress: () async {
//
class HistoryModal extends StatelessWidget {
  // TODO: make title icon date onTap and engine name as parameters
  final String title;
  final String date;
  final String id;
  final String engine;
  final String history;
  const HistoryModal(
      {key,
      required this.title,
      required this.date,
      required this.id,
      required this.engine,
      required this.history});
  @override
  Widget build(BuildContext context) {
    // Chat history widget
    return TextButton(
      style: TextButton.styleFrom(
          foregroundColor: Colors.transparent,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Chat(
                    id: id,
                  ))),
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal[900],
              child: Icon(
                Icons.military_tech_outlined,
                size: 23,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Txt(
                            text: engine,
                            size: 18,
                          ),
                          Txt(
                            text: date,
                            colors: Colors.grey[400],
                            size: 13,
                          ),
                        ]),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text(
                          history,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.grey[400]),
                        ))
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class Normal_input extends StatelessWidget {
  final controller;
  final String hintText;
  Normal_input({
    super.key,
    required this.hintText,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: Colors.grey.shade800,
            filled: true,
            hintStyle: TextStyle(color: Colors.white),
            hintText: hintText),
      ),
    );
  }
}

class CreateConversationModal extends StatefulWidget {
  final List<String> engines;
  final Function onChanged;
  final Function done;
  const CreateConversationModal({
    super.key,
    required this.engines,
    required this.onChanged,
    required this.done,
  });

  @override
  State<CreateConversationModal> createState() =>
      _CreateConversationModalState();
}

class _CreateConversationModalState extends State<CreateConversationModal> {
  var conversation_title = TextEditingController();
  String selectedEngine = "Ai21";
  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: AlignmentDirectional.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.grey[900],
      child: Container(
        //padding: EdgeInsets.all(18),
        margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Txt(
                text: "Create New Conversation",
                size: 17,
                colors: Colors.grey[400],
                weight: FontWeight.w700),
            SizedBox(
              height: 17,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Normal_input(
                hintText: "Give a title",
                controller: conversation_title,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Txt(
                    text: "Select your Ai",
                    colors: Colors.grey[400],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 6, 0, 5),
                      child: DropdownButton(
                          icon: Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 10,
                          ),
                          dropdownColor: Colors.grey[800],
                          value: selectedEngine,
                          items: widget.engines.map((value) {
                            return DropdownMenuItem(
                                value: value,
                                child: Txt(
                                  text: value,
                                  size: 14,
                                ));
                          }).toList(),
                          onChanged: (value) {
                            widget.onChanged(value);
                            setState(() {
                              selectedEngine = value!;
                            });
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Signin(
                pad_Ver: 10,
                pad_Hor: 10,
                height: 43,
                btnText: "Create",
                size: 14,
                onPress: () => widget.done(conversation_title.text),

                //Navigator.pop(widget.$context);
              ),
            )
            //Signin(

            //  btnText: "Create Conversation",
            //),
          ],
        ),
      ),
    );
  }
}
