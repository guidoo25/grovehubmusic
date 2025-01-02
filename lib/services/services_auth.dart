import 'dart:convert';
import 'package:grovehubmusic/models/authmodel.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      'http://localhost/api_music/api'; // Replace with your actual API URL

  Future<AuthResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );
    final responseJson = AuthResponse.fromJson(json.decode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception('Failed to login');
    }
  }
}
