import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/components/loginBtn.dart';
import 'package:xor/components/txt.dart';
import 'package:xor/components/input.dart';
import 'package:xor/screens/login.dart';
import 'package:xor/screens/subs/support.dart';

class Setting_base extends StatefulWidget {
  const Setting_base({super.key});

  @override
  State<Setting_base> createState() => _Setting_baseState();
}

class _Setting_baseState extends State<Setting_base> {
  var state = "Base";
  late SharedPreferences cache;
  String token = "";
  @override
  void initState() {
    super.initState();
    init();
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

  @override
  Widget build(BuildContext context) {
    return Base(context);
  }

  Widget Base(BuildContext $context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Txt(text: "Settings"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Txt(
              text: "Account Settings",
              size: 23,
              weight: FontWeight.w500,
            ),
            SizedBox(height: 8.1),
            Txt(
              text: "Update your account informations",
              size: 16,
              weight: FontWeight.w500,
              colors: Colors.grey[400],
            ),
            SizedBox(
              height: 50,
            ),
            Options(
              onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Information(context))),
              title: "Personal Information",
              description: "Edit your personal information",
              ico: Icons.person,
            ),
            Options(
              onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Support())),
              title: "Help and Support",
              description: "Need help? Speak to our team",
              ico: Icons.call,
            ),
            Options(
              onPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Security(context))),
              title: "Security",
              description: "Manage your password",
              ico: CupertinoIcons.lock_fill,
            ),
            Options(
              onPress: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        alignment: AlignmentDirectional.bottomCenter,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.grey[900],
                        child: Container(
                          //padding: EdgeInsets.all(18),
                          margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Txt(
                                  text: "Are you sure you want to Logout?",
                                  size: 17,
                                  colors: Colors.grey[400],
                                  weight: FontWeight.w700),
                              SizedBox(
                                height: 17,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors.transparent),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Txt(text: "No"),
                                          )),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors.transparent),
                                          onPressed: () async {
                                            await cache.clear();

                                            Navigator.of(context).pop(context);
                                            Navigator.pushReplacement(
                                                $context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        Login()));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Txt(text: "Yes"),
                                          )),
                                    )
                                  ]),
                            ],
                          ),
                        ),
                      );
                    });
              },
              title: "Logout",
              description: "Logout from Xor",
              ico: CupertinoIcons.power,
            ),
          ],
        ),
      ),
    );
  }

  Widget Information(BuildContext context) {
    var email_controller =
        TextEditingController(text: "sediqabdullahi01@gmail.com");
    var name_controller = TextEditingController(text: "Abdullahi Sediq");
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Txt(text: "Account information"),
          backgroundColor: Colors.black,
        ),
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Expanded(
                    child: Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.teal[700],
                            child: Icon(
                              Icons.rocket_sharp,
                              color: Colors.white,
                              size: 50,
                            ), //TODO: Replace with user PFP
                          )
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Txt(
                            text: "Abdullahi Sediq",
                            size: 18,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Txt(
                            text: "sediqabdullahi01@gmail.com",
                            size: 15,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Input(
                          hintText: "Email",
                          controller: email_controller,
                          ico: Icons.email_sharp),
                      SizedBox(
                        height: 10,
                      ),
                      Input(
                          hintText: "Name",
                          controller: name_controller,
                          ico: CupertinoIcons.person)
                    ]),
                  ),
                  Signin(
                      btnText: "Save",
                      onPress: () {
                        Navigator.pop(context);
                      }),
                ],
              )),
        ]));
  }

  Widget Security(BuildContext context) {
    var oldPassword = TextEditingController();
    var newPassword = TextEditingController();
    var repeatPassword = TextEditingController();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar:
            AppBar(title: Txt(text: "Security"), backgroundColor: Colors.black),
        body: CustomScrollView(slivers: [
          SliverFillRemaining(
              child: Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Txt(
                        text: "Change your password",
                        size: 19,
                        weight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Password_Input(
                        hintText: "Old Password",
                        controller: oldPassword,
                        ico: Icons.lock),
                    SizedBox(
                      height: 10,
                    ),
                    Password_Input(
                        hintText: "New Password",
                        controller: newPassword,
                        ico: Icons.lock),
                    SizedBox(
                      height: 10,
                    ),
                    Password_Input(
                        hintText: "Repeat Password",
                        controller: repeatPassword,
                        ico: Icons.lock),
                  ],
                )),
                Signin(btnText: "Save", onPress: () => Navigator.pop(context))
              ],
            ),
          ))
        ]));
  }
}

// sub class
class Options extends StatelessWidget {
  final String title;
  final String description;
  final IconData ico;
  final Function onPress;
  const Options(
      {super.key,
      required this.title,
      required this.description,
      required this.onPress,
      required this.ico});
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => onPress(),
        style: TextButton.styleFrom(
            foregroundColor: Colors.transparent,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30)),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Ink(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: Icon(
                      ico,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Txt(
                        text: title,
                        size: 17,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Txt(text: description)
                    ],
                  ),
                ],
              ),
              Icon(
                CupertinoIcons.right_chevron,
                size: 15,
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
