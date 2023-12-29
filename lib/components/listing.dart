import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Listing extends StatelessWidget {
  const Listing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.military_tech,
                          color: Colors.yellow[600],
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Txt(
                          text: "Ai21",
                          size: 19,
                          weight: FontWeight.w700,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "%60 uptime",
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "used: 225 times",
                    ),
                  ],
                ),
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket,
                          color: Colors.cyan[600],
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Txt(
                          text: "Dream Studio",
                          size: 19,
                          weight: FontWeight.w700,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "%40 uptime",
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "used: 215 times",
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.book,
                          color: Colors.green[600],
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Txt(
                          text: "Open Ai",
                          size: 19,
                          weight: FontWeight.w700,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "%60 uptime",
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "used: 225 times",
                    ),
                  ],
                ),
              )),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Container(
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.rocket,
                          color: Colors.cyan[900],
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Txt(
                          text: "Dall-E",
                          size: 19,
                          weight: FontWeight.w700,
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "%40 uptime",
                    ),
                    SizedBox(height: 8),
                    Txt(
                      text: "used: 215 times",
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
