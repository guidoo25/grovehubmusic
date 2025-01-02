import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/bloc/auth_bloc_bloc.dart';
import 'package:grovehubmusic/cubit/SongUploadCubit.dart';
import 'package:grovehubmusic/cubit/cloudinary.dart';
import 'package:grovehubmusic/router/router.dart';
import 'package:grovehubmusic/services/services_auth.dart';

void main() {
  runApp(const MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

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
        ), // Puedes agregar más BlocProviders aquí si es necesario
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
