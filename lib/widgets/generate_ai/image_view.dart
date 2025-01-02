import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:grovehubmusic/cubit/image_generation_cubit.dart';

class GeneratedImageViewer extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const GeneratedImageViewer({
    super.key,
    this.onTap,
    this.width = 300,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageGenerationCubit, ImageGenerationState>(
      builder: (context, state) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: state.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Generando imagen...',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : state.url != null
                    ? GestureDetector(
                        onTap: onTap,
                        child: Hero(
                          tag: state.url!,
                          child: CachedNetworkImage(
                            imageUrl: state.url!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Error al cargar la imagen',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No hay imagen generada',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
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
}