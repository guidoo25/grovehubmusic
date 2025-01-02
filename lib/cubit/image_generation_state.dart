part of 'image_generation_cubit.dart';

class ImagenerationState extends Equatable {
  final Uint8List? imageData;
  final bool isLoading;
  final bool isSearching;
  final String? url;

  const ImagenerationState({
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
