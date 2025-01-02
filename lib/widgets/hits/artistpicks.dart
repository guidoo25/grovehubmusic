import 'package:flutter/material.dart';

class TarjetaArtista extends StatelessWidget {
  final String nombre;
  final String genero;
  final String ubicacion;
  final String imagenUrl;
  final List<String> albumCovers;

  const TarjetaArtista({
    super.key,
    required this.nombre,
    required this.genero,
    required this.ubicacion,
    required this.imagenUrl,
    required this.albumCovers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen principal
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.network(
              imagenUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Información del artista
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      genero.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • ',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    Text(
                      ubicacion.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Miniaturas de álbumes
          if (albumCovers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: albumCovers
                    .take(2)
                    .map(
                      (cover) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            cover,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
