import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/inicio/album.dart';
import 'package:grovehubmusic/widgets/inicio/side.dart';
import '../widgets/header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const Header(),
      body: Row(
        children: const [
          Expanded(
            child: AlbumGrid(),
          ),
        ],
      ),
    );
  }
}
