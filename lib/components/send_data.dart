// Used to send data to the server
import "package:http/http.dart" as http;
import 'package:xor/components/json_conv.dart';
import "package:xor/components/config.dart";

var url = URL;
Future<Map> send(Map body, String method, String route) async {
  switch (method) {
    case "POST":
      return post(body, route);
    case "GET":
      return get(body, route);
    default:
      return {};
  }
}

Future<Map> chat(Map data, String route, String token) async {
  try {
    var response = await http.post(Uri.parse("$url$route"),
        headers: {"x-token": token}, body: data);
    if (response.statusCode == 200) {
      return {"status": 200, "message": json(response.body)["message"]};
    } else {
      return {
        "status": response.statusCode,
        "message": json(response.body)["message"]
      };
    }
  } catch (err) {
    // Network connection error
    print(err);
    return {"status": 0};
  }
}

Future<Map> sec_post(Map data, String route, String token) async {
  // For post request with token
  try {
    var response = await http.post(Uri.parse("$url$route"),
        headers: {"x-token": token}, body: data);
    if (response.statusCode == 200) {
      return {
        "status": 200,
        "token": json(response.body)["token"],
        "message": json(response.body)["message"]
      };
    } else {
      return {
        "status": response.statusCode,
        "message": json(response.body)["message"]
      };
    }
  } catch (err) {
    // Network connection error
    return {"status": 0};
  }
}

Future<Map> post(Map data, String route) async {
  // For post request
  try {
    var response = await http.post(Uri.parse("$url$route"), body: data);
    if (response.statusCode == 200) {
      return {
        "status": 200,
        "token": json(response.body)["token"],
        "message": json(response.body)["message"]
      };
    } else {
      return {
        "status": response.statusCode,
        "message": json(response.body)["message"]
      };
    }
  } catch (err) {
    // Network connection error
    return {"status": 0};
  }
}

Future<Map> get(Map body, String route) async {
  // for get requests
  try {
    var response = await http
        .get(Uri.parse("$url$route"), headers: {"x-token": body["token"]});
    if (response.statusCode == 200) {
      return {"status": 200, "message": json(response.body)["message"]};
    } else
      return {
        "status": response.statusCode,
        "message": json(response.body)["message"]
      };
  } catch (e) {
    return {"status": 0};
  }
}

void delete() {
  // for delete requests
}
void socket() {
  // for socket operations
}
