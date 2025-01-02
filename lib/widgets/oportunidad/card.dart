import 'package:flutter/material.dart';

class TarjetaOportunidad extends StatelessWidget {
  final String titulo;
  final String logoUrl;
  final String categoria;
  final String ubicacion;
  final bool esRecomendado;
  final String tiempoRestante;
  final bool requiereMembresia;

  const TarjetaOportunidad({
    super.key,
    required this.titulo,
    required this.logoUrl,
    required this.categoria,
    required this.ubicacion,
    required this.esRecomendado,
    required this.tiempoRestante,
    required this.requiereMembresia,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFF282828),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                logoUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (esRecomendado)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'RECOMENDADO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (requiereMembresia)
                        const Text(
                          'Gratis con Membresía',
                          style: TextStyle(color: Colors.grey),
                        ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        ubicacion,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    categoria,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Botón y tiempo restante
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Aplicar Ahora'),
                ),
                const SizedBox(height: 8),
                Text(
                  '$tiempoRestante restantes',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
