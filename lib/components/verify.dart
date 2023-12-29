// Checks before the component ran
import 'package:http/http.dart' as http;

Uri url = Uri.parse("http://192.168.43.71:5000/dashboard");
Future<bool> verify(String token) async {
  var response = await http.get(url, headers: {"x-token": token});
  if (response.statusCode == 200)
    return true; // Authenticated
  else
    return false; // Not authenticated
}
