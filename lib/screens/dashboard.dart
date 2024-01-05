import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:xor/screens/chat_overview.dart';
import 'package:xor/screens/login.dart';
import 'package:xor/screens/subs/loader.dart';
import 'package:xor/screens/subs/settings.dart';
import "package:xor/components/send_data.dart";
import 'package:xor/components/error_toast.dart';
import "package:shared_preferences/shared_preferences.dart";

class UserDash extends StatefulWidget {
  // User's dashboard
  const UserDash({super.key});

  @override
  State<UserDash> createState() => _UserDashState();
}

class _UserDashState extends State<UserDash> {
  String token = "";
  Map data = {};
  late SharedPreferences cache;
  void load() {
    send({"token": token}, "GET", "/dashboard").then((response) {
      if (response["status"] == 200) {
        Future.delayed(const Duration(milliseconds: 700), () {
          setState(() {
            data = {
              "name": response["message"]["name"],
              "conversations": response["message"]["conversations"]
            };
          }); // Adds data to state.
        });
      } else {
        cache.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Login()));
        Error(response["message"]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      init().then((value) {
        load();
      });
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
  int __index = 0;
  Widget display(BuildContext context, String $state, Map $data) {
    // checks state change and returns display that matches state
    switch ($state) {
      case "Home":
        return Chat_overview(
          conversations: $data["conversations"],
          token: token,
        );
      case "Setting":
        return const Setting();
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
        Future.delayed(const Duration(seconds: 3), () {
          BackTap = 0;
        });
        return false;
      }
    } else {
      Toast("Press back again to exit");
      setState(() {
        state = "Home";
        __index = 0;
      });
      return false;
    }
  } // Handles back button press

  @override
  Widget build(BuildContext context) {
    // For loading each time screen is mounted
    if (data["name"] != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: WillPopScope(
          onWillPop: _onPop,
          child: SafeArea(
            child: Stack(children: [
              display(context, state, data),
              //Align(
              //  alignment: Alignment.bottomCenter,
              //  child: Container(
              //    decoration: BoxDecoration(color: Colors.black),
              //    child: Padding(
              //      padding: EdgeInsets.symmetric(horizontal: 20),
              //      child: Row(
              //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //        children: [
              //          BaseBtn(
              //            state: state,
              //            onTap: () {
              //              setState(() {
              //                state = "Home";
              //              });
              //            },
              //            ico: CupertinoIcons.app_fill,
              //            text: "Home",
              //          ),
              //          BaseBtn(
              //            state: state,
              //            onTap: () {
              //              setState(() {
              //                state = "Chats";
              //              });
              //            },
              //            ico: CupertinoIcons.chat_bubble_2,
              //            text: "Chats",
              //          ),
              //          BaseBtn(
              //            state: state,
              //            onTap: () {
              //              setState(() {
              //                state = "Pay";
              //              });
              //            },
              //            ico: CupertinoIcons.money_dollar_circle,
              //            text: "Pay",
              //          ),
              //          BaseBtn(
              //            state: state,
              //            onTap: () {
              //              setState(() {
              //                state = "Setting";
              //              });
              //            },
              //            ico: Icons.settings,
              //            text: "Setting",
              //          ),
              //        ],
              //      ),
              //    ),
              //  ),
              //),
            ]),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey[800]!, width: 0.5))),
          child: BottomNavigationBar(
              currentIndex: __index,
              onTap: (index) {
                setState(() {
                  __index = index;
                });
                if (state == "Home" && index == 1) {
                  setState(() {
                    state = "Setting";
                  });
                } else {
                  if (index != 1) {
                    setState(() {
                      state = "Home";
                    });
                  }
                }
              },
              backgroundColor: Colors.black,
              unselectedItemColor: Colors.grey[500],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: Color.fromRGBO(120, 56, 233, 1),
              items: [
                BottomNavigationBarItem(
                    icon: Icon(MdiIcons.message),
                    label: "Chats",
                    tooltip: "Chats"),
                const BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: "Settings",
                    tooltip: "Settings"),
              ]),
        ),
        resizeToAvoidBottomInset: true,
      );
    } else {
      return Full_Load(); // Returns an empty container
    }
  }
}
