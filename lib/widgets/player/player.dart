import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/cubit/audio/AudioPlayerCubit.dart';
import 'package:grovehubmusic/cubit/audio/AudioPlayerState.dart';
import 'package:grovehubmusic/models/songs.dart';

class SongPlayer extends StatelessWidget {
  final Song song;

  const SongPlayer({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(song.title ?? 'Unknown Title'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple.shade900, Colors.black],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    '${Enviroments.imageurl}/${song.coverArtUrl}',
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    song.title ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    song.username ?? 'Unknown Artist',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          state.playerState?.playing ?? false
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                          size: 48,
                        ),
                        onPressed: () {
                          if (state.playerState?.playing ?? false) {
                            context.read<AudioPlayerCubit>().pause();
                          } else {
                            context.read<AudioPlayerCubit>().playSong(song);
                          }
                        },
                      ),
                    ],
                  ),
                  if (state.duration != null)
                    Slider(
                      value: state.position.inSeconds.toDouble(),
                      max: state.duration!.inSeconds.toDouble(),
                      onChanged: (value) {
                        context
                            .read<AudioPlayerCubit>()
                            .seek(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(state.position),
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          _formatDuration(state.duration ?? Duration.zero),
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
