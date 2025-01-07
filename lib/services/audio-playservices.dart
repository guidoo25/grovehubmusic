import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/models/songs.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  Duration? get duration => _audioPlayer.duration;

  Future<void> playSong(Song song) async {
    if (_currentSong?.id != song.id) {
      _currentSong = song;
      final songUrl = '${Enviroments.musicurl}/uploads/${song.filePath}';
      await _audioPlayer.setUrl(songUrl);
    }
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  String getImageUrl(String coverArtUrl) {
    if (coverArtUrl.startsWith('http')) {
      return coverArtUrl;
    }
    return '${Enviroments.apiUrl}/uploads/covers/$coverArtUrl';
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
  }

  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  void dispose() {
    _audioPlayer.dispose();
  }
}
