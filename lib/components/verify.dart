// Checks before the component ran
import 'package:http/http.dart' as http;
import 'package:xor/components/error_toast.dart';

Uri url = Uri.parse("http://192.168.43.71:5000/dashboard");
Future<bool> verify(String token) async {
  try {
    var response = await http.get(url, headers: {"x-token": token});
    if (response.statusCode == 200)
      return true; // Authenticated
    else
      return false;
  } catch (e) {
    print(e);
    Error("There seems to an error");
    return false;
  }
// Not authenticated
}