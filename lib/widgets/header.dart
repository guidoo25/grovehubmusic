import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.music_note),
      title: const Text('RKHM'),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
        ElevatedButton(
          onPressed: () {
            GoRouter.of(context).go('/upload');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          child: const Text('Upload Song/Album'),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ElevatedButton(
            onPressed: () {
              GoRouter.of(context).go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Colors.white),
            ),
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }
}
