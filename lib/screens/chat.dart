// Chat screen
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/components/input.dart';
import 'package:xor/components/json_conv.dart';
import 'package:xor/components/send_data.dart';
import 'package:xor/components/txt.dart';
import "package:http/http.dart" as http;
import 'package:xor/components/error_toast.dart';
import 'package:xor/screens/loading.dart';
import "package:xor/components/config.dart";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Chat extends StatefulWidget {
  final String id;
  const Chat({super.key, required this.id});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String token = "";
  String type = "text";
  String? userId = "";
  bool canPrompt = true;
  bool loading = false;

  String? title;
  late List<Widget> chats = []; // Lists of chats
  late SharedPreferences cache;

  @override
  void initState() {
    super.initState();
    try {
      init().then((value) => load());
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future init() async {
    cache = await SharedPreferences.getInstance();
    String? token = cache.getString("token");
    setState(() {
      userId = cache.getString("userid");
    });
    if (token != null) {
      setState(() {
        this.token = token;
      });
    }
  }

  Future Prompt(String prompt) async {
    Map _prompt = {
      "sender": userId,
      "prompt": prompt.trim(),
      "type": type,
      "conversationId": widget.id,
    };
    setState(() {
      chats.add(UserMsg(
        message: prompt,
      ).animate().slideY(
          begin: 0.3,
          end: 0,
          curve: Curves.ease,
          duration: const Duration(milliseconds: 250)));
    });
    sec_post(_prompt, "/ai", token).then((value) {
      setState(() {
        canPrompt = true;
        loading = false;
      });

      if (value["status"] == 200) {
        setState(() {
          chats.add(BotBubble(
            message: value["message"]["msg"],
            type: value["message"]["type"],
          ).animate().slideY(
              begin: 0.3,
              end: 0,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 250)));
        });
      } else {
        throw value["status"];
      }
    }).catchError((e) {
      print(e);
      Error("There seems to be an error");
      setState(() {
        loading = false;
        canPrompt = true;
      });
      setState(() {
        chats.removeLast();
      });
    });
  }

  Future load() async {
    // Loads the chat data
    try {
      var res = await http.get(Uri.parse("$URL/chat/${widget.id}"),
          headers: {"x-token": token});
      if (res.statusCode == 200) {
        List arr = json(res.body)["message"]["chats"];
        setState(() {
          title = json(res.body)["message"]["name"];

          if (arr.isNotEmpty == true) {
            for (var i = 0; i < arr.length; i++) {
              if (arr[i]["sender"] == "bot") {
                chats.add(BotBubble(
                  message: arr[i]["message"].trim(),
                  type: arr[i]["type"],
                ));
              } else {
                chats.add(UserMsg(message: arr[i]["message"].trim()));
              }
            }
          }
        });
      } else {
        Error("There seems to be an error getting chats");
        throw "";
      }
    } catch (e) {
      print(e);
      Error("There seems to be an error getting chats");
      // Navigator.pop(context);
    }
  }

  var message = TextEditingController();
  Color? btnColor = Colors.grey[900];
  Color? typeColor(String type) {
    if (this.type == type) {
      return Colors.purple[500];
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    if (title != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          shape: Border(bottom: BorderSide(color: Colors.grey[800]!)),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    type = "text";
                  });
                },
                color: typeColor("text"),
                tooltip: "Text Ai",
                icon: const Icon(Icons.text_snippet)),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {
                  setState(() {
                    type = "image";
                  });
                },
                tooltip: "Image Ai",
                color: typeColor("image"),
                icon: const Icon(Icons.image)),
            const SizedBox(width: 10),
          ],
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal[900],
                radius: 20,
                child: const Icon(
                  Icons.military_tech_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                width: 17,
              ),
              Txt(text: title!)
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(flex: 1, child: Chats(_scrollController)),
            Message(_scrollController)
          ],
        ),
      );
    } else {
      return const Pre_Load(); // Loading screen
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Widget Chats(_scrollController) {
    if (chats.isNotEmpty == true) {
      return SingleChildScrollView(
        reverse: true,
        controller: _scrollController,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              Column(
                children: chats,
              ),
              Builder(builder: (context) {
                if (loading == true) {
                  return Row(
                    children: [
                      Animate(
                        effects: const [
                          SlideEffect(
                              begin: Offset(-1, 0),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease)
                        ],
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 23),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: Icon(
                            MdiIcons.dotsHorizontal,
                            size: 21,
                            color: Colors.grey[500],
                          )
                              .animate(
                                onComplete: (controller) => controller.loop(),
                              )
                              .fade(duration: Duration(seconds: 2)),
                        ),
                      ),
                    ],
                  );
                } else
                  return Container();
              })
            ],
          ),
        ),
      );
    } else {
      return Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("images/chat_welcome.gif"),
            height: 150,
            width: 150,
          ),
          const SizedBox(
            height: 20,
          ),
          Txt(
            text: "Welcome to XOR, type a prompt to begin.",
            weight: FontWeight.bold,
          )
        ],
      ))
          .animate()
          .slideY(
              begin: 0.1, end: 0, duration: const Duration(milliseconds: 300))
          .fadeIn();
    }
  }

  Widget Message(ScrollController _scrollController) {
    // Showing
    return Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: Msg_input(
                        onChanged: (value) {
                          if (value != "") {
                            setState(() {
                              btnColor = const Color.fromRGBO(120, 56, 233, .4);
                            });
                          } else {
                            setState(() {
                              btnColor = Colors.grey[900];
                            });
                          }
                        },
                        hintText: "Tell me something...",
                        controller: message)),
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: btnColor,
                    child: IconButton(
                        onPressed: () {
                          if (message.text != "" && canPrompt == true) {
                            Future.delayed(Duration(milliseconds: 800), () {
                              setState(() {
                                canPrompt = false;
                                loading = true;
                              });
                            });
                            Prompt(message.text).then((value) {
                              setState(() {
                                message.text = "";
                                btnColor = Colors.grey[900];
                              });
                            }).catchError((error) {
                              setState(() {
                                canPrompt = true;
                              });
                              print(error);
                            });
                          }
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(
                          Icons.send_outlined,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ))
        .animate()
        .slideY(
            begin: 0.6, end: 0, duration: const Duration(milliseconds: 200));
  } // Message typing bar down below
}

class UserMsg extends StatelessWidget {
  final String message;
  const UserMsg({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      padding:
                          EdgeInsets.symmetric(vertical: 17, horizontal: 23),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(120, 56, 233, .3),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

class BotBubble extends StatelessWidget {
  final String message;
  final String type;
  const BotBubble({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 23),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Builder(builder: (context) {
                        if (type == "text") {
                          return Text(
                            message.trim(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          );
                        } else if (type == "image") {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: message,
                              height: 240,
                              width: 240,
                              placeholder: (context, progress) => Center(
                                child: CircularProgressIndicator(
                                    color: Colors.purple.shade700,
                                    strokeWidth: 2.5),
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            child: Txt(text: "Type not specified"),
                          );
                        }
                      })),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
//
