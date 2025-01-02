import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grovehubmusic/cubit/image_generation_cubit.dart';
import 'package:grovehubmusic/widgets/generate_ai/image_view.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ImageGenerationScreen extends StatelessWidget {
  const ImageGenerationScreen({super.key});

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageGenerationCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Generador de Imágenes'),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GeneratedImageViewer(
                    onTap: () {
                      final state = context.read<ImageGenerationCubit>().state;
                      if (state.url != null) {
                        _showFullScreenImage(context, state.url!);
                      }
                    },
                    width: 400,
                    height: 400,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () async {
                      await context
                          .read<ImageGenerationCubit>()
                          .textToImage('España', 'Japón', 'montañas');
                    },
                    child: const Text('Generar Nueva Imagen'),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
