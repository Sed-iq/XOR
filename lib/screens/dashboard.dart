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
  var base_color = Colors.grey.shade600;
  String username = "";
  var state = "Home";
  int __index = 0;
  Widget display() {
    // checks state change and returns display that matches state
    switch (state) {
      case "Home":
        return Chat_overview();
      case "Setting":
        return const Setting();
      default:
        return Container();
    }
  }

  // ignore: non_constant_identifier_names
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: _onPop,
        child: SafeArea(
          child: Stack(children: [
            display(),
          ]),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5))),
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
            selectedItemColor: const Color.fromRGBO(120, 56, 233, 1),
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
  }
}
