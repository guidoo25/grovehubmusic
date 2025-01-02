import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;

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
  final List<ImagePrompt> images;
  final int currentIndex;

  const ImagePromptState({
    this.images = const [],
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [images, currentIndex];

  ImagePromptState copyWith({
    List<ImagePrompt>? images,
    int? currentIndex,
  }) {
    return ImagePromptState(
      images: images ?? this.images,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class ImagePromptCubit extends Cubit<ImagePromptState> {
  ImagePromptCubit() : super(const ImagePromptState());

  Future<void> generateInitialImages() async {
    if (state.images.isNotEmpty) return;

    final initialUrls = [
      'https://res.cloudinary.com/generative-ai-demos/image/upload/f_auto/q_auto/v1/ugc/replace/hjlgezzxlmjhajywdxr3',
    ];

    final images = initialUrls
        .map((url) => ImagePrompt(transformedImageUrl: url))
        .toList();

    emit(state.copyWith(images: images));
  }

  Future<String> callUrltransformed() async {
    final apiurl = "http://localhost/api_music/api/url";
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
    final imgId = await callUrltransformed();
    final currentIndex = state.currentIndex;
    if (currentIndex >= state.images.length) return;

    final updatedImages = List<ImagePrompt>.from(state.images);
    updatedImages[currentIndex] =
        updatedImages[currentIndex].copyWith(isLoading: true);
    emit(state.copyWith(images: updatedImages));

    final baseUrl =
        'https://res.cloudinary.com/generative-ai-demos/image/upload/';
    final transformedUrl =
        '${baseUrl}e_gen_replace:from_album%20cover;to_${Uri.encodeComponent(prompt)};preserve-geometry_false/f_auto/q_auto/v1/ugc/replace/$imgId';

    try {
      final response = await http.get(Uri.parse(transformedUrl));

      if (response.statusCode == 200) {
        updatedImages[currentIndex] = ImagePrompt(
          transformedImageUrl: transformedUrl,
          isLoading: false,
          isLocked: true,
        );
      } else {
        updatedImages[currentIndex] =
            updatedImages[currentIndex].copyWith(isLoading: false);
        print('Error: Received status code ${response.statusCode}');
      }
    } catch (e) {
      updatedImages[currentIndex] =
          updatedImages[currentIndex].copyWith(isLoading: false);
      print('Network error: $e');
    }

    emit(state.copyWith(images: updatedImages));
  }

  void setCurrentIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void resetState() {
    emit(const ImagePromptState());
  }
}
