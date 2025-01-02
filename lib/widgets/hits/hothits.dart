import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/hits/artistpicks.dart';

class PantallaHotPicks extends StatelessWidget {
  const PantallaHotPicks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado de la sección
        Container(
          padding: const EdgeInsets.all(16),
          color: const Color(0xFF181818),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hot Picks',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '24 Dic 2024 - 31 Dic 2024',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildFilterButton('Archivo'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Género'),
                ],
              ),
            ],
          ),
        ),
        // Lista de artistas
        Expanded(
          child: ListView.builder(
            itemCount: artistas.length,
            itemBuilder: (context, index) {
              final artista = artistas[index];
              return TarjetaArtista(
                nombre: artista['nombre']!,
                genero: artista['genero']!,
                ubicacion: artista['ubicacion']!,
                imagenUrl: artista['imagenUrl']!,
                albumCovers: List<String>.from(artista['albumCovers']!),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String texto) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Row(
        children: [
          Text(texto),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    );
  }
}

// Datos de ejemplo
final List<Map<String, dynamic>> artistas = [
  {
    'nombre': 'Kingscott',
    'genero': 'Rock',
    'ubicacion': 'Daytona Beach, FL, US',
    'imagenUrl': 'https://picsum.photos/seed/1/800/400',
    'albumCovers': [
      'https://picsum.photos/seed/11/200/200',
      'https://picsum.photos/seed/12/200/200',
    ],
  },
  {
    'nombre': 'Seavino',
    'genero': 'Pop',
    'ubicacion': 'Edinburgh, UK',
    'imagenUrl': 'https://picsum.photos/seed/2/800/400',
    'albumCovers': [
      'https://picsum.photos/seed/21/200/200',
      'https://picsum.photos/seed/22/200/200',
    ],
  },
  {
    'nombre': 'Danae & The Gold Sound',
    'genero': 'R&B/Soul',
    'ubicacion': 'Altamonte Springs, FL, US',
    'imagenUrl': 'https://picsum.photos/seed/3/800/400',
    'albumCovers': [
      'https://picsum.photos/seed/31/200/200',
      'https://picsum.photos/seed/32/200/200',
    ],
  },
];
