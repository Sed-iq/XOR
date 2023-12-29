import 'package:flutter/material.dart';
import 'package:xor/components/loginBtn.dart';

import 'package:xor/components/txt.dart';

class Support extends StatefulWidget {
  const Support({super.key});

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  var title = TextEditingController();
  String selected = "Ai21";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Txt(text: "Help and Support"),
      ),
      body: Container(
        child: Row(children: [
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                          backgroundColor: Colors.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: Column(children: <Widget>[
                                  Txt(
                                    text: "Create a new Conversation",
                                    align: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Normal_input(
                                    hintText: "Give a title",
                                    controller: title,
                                  ),
                                  Selector(
                                    lists: ["Ai21", "BigMan", "Picasso"],
                                    change: (chosen) {
                                      setState(() {
                                        selected = chosen;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Signin(
                                    pad_Ver: 10,
                                    pad_Hor: 10,
                                    height: 43,
                                    btnText: "Create",
                                    size: 14,
                                    onPress: () {},
                                  )
                                ]),
                              )
                            ],
                          ));
                    });
              },
              child: Txt(text: "Click me"))
        ]),
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
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
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

class Selector extends StatefulWidget {
  final List<String> lists;
  final Function change;
  const Selector({super.key, required this.lists, required this.change});

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  String selected = "Ai21";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton(
                dropdownColor: Colors.grey[800],
                alignment: Alignment.center,
                value: selected,
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 10,
                ),
                items: widget.lists.map((value) {
                  return DropdownMenuItem(
                      value: value, child: Txt(text: value));
                }).toList(),
                onChanged: (String? item) {
                  widget.change(item);
                  setState(() {
                    selected = item!;
                  });
                }),
          )
        ],
      ),
    );
  }
}
