import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/pages/ForumScreen.dart';
import 'package:grovehubmusic/pages/adminpanel/PanelPrincipal.dart';
import 'package:grovehubmusic/pages/homepage.dart';
import 'package:grovehubmusic/pages/login.dart';
import 'package:grovehubmusic/pages/profile/userprofile.dart';
import 'package:grovehubmusic/pages/register.dart';
import 'package:grovehubmusic/router/loader.dart';
import 'package:grovehubmusic/widgets/admin/form_create.dart';
import 'package:grovehubmusic/widgets/admin/tabla_usuarios.dart';
import 'package:grovehubmusic/widgets/form_upload/choice_upload.dart';
import 'package:grovehubmusic/widgets/form_upload/file_updatesong.dart';
import 'package:grovehubmusic/widgets/form_upload/songinfo.dart';
import 'package:grovehubmusic/widgets/form_upload/songupload.dart';
import 'package:grovehubmusic/widgets/forum/topic_screen.dart';
import 'package:grovehubmusic/widgets/hits/hothits.dart';
import 'package:grovehubmusic/widgets/oportunidad/list_card.dart';
import 'package:grovehubmusic/widgets/player/player.dart';
import 'package:grovehubmusic/widgets/scaffor.dart';
import 'package:grovehubmusic/models/songs.dart'; // Import the Song model

GoRouter appRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: PantallaLogin(),
        ),
      ),
      GoRoute(
        path: '/registro',
        builder: (context, state) => LoadingScreen(
          future: Future.delayed(Duration(seconds: 1)),
          child: RegistrationScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/usuarios/nuevo',
        builder: (context, state) => const FormularioUsuario(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const PanelPrincipal(
          child: TablaUsuarios(),
        ),
      ),
      GoRoute(
        path: '/admin/foro',
        builder: (context, state) => PanelPrincipal(
          child: TopicScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/foropost/:topicId',
        builder: (context, state) {
          final topicId = state.pathParameters['topicId'];
          return LoadingScreen(
            future: Future.delayed(const Duration(seconds: 1)),
            child: PanelPrincipal(
              child: ForumScreen(topicId: topicId ?? 'defaultTopicId'),
            ),
          );
        },
      ),
      GoRoute(
        path: '/admin/user/:artistId',
        builder: (context, state) {
          final artistId = state.pathParameters['artistId'];
          if (artistId == null) {
            // Handle the case when artistId is null (e.g., show an error page or redirect)
            return const ErrorPage(message: 'Artist not found');
          }
          return PanelPrincipal(child: UserProfileScreen(artistId: artistId));
        },
      ),
      ShellRoute(
        builder: (context, state, child) =>
            ScaffoldWithNavigation(child: child),
        routes: [
          GoRoute(
            path: '/upload',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: SongUploadForm(),
            ),
          ),
          GoRoute(
            path: '/upload/choice',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: UploadChoiceScreen(
                songId: state.extra as String,
              ),
            ),
          ),
          GoRoute(
            path: '/update/file',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: UpdateSongFormFile(songId: state.extra as String),
            ),
          ),
          GoRoute(
            path: '/update/ia',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(const Duration(seconds: 1)),
              child: SongInfoForm(songId: state.extra as String),
            ),
          ),
          GoRoute(
            path: '/updateSong',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: SongInfoForm(songId: state.extra as String),
            ),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/hot-picks',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: const PantallaHotPicks(),
            ),
          ),
          GoRoute(
            path: '/oportunidades',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: const PantallaOportunidades(),
            ),
          ),
          GoRoute(
            path: '/foro',
            builder: (context, state) => LoadingScreen(
              future: Future.delayed(Duration(seconds: 1)),
              child: TopicScreen(),
            ),
          ),
          GoRoute(
            path: '/foropost/:topicId',
            builder: (context, state) {
              final topicId = state.pathParameters['topicId'];
              return LoadingScreen(
                future: Future.delayed(Duration(seconds: 1)),
                child: ForumScreen(topicId: topicId ?? 'defaultTopicId'),
              );
            },
          ),
          GoRoute(
            path: '/song/:title',
            builder: (context, state) {
              final song = state.extra as Song?;
              if (song == null) {
                // Handle the case when song is null (e.g., show an error page or redirect)
                return ErrorPage(message: 'Song not found');
              }
              return SongPlayer(song: song);
            },
          ),
          GoRoute(
            path: '/user/:artistId',
            builder: (context, state) {
              final artistId = state.pathParameters['artistId'];
              if (artistId == null) {
                // Handle the case when artistId is null (e.g., show an error page or redirect)
                return const ErrorPage(message: 'Artist not found');
              }
              return UserProfileScreen(artistId: artistId);
            },
          ),
        ],
      ),
    ],
  );
}

// Add this ErrorPage widget if you haven't defined it elsewhere
class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error')),
      body: Center(child: Text(message)),
    );
  }
}
