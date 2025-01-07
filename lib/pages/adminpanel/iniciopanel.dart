import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/admin/tabla_usuarios.dart';
import 'package:grovehubmusic/widgets/inicio/album.dart';
import 'package:grovehubmusic/widgets/inicio/side.dart';

class Panelinitadmin extends StatelessWidget {
  const Panelinitadmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const Header(),
      body: Row(
        children: const [
          Expanded(
            child: TablaUsuarios(),
          ),
        ],
      ),
    );
  }
}
