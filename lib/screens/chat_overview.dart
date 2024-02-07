// Chat list screen
// ignore_for_file: camel_case_types
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:xor/components/loginBtn.dart';
import 'package:xor/components/txt.dart';
import 'package:xor/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/screens/login.dart';
import 'package:xor/components/send_data.dart';
import "package:http/http.dart" as http;
import 'package:xor/components/error_toast.dart';
import "package:xor/components/json_conv.dart";
import "package:flutter_animate/flutter_animate.dart";
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xor/screens/subs/loader.dart';

class Chat_overview extends StatefulWidget {
  const Chat_overview({
    super.key,
  });
  @override
  State<Chat_overview> createState() => _Chat_overviewState();
}

class _Chat_overviewState extends State<Chat_overview> {
  // Lists of chats
  late Map data = {};
  List<Widget> history() {
    List<Widget> arr = [
      const SizedBox(
        height: 20,
      )
    ];
    if (data["conversations"].length > 0) {
      for (var i = 0; i < data["conversations"].length; i++) {
        if (data["conversations"][i]['chats'].length > 0) {
          arr.add(HistoryModal(
              id: data["conversations"][i]["id"],
              title: data["conversations"][i]["title"],
              date: data["conversations"][i]["chats"]
                  [data["conversations"][i]["chats"].length - 1]["time"],
              history: data["conversations"][i]["chats"]
                      [data["conversations"][i]["chats"].length - 1]
                  ["message"])); // Adding Modal to the array stack
          // data["conversations"][i]["chats"].length -1 is to get the last element in the array
        } else {
          arr.add(HistoryModal(
            id: data["conversations"][i]["id"],
            title: data["conversations"][i]["title"],
            date: "....",
            history: ".......",
          ));
        }
      }
    }
    return arr;
  }

  String token = "";
  late SharedPreferences cache;
  void load() {
    send({"token": token}, "GET", "/dashboard").then((response) {
      if (response["status"] == 200) {
        if (mounted) {
          cache.setString("userid", response["message"]["id"]);
          setState(() {
            data = {
              "name": response["message"]["name"],
              "conversations": response["message"]["conversations"]
            };
          }); // Adds data to state.
        }
      } else {
        // cache.remove("token");
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => const Login()));
        // Error(response["message"]);
      }
    }).catchError((e) {
      Error("There seems to be an error");
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => const Login()));
    });
  }

  @override
  void initState() {
    super.initState();
    init().then((value) {
      load();
    }).catchError((e) {
      Error("There seems to be an error");
      print(e);
    });
  }

  Future init() async {
    cache = await SharedPreferences.getInstance();
    String? token = cache.getString("token");
    if (token != null) {
      setState(() {
        this.token = token;
      });
    }
  }

  // ignore: non_constant_identifier_names
  Widget Base(Map $data) {
    if ($data["conversations"].length > 0) {
      load();
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade800))),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 44, 44, 44),
                        child: Icon(
                          MdiIcons.chatOutline,
                          color: Colors.white,
                          size: 17,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Txt(
                        text: "Chats",
                        size: 19.5,
                        weight: FontWeight.bold,
                      )
                    ],
                  ),
                ).animate().slideX(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 100)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: history(),
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade800))),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 44, 44, 44),
                          child: Icon(
                            MdiIcons.human,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Txt(
                          text: "Chats",
                          size: 19.5,
                          weight: FontWeight.bold,
                        )
                      ],
                    ),
                  ).animate().slideX(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 100)),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Image(
                  image: AssetImage("images/welcome.gif"),
                  width: 180,
                  height: 180,
                ).animate().scale(),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      MdiIcons.alert,
                      color: Colors.amber,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Txt(
                      text: "You have no chats",
                      size: 18,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }
  }
  // Base returns either the main content or the empty animation

  @override
  Widget build(BuildContext $context) {
    final title = TextEditingController();
    if (data["name"] != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
                showDragHandle: true,
                context: context,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20))),
                backgroundColor: Colors.grey[900],
                builder: (BuildContext context) {
                  return CreateModal(
                    onCreate: () {
                      load();
                    },
                    controller: title,
                    mainScreenContext: $context,
                    token: token,
                  );
                });
          },
          //icon: Icon(),
          icon: Icon(MdiIcons.chartBubble),
          label: Txt(text: "New Chat"),
          tooltip: "Create new chat",

          backgroundColor: const Color.fromRGBO(120, 56, 233, 1),
        ).animate().slideX(
            begin: 1,
            end: 0,
            curve: Curves.ease,
            duration: const Duration(milliseconds: 200)),
        body: SafeArea(child: Base(data)),
      );
    } else {
      return const Pre_Load();
    }
  }
}

//onPress: () async {
//

class CreateModal extends StatefulWidget {
  final BuildContext mainScreenContext;
  final TextEditingController controller;
  final Function onCreate; // If successfully created
  final String token;
  const CreateModal(
      {super.key,
      required this.onCreate,
      required this.mainScreenContext,
      required this.controller,
      required this.token});

  @override
  State<CreateModal> createState() => _CreateModalState();
}

class _CreateModalState extends State<CreateModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, top: 7),
      child: Stack(
        children: [
          ListView(children: [
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Normal_input(
                bg: Colors.grey[800],
                hintText: "Name of the chat",
                controller: widget.controller,
              ),
            ),
          ]),
          Align(
            alignment: Alignment.bottomCenter,
            child: Signin(
                btnText: "Chat",
                onPress: () async {
                  // Create conversation
                  if (widget.controller.text.trim() == "") {
                    Error("Name cannot be empty");
                  } else {
                    showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (BuildContext $context) {
                          createConv(widget.controller.text.trim()).then((res) {
                            if (res != null) {
                              widget.onCreate();
                              Navigator.of(context).pop();
                              Navigator.of($context).pop();
                              Navigator.of(widget.mainScreenContext).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Chat(id: res)));
                            } else {
                              Navigator.of($context).pop();
                            }
                          }).catchError((err) {
                            print(err);
                            Error("There seems to be an error");
                            Navigator.of($context).pop();
                          });
                          return WillPopScope(
                              onWillPop: () async {
                                return false;
                              },
                              child: $load());
                        });
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget $load() {
    return const Dialog.fullscreen(
      backgroundColor: Color.fromARGB(80, 0, 0, 0),
      child: Pre_Load(),
    );
  }

  Future createConv(String title) async {
    // Function to create new conversation
    return sec_post({"title": title}, "/conversation", widget.token)
        .then((response) {
      if (response["status"] == 200) {
        return response["message"];
      } else if (response["status"] == 0) {
        throw 0;
      } else {
        throw "";
      }
    }).catchError((e) {
      Error("There seems to be an error.");
      return null;
    });
  }
}

class HistoryModal extends StatelessWidget {
  // TODO: make title icon date onTap and engine name as parameters
  final String title;
  final String date;
  final String id;
  final String history;
  const HistoryModal(
      {super.key,
      required this.title,
      required this.date,
      required this.id,
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
        padding: const EdgeInsets.fromLTRB(23, 5, 23, 0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.teal[900],
              child: const Icon(
                Icons.military_tech_outlined,
                size: 23,
              ),
            ),
            const SizedBox(
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
                            text: title,
                            weight: FontWeight.w500,
                            colors: Colors.grey[400],
                            size: 19,
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
  final Color? bg;
  final String hintText;
  Normal_input({
    super.key,
    this.bg,
    required this.hintText,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: bg ?? Colors.grey.shade800,
            filled: true,
            hintStyle: const TextStyle(color: Colors.white),
            hintText: hintText),
      ),
    );
  }
}
