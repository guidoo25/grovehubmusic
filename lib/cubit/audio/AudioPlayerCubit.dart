import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grovehubmusic/cubit/audio/AudioPlayerState.dart';
import 'package:just_audio/just_audio.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayerCubit() : super(const AudioPlayerState()) {
    _init();
  }

  void _init() {
    _audioPlayer.playerStateStream.listen((playerState) {
      emit(state.copyWith(playerState: playerState));
    });

    _audioPlayer.positionStream.listen((position) {
      emit(state.copyWith(position: position));
    });

    _audioPlayer.durationStream.listen((duration) {
      emit(state.copyWith(duration: duration));
    });
  }

  Future<void> playSong(Song song) async {
    if (state.currentSong?.id != song.id) {
      emit(state.copyWith(isLoading: true, currentSong: song));
      final songUrl = '${Enviroments.musicurl}/uploads/${song.filePath}';
      await _audioPlayer.setUrl(songUrl);
      _updatePlayCount(song.id);
    }
    await _audioPlayer.play();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _updatePlayCount(String songId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';

      final response = await http.post(
        Uri.parse('${Enviroments.apiUrl}/songs/count'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'songId': songId,
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to update play count: ${response.body}');
      }
    } catch (e) {
      print('Error updating play count: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  @override
  Future<void> close() {
    _audioPlayer.dispose();
    return super.close();
  }

  String getImageUrl(String coverArtUrl) {
    if (coverArtUrl.startsWith('http')) return coverArtUrl;
    return '${Enviroments.apiUrl}/uploads/covers/$coverArtUrl';
  }
}
