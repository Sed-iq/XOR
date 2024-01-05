import 'package:flutter/material.dart';
import 'package:xor/components/input.dart';
import 'package:xor/components/loginBtn.dart';
import 'package:xor/components/txt.dart';

class Recover extends StatelessWidget {
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_sharp)),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Txt(
            text: "Recover Password",
            size: 25,
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: 30,
          ),
          Input(hintText: "Email", controller: email, ico: Icons.email_sharp),
          Signin(
              btnText: "Verify",
              onPress: () async {
                var data = await Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Code()));
                if (data == true) {
                  Navigator.pop(context);
                }
              })
        ],
      )),
    ));
  }
}

class Code extends StatelessWidget {
  // Verify code screen
  final verification_code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_sharp)),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Txt(
            text: "Enter Verification Code",
            size: 25,
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: 30,
          ),
          Password_Input(
              hintText: "Verification code",
              controller: verification_code,
              ico: Icons.key_sharp),
          Signin(
              btnText: "Verify",
              onPress: () async {
                var data = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SetPassword()));
                if (data == true) {
                  Navigator.pop(context, true);
                }
              })
        ],
      )),
    ));
  }
}

class SetPassword extends StatelessWidget {
  // Verify code screen
  final verification_code = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: IconButton(
            onPressed: () => Navigator.pop(context, true),
            icon: Icon(Icons.arrow_back_sharp)),
      ),
      backgroundColor: Colors.black,
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Txt(
            text: "Set New Password",
            size: 25,
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: 30,
          ),
          Password_Input(
              hintText: "New Password",
              controller: verification_code,
              ico: Icons.key_sharp),
          Signin(
            btnText: "Set Password",
            onPress: () {
              Navigator.pop(context,
                  true); // True being set to make verify email page pop itself out
            },
          )
        ],
      )),
    ));
  }
}
