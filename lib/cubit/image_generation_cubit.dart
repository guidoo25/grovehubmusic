import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

part 'image_generation_state.dart';

class ImageGenerationState extends Equatable {
  final Uint8List? imageData;
  final bool isLoading;
  final bool isSearching;
  final String? url;

  const ImageGenerationState({
    this.imageData,
    this.isLoading = false,
    this.isSearching = false,
    this.url,
  });

  ImageGenerationState copyWith({
    Uint8List? imageData,
    bool? isLoading,
    bool? isSearching,
    String? url,
  }) {
    return ImageGenerationState(
      imageData: imageData ?? this.imageData,
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [imageData, isLoading, isSearching, url];
}

class ImageGenerationCubit extends Cubit<ImageGenerationState> {
  ImageGenerationCubit() : super(const ImageGenerationState());

  final cloudinary = CloudinaryPublic('dfha4roeg', 'onghmgzh', cache: false);

  Future<String?> textToImage(
      String pais1, String pais2, String paisaje) async {
    String baseprompt =
        "Create a realistic art piece of a pole flag that mixed elements from the countries $pais1 and $pais2. The flag should be set against a backdrop of $paisaje landscapes, showcasing the interior style and natural beauty of these regions.";
    String engineId = "stable-diffusion-v1-6";
    String apiHost = 'https://api.stability.ai';
    String apiKey = 'sk-SISMU3GHhmv27DBV6NeujZ9gqjIaffwDPxANS0WvEaXHLVJo';
    debugPrint(baseprompt);

    emit(state.copyWith(isLoading: true, isSearching: true));

    try {
      final response = await http.post(
        Uri.parse('$apiHost/v1/generation/$engineId/text-to-image'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "image/png",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "text_prompts": [
            {"text": baseprompt, "weight": 1}
          ],
          "cfg_scale": 7,
          "height": 1024,
          "width": 1024,
          "samples": 1,
          "steps": 30,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint(response.statusCode.toString());
        Uint8List imageData = response.bodyBytes;

        CloudinaryResponse uploadResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(
            imageData,
            identifier: 'generated_image.jpg',
            resourceType: CloudinaryResourceType.Image,
          ),
        );

        debugPrint('Imagen subida a Cloudinary: ${uploadResponse.secureUrl}');
        emit(state.copyWith(
          imageData: imageData,
          isLoading: false,
          isSearching: false,
          url: uploadResponse.secureUrl,
        ));
        return uploadResponse.secureUrl;
      } else {
        throw Exception("Error en la generación de imagen");
      }
    } catch (e) {
      debugPrint("Error generando o subiendo imagen: $e");
      emit(state.copyWith(isLoading: false, isSearching: false));
      return null;
    }
  }
}
