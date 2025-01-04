import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/pages/ForumScreen.dart';
import 'package:grovehubmusic/pages/adminpanel/PanelPrincipal.dart';
import 'package:grovehubmusic/pages/homepage.dart';
import 'package:grovehubmusic/pages/login.dart';
import 'package:grovehubmusic/router/loader.dart';
import 'package:grovehubmusic/widgets/admin/form_create.dart';
import 'package:grovehubmusic/widgets/form/songinfo.dart';
import 'package:grovehubmusic/widgets/form/songupload.dart';
import 'package:grovehubmusic/widgets/hits/hothits.dart';
import 'package:grovehubmusic/widgets/oportunidad/list_card.dart';
import 'package:grovehubmusic/widgets/scaffor.dart';

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
        path: '/admin/usuarios/nuevo',
        builder: (context, state) => const FormularioUsuario(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const PanelPrincipal(),
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
                  )),
          GoRoute(
              path: '/updateSong',
              builder: (context, state) => LoadingScreen(
                  future: Future.delayed(Duration(seconds: 1)),
                  child: SongInfoForm())),
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
              child: ForumScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}
