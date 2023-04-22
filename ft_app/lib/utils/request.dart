import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestClass {
  Future<Map<String, dynamic>> post({required String url, body}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(body),
    );

    Map<String, dynamic> json = jsonDecode(response.body);
    return json;
  }
}
