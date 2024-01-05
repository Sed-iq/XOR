import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xor/components/send_data.dart';
import 'package:xor/screens/dashboard.dart';
import './../components/input.dart';
import './../components/loginBtn.dart';
import './../components/txt.dart';
import "package:xor/components/error_toast.dart";
import 'login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
                child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Main(),
                )
              ],
            ))));
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final userController = TextEditingController();
  late SharedPreferences cache;
  String token = "";
  @override
  void initState() {
    super.initState();
    init();
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
            btnText: "Sign Up",
            onPress: signup,
          ),
        ),
      ],
    ));
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

  void signup() async {
    if (emailController.text == "" ||
        passwordController == "" ||
        passwordController2 == "" ||
        userController == "")
      Error("Please fill in all the fields");
    else if (passwordController.text != passwordController2.text)
      Error("Both passwords do not match");
    else {
      Map data = {
        "fullname": userController.text,
        "email": emailController.text,
        "password": passwordController.text,
      };
      try {
        var res = await send(data, "POST", "/signup");
        if (res["status"] == 200) {
          cache.setString("token", res["token"]);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => UserDash()));
        } else if (res["status"] == 0)
          Error("Network disconnected");
        else if (res["status"] == 403)
          Error(res["message"]);
        else
          Error("An error has occured please try again");
      } catch (e) {
        Error("An error has occured please try again");
      }
    }
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
                text: "Sign Up",
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
                text: "Join the XOR family",
              ),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Input(
            hintText: "Fullname",
            controller: userController,
            ico: Icons.person),
        SizedBox(
          height: 10,
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
        Password_Input(
            hintText: "Re-Password",
            controller: passwordController2,
            ico: Icons.lock),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Login())),
                  child: Txt(
                    text: "Have an account?",
                  ))
            ],
          ),
        )
      ],
    );
  }
}
// SingleChildScrollView(child: Text("hey"))
