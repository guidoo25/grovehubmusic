import 'dart:convert';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForumService {
  final String baseUrl = '${Enviroments.apiUrl}';

  Future<Map<String, dynamic>> getPosts({int page = 1}) async {
    final response = await http.get(Uri.parse('$baseUrl/posts?page=$page'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createPost(String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      body: json.encode({'content': content}),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getComments(String postId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/posts/$postId/comments'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createComment(
      String postId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      body: json.encode({'post_id': postId, 'content': content}),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> updateComment(
      String commentId, String content) async {
    final response = await http.put(
      Uri.parse('$baseUrl/comments/$commentId'),
      body: json.encode({'content': content}),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteComment(String commentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/comments/$commentId'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createLike(String postId,
      {String? commentId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final body =
        commentId != null ? {'comment_id': commentId} : {'post_id': postId};
    final response = await http.post(
      Uri.parse('$baseUrl/likes'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> deleteLike(String likeId) async {
    final response = await http.delete(Uri.parse('$baseUrl/likes/$likeId'));
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to perform operation: ${response.body}');
    }
  }
}
