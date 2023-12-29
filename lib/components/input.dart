import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Input extends StatefulWidget {
  final String hintText;
  final controller;
  final dynamic ico;
  Input({
    super.key,
    required this.hintText,
    required this.controller,
    required this.ico,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: widget.controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            label: Txt(text: widget.hintText),
            prefixIcon: Icon(
              widget.ico,
              size: 20,
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.grey.shade800,
            filled: true),
      ),
    );
  }
}

class Msg_input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function onChanged;
  Msg_input(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white, fontSize: 15),
        onChanged: (value) {
          onChanged(value);
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: Color.fromRGBO(115, 115, 115, .23),
            filled: true,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15.7),
            hintText: hintText),
      ),
    );
  }
}

class Normal_input extends StatelessWidget {
  final controller;
  final String hintText;
  Normal_input({
    super.key,
    required this.hintText,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            fillColor: Colors.grey.shade800,
            filled: true,
            hintStyle: TextStyle(color: Colors.white),
            hintText: hintText),
      ),
    );
  }
}

class Password_Input extends StatefulWidget {
  final String hintText;
  final controller;
  final dynamic ico;
  const Password_Input({
    super.key,
    required this.hintText,
    required this.controller,
    required this.ico,
  });

  @override
  State<Password_Input> createState() => _Password_InputState();
}

class _Password_InputState extends State<Password_Input> {
  bool obs = true;
  var eye_color = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: obs,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.ico,
              size: 20,
              color: Colors.white,
            ),
            labelStyle: TextStyle(color: Colors.white),
            labelText: widget.hintText,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    if (obs == true) {
                      obs = false;
                      eye_color = Colors.grey;
                    } else {
                      obs = true;
                      eye_color = Colors.blue;
                    }
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  size: 20,
                  color: eye_color,
                )),
            focusedBorder: OutlineInputBorder(),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.grey.shade800,
            filled: true),
      ),
    );
  }
}
