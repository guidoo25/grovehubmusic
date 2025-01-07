import 'dart:convert';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForumService {
  final String baseUrl = '${Enviroments.apiUrl}';

  Future<Map<String, dynamic>> getPosts(
      {int page = 1, int limit = 10, String? topicId}) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (topicId != null) 'topic_id': topicId.toString(),
    };

    final uri =
        Uri.parse('$baseUrl/posts').replace(queryParameters: queryParams);

    final response = await http.get(uri);
    return _handleResponse2(response);
  }

  Map<String, dynamic> _handleResponse2(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> inactivePost(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/posts/inactive'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'post_id': postId}),
    );
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

  Future<Map<String, dynamic>> getComments(String postId,
      {int page = 1, int limit = 10}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/posts/comments'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'postId': postId,
        'page': page,
        'limit': limit,
      }),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> createComment(
      String postId, String content) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/comments'),
      body: json.encode({'post_id': postId, 'content': content}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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

  Future<Map<String, dynamic>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/foro/topics'));
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
