import 'dart:convert';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/authmodel.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'dart:async'; // Agregar esta importación

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
      throw Exception('Fallo el inicio de sesión');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers(
      {Map<String, dynamic>? filters}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/admin/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'filters': filters}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success'] == true && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Failed to load users');
      }
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> deleteUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/admin/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'user_id': userId,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> register(String email, String password,
      String username, String fullName, String role) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'email': email,
        'password': password,
        'username': username,
        'full_name': fullName,
        'role': role,
      }),
    );
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform operation: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateSongInfo({
    required String songId,
    required String title,
    required String description,
    required String genre,
    required String aiGeneratedImageUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    try {
      // Download the AI-generated image
      final imageResponse = await http.get(Uri.parse(aiGeneratedImageUrl));
      if (imageResponse.statusCode != 200) {
        throw Exception('Failed to download AI-generated image');
      }

      // Convert image to Blob
      final blob = html.Blob([imageResponse.bodyBytes]);

      // Create FormData
      final formData = html.FormData();
      formData.append('song_id', songId);
      formData.append('title', title);
      formData.append('description', description);
      formData.append('genre', genre);
      formData.appendBlob('cover_art', blob, 'cover_art.jpg');

      // Send request using XMLHttpRequest
      final request = html.HttpRequest();
      request.open('POST', '$baseUrl/songs/update');
      request.setRequestHeader('Authorization', 'Bearer $token');

      final completer = Completer<Map<String, dynamic>>();

      request.onLoadEnd.listen((event) {
        if (request.status == 200) {
          completer.complete(json.decode(request.responseText ?? ''));
        } else {
          completer
              .completeError('Failed to update song: ${request.responseText}');
        }
      });

      request.onError.listen((error) {
        completer.completeError('Error uploading: $error');
      });

      request.send(formData);

      return await completer.future;
    } catch (e) {
      throw Exception('Failed to update song info: $e');
    }
  }

  Future<PaginatedResponse<Song>> getSongs({
    int page = 1,
    int perPage = 10,
    Map<String, dynamic>? filters,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final queryParams = {
      'page': page.toString(),
      'per_page': perPage.toString(),
      ...?filters,
    };

    final uri =
        Uri.parse('$baseUrl/songs').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        return PaginatedResponse.fromJson(
          jsonResponse,
          (json) => Song.fromJson(json),
        );
      } else {
        throw Exception('Failed to load songs');
      }
    } else {
      throw Exception('Failed to load songs');
    }
  }
}
