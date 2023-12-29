import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/base_btn.dart';
import 'package:xor/components/json_conv.dart';
import 'package:xor/screens/chat_overview.dart';
import 'package:xor/screens/subs/loader.dart';
import 'package:xor/screens/subs/settings.dart';
import "package:xor/components/send_data.dart";
import 'package:xor/components/error_toast.dart';
import "package:shared_preferences/shared_preferences.dart";
import './subs/home.dart';

class UserDash extends StatefulWidget {
  // User's dashboard
  const UserDash({super.key});

  @override
  State<UserDash> createState() => _UserDashState();
}

class _UserDashState extends State<UserDash> {
  String token = "";
  Map data = {};
  List engines = [];
  late SharedPreferences cache;
  void load() {
    send({"token": token}, "GET", "/engines").then((value) {
      setState(() {
        engines = value["message"];
      });
    });
    send({"token": token}, "GET", "/dashboard").then((value) {
      Future.delayed(Duration(milliseconds: 1500), () {
        cache.setString("user", value["message"]["userId"]);
        setState(() => data = {
              "id": value["message"]["userId"],
              "name": value["message"]["name"],
              "email": value["message"]["email"],
              "conversations": value["message"]["conversations"]
            });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      init().then((x) => load());
    } catch (e) {
      Error("An Error has occurred");
    }
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

  var base_color = Colors.grey.shade600;
  String username = "";
  var state = "Home";

  Widget display(BuildContext context, String $state, Map $data) {
    // checks state change and returns display that matches state
    switch ($state) {
      case "Home":
        return Home(context, $data["conversations"], $data["name"]);
      case "Setting":
        return Setting();
      case "Chats":
        return Chat_overview(
          conversations: $data["conversations"],
          engines: engines,
          token: token,
        );
      default:
        return Container();
    }
  }

  int BackTap = 0; // Used to count back button taps
  Future<bool> _onPop() async {
    if (state == "Home") {
      if (BackTap == 1) {
        return true;
      } else {
        Toast("Press back again to exit");
        setState(() {
          BackTap = 1;
        });
        Future.delayed(Duration(seconds: 3), () {
          BackTap = 0;
        });
        return false;
      }
    } else {
      setState(() {
        state = "Home";
      });
      return false;
    }
  } // Handles back button press

  @override
  Widget build(BuildContext context) {
    load(); // For loading each time screen is mounted
    if (data["name"] != null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: Colors.black,
            body: WillPopScope(
              onWillPop: _onPop,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 12,
                      child: SafeArea(
                        child: display(context, state, data),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(color: Colors.black),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseBtn(
                                  state: state,
                                  onTap: () {
                                    setState(() {
                                      state = "Home";
                                    });
                                  },
                                  ico: CupertinoIcons.app_fill,
                                  text: "Home",
                                ),
                                BaseBtn(
                                  state: state,
                                  onTap: () {
                                    setState(() {
                                      state = "Chats";
                                    });
                                  },
                                  ico: CupertinoIcons.chat_bubble_2,
                                  text: "Chats",
                                ),
                                BaseBtn(
                                  state: state,
                                  onTap: () {
                                    setState(() {
                                      state = "Pay";
                                    });
                                  },
                                  ico: CupertinoIcons.money_dollar_circle,
                                  text: "Pay",
                                ),
                                BaseBtn(
                                  state: state,
                                  onTap: () {
                                    setState(() {
                                      state = "Setting";
                                    });
                                  },
                                  ico: Icons.settings,
                                  text: "Setting",
                                ),
                              ],
                            ),
                          ),
                        )),
                  ]),
            ),
          ));
    } else {
      return Full_Load(); // Returns an empty container
    }
  }
}
