import 'dart:convert';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/authmodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl =
      '${Enviroments.apiUrl}'; // Replace with your actual API URL

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

  Future<Map<String, dynamic>> updateSongInfo({
    required String songId,
    required String title,
    required String description,
    required String genre,
    String? coverArtPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/songs/update'),
    );

    request.fields['song_id'] = songId;
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['genre'] = genre;

    if (coverArtPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('cover_art', coverArtPath));
    }

    request.headers['Authorization'] = 'Bearer $token';

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseBody);

    if (response.statusCode == 200) {
      return jsonResponse;
    } else {
      throw Exception('Failed to update song info: ${jsonResponse['message']}');
    }
  }
}
