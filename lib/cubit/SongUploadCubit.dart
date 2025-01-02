import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

enum UploadType { song, album }

class SongUploadState extends Equatable {
  final UploadType uploadType;
  final String? fileName;
  final Uint8List? fileBytes;
  final bool isUploading;
  final String? errorMessage;
  final bool uploadSuccess;

  const SongUploadState({
    this.uploadType = UploadType.song,
    this.fileName,
    this.fileBytes,
    this.isUploading = false,
    this.errorMessage,
    this.uploadSuccess = false,
  });

  @override
  List<Object?> get props => [
        uploadType,
        fileName,
        fileBytes,
        isUploading,
        errorMessage,
        uploadSuccess
      ];

  SongUploadState copyWith({
    UploadType? uploadType,
    String? fileName,
    Uint8List? fileBytes,
    bool? isUploading,
    String? errorMessage,
    bool? uploadSuccess,
  }) {
    return SongUploadState(
      uploadType: uploadType ?? this.uploadType,
      fileName: fileName ?? this.fileName,
      fileBytes: fileBytes ?? this.fileBytes,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: errorMessage,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
    );
  }
}

class SongUploadCubit extends Cubit<SongUploadState> {
  SongUploadCubit() : super(const SongUploadState());

  void setUploadType(UploadType type) {
    emit(state.copyWith(uploadType: type));
  }

  void setFileData({required String fileName, required Uint8List fileBytes}) {
    emit(state.copyWith(
      fileName: fileName,
      fileBytes: fileBytes,
      errorMessage: null,
      uploadSuccess: false,
    ));
  }

  Future<void> uploadFile() async {
    if (state.fileBytes == null || state.fileName == null) {
      emit(state.copyWith(errorMessage: 'No file selected'));
      return;
    }

    emit(state.copyWith(
        isUploading: true, errorMessage: null, uploadSuccess: false));

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://localhost/api_music/api/songs/upload'));

      request.files.add(http.MultipartFile.fromBytes(
        'song_file',
        state.fileBytes!,
        filename: state.fileName!,
      ));

      request.headers['Authorization'] = '$token';

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        emit(state.copyWith(isUploading: false, uploadSuccess: true));
      } else {
        emit(state.copyWith(
            isUploading: false, errorMessage: 'Upload failed: $responseBody'));
      }
    } catch (e) {
      emit(state.copyWith(
          isUploading: false, errorMessage: 'Error during upload: $e'));
    }
  }

  void reset() {
    emit(const SongUploadState());
  }
}
