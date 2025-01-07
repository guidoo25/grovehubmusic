import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/bloc/auth_bloc_bloc.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:grovehubmusic/cubit/SongUploadCubit.dart';
import 'package:grovehubmusic/cubit/Usertlistt.dart';
import 'package:grovehubmusic/cubit/audio/AudioPlayerCubit.dart';
import 'package:grovehubmusic/cubit/cloudinary.dart';
import 'package:grovehubmusic/router/router.dart';
import 'package:grovehubmusic/services/services_auth.dart';

void main() async {
  await Enviroments().initEnviroments();

  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService authService = ApiService();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authService),
        ),
        BlocProvider<SongUploadCubit>(
          create: (context) => SongUploadCubit(),
        ),
        BlocProvider<ImagePromptCubit>(
          create: (context) => ImagePromptCubit(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => UserCubit(authService),
        ),
        BlocProvider(create: (context) => AudioPlayerCubit()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter(),
        title: 'Music App',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF181818),
            elevation: 0,
          ),
          colorScheme: const ColorScheme.dark(
            primary: Colors.blue,
            secondary: Colors.blueAccent,
            surface: Color(0xFF181818),
            background: Color(0xFF121212),
          ),
        ),
      ),
    );
  }
}
