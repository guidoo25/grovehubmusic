import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/bloc/auth_bloc_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.music_note),
      title: Image.asset(
        'groove.png',
        width: 200,
      ),
      actions: [
        IconButton(
          onPressed: () {
            GoRouter.of(context).go('/upload');
          },
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
          ),
          tooltip: 'Subir canción',
          iconSize: 30.0,
          padding: EdgeInsets.all(10.0),
          splashRadius: 25.0,
          color: Colors.white,
        ),
        const SizedBox(width: 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                    GoRouter.of(context).go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Salir'),
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: const BorderSide(color: Colors.white),
                  ),
                  child: const Text('Login'),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
