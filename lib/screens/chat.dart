// Chat screen
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/components/input.dart';
import 'package:xor/components/json_conv.dart';
import 'package:xor/components/txt.dart';
import "package:http/http.dart" as http;
import 'package:xor/components/error_toast.dart';
import 'package:xor/screens/loading.dart';
import "package:xor/components/config.dart";
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  final String id;
  const Chat({super.key, required this.id});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String token = "";
  String engine = "";
  String? userId = "";

  Map chats = {}; // Lists of chats
  late IO.Socket socket;
  late SharedPreferences cache;
  List<Widget> msg_shuffle() {
    // Used to shuffle the messages
    List<Widget> arr = []; // Temporary holder
    for (var i = 0; i < chats["chats"].length; i++) {
      if (chats["chats"][i]["sender"] == "bot") {
        arr.add(BotBubble(
            message: chats["chats"][i]["message"],
            date: chats["chats"][i]["time"]));
      } else {
        arr.add(UserMsg(
            message: chats["chats"][i]["message"],
            date: chats["chats"][i]["time"]));
      }
    }
    return arr;
  }

  @override
  void initState() {
    super.initState();
    init().then((value) => load().then((value) => Socket()));
  }

  @override
  void dispose() {
    super.dispose();
    socket.disconnect();
  }

  Future init() async {
    cache = await SharedPreferences.getInstance();
    String? token = cache.getString("token");
    setState(() {
      userId = cache.getString("user");
    });
    String? $engine = cache.getString(widget.id);
    //if ($engine != null) {
    //  print("here");
    //}
    if ($engine != null) {
      setState(() {
        engine = $engine;
      });
    } else {
      cache.setString(widget.id, "Ai21");
      String? $ = cache.getString(widget.id);
      setState(() {
        engine = $!;
      });
      print(engine);
    }
    if (token != null) {
      setState(() {
        this.token = token;
      });
    }
  }

  void Socket() {
    try {
      socket = IO.io("ws://192.168.43.71:5000/", {
        "autoConnect": false,
        "transports": ["websocket"],
      });
      socket.connect();
    } catch (e) {
      //Navigator.pop(context);
      Error("Something went wrong");
    }
  }

  Future Prompt(String prompt) async {
    String time = DateTime.now().day.toString() +
        "/" +
        DateTime.now().month.toString() +
        "/" +
        DateTime.now().year.toString();

    Map _prompt = {
      "sender": userId,
      "message": prompt,
      "conversation": widget.id,
      "time": time,
    };
    print("sending");
    socket.emit("prompt", _prompt);
    setState(() {
      chats["chats"].add(_prompt);
    });

    socket.once("response", (message) {
      setState(() {
        chats["chats"].add(message);
      });
    });
  }

  Future load() async {
    // Loads the chat data
    try {
      var res = await http.get(Uri.parse("$URL/chat/" + widget.id),
          headers: {"x-token": token});
      if (res.statusCode == 200) {
        setState(() {
          chats = {
            "title": json(res.body)["message"]["name"],
            "chats": json(res.body)["message"]["chats"]
          };
        });
      } else {
        Error("There seems to be an error getting chats");
        Navigator.pop(context);
      }
    } catch (e) {
      Error("There seems to be an error getting chats");
      Navigator.pop(context);
    }
  }

  var message = TextEditingController();
  Color? btnColor = Colors.grey[900];
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    if (chats["title"] != null) {
      socket.once("error", (data) {
        Error("Error In connection");
      });
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          shape: Border(bottom: BorderSide(color: Colors.grey[800]!)),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
            SizedBox(width: 10),
          ],
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.teal[900],
                radius: 20,
                child: Icon(
                  Icons.military_tech_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 17,
              ),
              Txt(text: chats["title"])
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
      return Pre_Load(); // Loading screen
    }
  }

  Widget Chats(_scrollController) {
    if (chats["chats"].length > 0) {
      return SingleChildScrollView(
        reverse: true,
        controller: _scrollController,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: msg_shuffle(),
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
          Txt(text: "Welcome to XOR, type a prompt to begin.")
        ],
      ));
    }
  }

  Widget Message(ScrollController _scrollController) {
    // Showing
    return Container(
        height: 70,
        padding: EdgeInsets.fromLTRB(8, 8, 10, 8),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Msg_input(
                    onChanged: (value) {
                      if (value != "") {
                        setState(() {
                          btnColor = Color.fromRGBO(120, 56, 233, .4);
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
                      if (message.text != "") {
                        Prompt(message.text).then((value) {
                          setState(() {
                            message.text = "";
                            btnColor = Colors.grey[900];
                          });
                        }).catchError((error) {
                          print(error);
                        });
                      }
                    },
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(
                      Icons.send_outlined,
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ));
  } // Message typing bar down below
}

class UserMsg extends StatelessWidget {
  final String message;
  final String date;
  const UserMsg({super.key, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
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
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Txt(
                    text: date,
                    colors: Colors.grey[700],
                  )
                ]),
          ),
        ],
      ),
    );
  }
}

class BotBubble extends StatelessWidget {
  final String message;
  final String date;
  const BotBubble({super.key, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      padding:
                          EdgeInsets.symmetric(vertical: 17, horizontal: 23),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Txt(
                    text: date,
                    colors: Colors.grey[700],
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
//