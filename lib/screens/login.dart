import 'package:flutter/material.dart';
import 'package:xor/components/send_data.dart';
import 'package:xor/screens/recover.dart';
import './../components/input.dart';
import './../components/loginBtn.dart';
import 'package:xor/screens/dashboard.dart';
import 'package:xor/components/error_toast.dart';
import './register.dart';
import './../components/txt.dart';
import "package:shared_preferences/shared_preferences.dart";

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: Main()),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  String token = "";
  String loadingString = "Sign In";
  late SharedPreferences cache;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
    return Container(
        child: Stack(
      children: [
        Body(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Signin(
            btnText: loadingString, // To indicate loading progress
            onPress: () {
              setState(() {
                loadingString = "Please wait ...";
                if (emailController.text.trim() == "" ||
                    passwordController.text.trim() == "") {
                  loadingString = "Sign In";
                  Error("Please fill in the correct fields before proceeding");
                } else {
                  Map data = {
                    "email": emailController.text,
                    "password": passwordController.text
                  };
                  send(data, "POST", "/signin").then((value) {
                    if (value["status"] == 0) {
                      setState(() {
                        loadingString = "Sign In";
                      });

                      Error("Network disconnected");
                    } else if (value["status"] == 200) {
                      // setting the token to the cache
                      setState(() {
                        loadingString = "Signing in ...";
                      });
                      cache.setString("token", value["token"]);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => UserDash()));
                    } else {
                      setState(() {
                        loadingString = "Sign In";
                      });

                      Error("Incorrect Email or Password");
                    }
                  });
                }
              });
              //Navigator.pushReplacement(
              //    context, MaterialPageRoute(builder: (context) => UserDash()));
            },
          ),
        ),
      ],
    ));
  }

  Widget Body() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 0, 20),
              child: Txt(
                weight: FontWeight.w700,
                size: 25,
                text: "Sign In",
              ),
            )
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Txt(
                size: 19,
                text: "Welcome Back, Master",
              ),
            )
          ],
        ),
        SizedBox(
          height: 80,
        ),
        Input(hintText: "Email", controller: emailController, ico: Icons.email),
        SizedBox(
          height: 10,
        ),
        Password_Input(
            hintText: "Password",
            controller: passwordController,
            ico: Icons.lock),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Register())),
                  child: Txt(
                    text: "Create an account",
                  )),
              TextButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Recover())),
                  child: Txt(
                    text: "Forgot password?",
                  )),
            ],
          ),
        )
      ],
    );
  }
}
// SingleChildScrollView(child: Text("hey"))
