import 'package:equatable/equatable.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerState extends Equatable {
  final Song? currentSong;
  final Duration position;
  final Duration? duration;
  final PlayerState? playerState;
  final bool isLoading;

  const AudioPlayerState({
    this.currentSong,
    this.position = Duration.zero,
    this.duration,
    this.playerState,
    this.isLoading = false,
  });

  @override
  List<Object?> get props =>
      [currentSong, position, duration, playerState, isLoading];

  AudioPlayerState copyWith({
    Song? currentSong,
    Duration? position,
    Duration? duration,
    PlayerState? playerState,
    bool? isLoading,
  }) {
    return AudioPlayerState(
      currentSong: currentSong ?? this.currentSong,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      playerState: playerState ?? this.playerState,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
