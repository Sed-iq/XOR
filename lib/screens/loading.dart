import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:xor/components/txt.dart";
import "package:xor/components/verify.dart";
import "package:xor/screens/dashboard.dart";
import "package:xor/screens/login.dart";
import "package:shared_preferences/shared_preferences.dart";

class Loading extends StatefulWidget {
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String token = "";
  String btntxt = "Retry";
  bool? network;
  late SharedPreferences cache;

  void load() {
    init()
        .then((x) => verify(token).then((auth) {
              if (auth == true)
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return UserDash();
                }));
              else
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Login();
                }));
            }))
        .catchError((err) {
      setState(() {
        network = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    load();
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
    return Scaffold(
        backgroundColor: Colors.black, body: Center(child: Go(context)));
  }

  Widget? Go(BuildContext context) {
    if (network == false) {
      return Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle,
              color: Colors.red[400],
              size: 40,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "There is an error with your Internet connection, Check your Internet settings and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  btntxt = "Retrying...";
                });
                load();
              },
              child: Txt(
                text: btntxt,
              ),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  backgroundColor: Color.fromRGBO(120, 56, 233, 1)),
            )
          ],
        ),
      );
    } else if (network == true) return null;
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
    return Dialog(
      backgroundColor: Colors.black,
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
