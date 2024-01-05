import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xor/components/txt.dart';

class Full_Load extends StatelessWidget {
  const Full_Load({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: AssetImage("images/wait.gif"),
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}

class Pre_Load extends StatefulWidget {
  const Pre_Load({super.key});

  @override
  State<Pre_Load> createState() => _Pre_LoadState();
}

class _Pre_LoadState extends State<Pre_Load> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: Colors.grey[900],
                  ),
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(120, 56, 233, 1),
                    strokeWidth: 2.4,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
