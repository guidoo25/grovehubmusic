import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImagePrompt extends Equatable {
  final String transformedImageUrl;
  final bool isLoading;
  final bool isLocked;

  const ImagePrompt({
    required this.transformedImageUrl,
    this.isLoading = false,
    this.isLocked = false,
  });

  @override
  List<Object?> get props => [transformedImageUrl, isLoading, isLocked];

  ImagePrompt copyWith({
    String? transformedImageUrl,
    bool? isLoading,
    bool? isLocked,
  }) {
    return ImagePrompt(
      transformedImageUrl: transformedImageUrl ?? this.transformedImageUrl,
      isLoading: isLoading ?? this.isLoading,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class ImagePromptState extends Equatable {
  final String? imageUrl;
  final bool isLoading;

  const ImagePromptState({
    this.imageUrl,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [imageUrl, isLoading];

  ImagePromptState copyWith({
    String? imageUrl,
    bool? isLoading,
  }) {
    return ImagePromptState(
      imageUrl: imageUrl,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ImagePromptCubit extends Cubit<ImagePromptState> {
  ImagePromptCubit() : super(const ImagePromptState());

  Future<String> callUrltransformed() async {
    final apiurl = "${Enviroments.apiUrl}/url";
    final response = await http.get(Uri.parse(apiurl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        return jsonResponse['data'];
      } else {
        throw Exception('Failed to load album cover');
      }
    } else {
      throw Exception('Failed to load album cover');
    }
  }

  Future<void> setPromptForImage(String prompt) async {
    emit(state.copyWith(isLoading: true));

    try {
      final imgId = await callUrltransformed();
      final baseUrl =
          'https://res.cloudinary.com/generative-ai-demos/image/upload/';
      final transformedUrl =
          '${baseUrl}e_gen_replace:from_album%20cover;to_${Uri.encodeComponent(prompt)};preserve-geometry_false/f_auto/q_auto/v1/ugc/replace/$imgId';

      final response = await http.get(Uri.parse(transformedUrl));

      if (response.statusCode == 200) {
        // Add timestamp to force image refresh
        emit(state.copyWith(
          imageUrl:
              '$transformedUrl?t=${DateTime.now().millisecondsSinceEpoch}',
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
        print('Error: Received status code ${response.statusCode}');
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print('Network error: $e');
    }
  }

  Future<void> uploadImageToServer({
    required String songId,
    required String title,
    required String description,
    required String genre,
  }) async {
    if (state.imageUrl == null) {
      print('No image to upload');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      // Download the image as a Blob
      final response = await http.get(Uri.parse(state.imageUrl!));
      if (response.statusCode != 200) {
        throw Exception('Failed to download image');
      }

      final blob = html.Blob([response.bodyBytes]);

      // Create a FormData object
      final formData = html.FormData();
      formData.append('song_id', songId);
      formData.append('title', title);
      formData.append('description', description);
      formData.append('genre', genre);
      formData.appendBlob('cover_art', blob, 'cover_art.jpg');

      // Create an XMLHttpRequest to upload the image
      final request = html.HttpRequest();
      request
        ..open('POST', '${Enviroments.apiUrl}/songs/update')
        ..setRequestHeader('Authorization', 'Bearer $token')
        ..onLoadEnd.listen((event) {
          if (request.status == 200) {
            print('Image uploaded successfully');
          } else {
            print('Failed to upload image: ${request.responseText}');
          }
        })
        ..send(formData);
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  void resetState() {
    emit(const ImagePromptState());
  }
}
