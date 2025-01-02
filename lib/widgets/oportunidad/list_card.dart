import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/oportunidad/card.dart';

class PantallaOportunidades extends StatefulWidget {
  const PantallaOportunidades({super.key});

  @override
  State<PantallaOportunidades> createState() => _PantallaOportunidadesState();
}

class _PantallaOportunidadesState extends State<PantallaOportunidades> {
  final TextEditingController _busquedaController = TextEditingController();
  String _tipoSeleccionado = 'Todos';
  String _distanciaSeleccionada = 'Global';

  final List<String> _tiposOportunidad = [
    'Todos',
    'En vivo',
    'Publicación',
    'Radio',
    'Licencias',
    'Conferencia',
    'Sello Discográfico',
    'Servicios Profesionales',
    'Otros',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Encabezado
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Oportunidades',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Cómo funcionan las oportunidades?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        // Barra de búsqueda y filtros
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Filtro de tipo
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _tipoSeleccionado,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Oportunidad',
                    border: OutlineInputBorder(),
                  ),
                  items: _tiposOportunidad
                      .map((tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(tipo),
                          ))
                      .toList(),
                  onChanged: (valor) {
                    setState(() {
                      _tipoSeleccionado = valor!;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              // Barra de búsqueda
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _busquedaController,
                  decoration: const InputDecoration(
                    hintText: 'Buscar oportunidades...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Filtro de distancia
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _distanciaSeleccionada,
                  decoration: const InputDecoration(
                    labelText: 'Distancia',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Global', child: Text('Global')),
                    DropdownMenuItem(value: 'Local', child: Text('Local')),
                  ],
                  onChanged: (valor) {
                    setState(() {
                      _distanciaSeleccionada = valor!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Lista de oportunidades
        Expanded(
          child: ListView(
            children: [
              TarjetaOportunidad(
                titulo:
                    'Envía tu música para ser Artista Destacado del Mes en Sonic Coast Radio',
                logoUrl: 'https://picsum.photos/seed/1/200',
                categoria: 'Radio',
                ubicacion: 'Online',
                esRecomendado: true,
                tiempoRestante: '2 días',
                requiereMembresia: true,
              ),
              TarjetaOportunidad(
                titulo:
                    'GRXTESQUE Records está buscando nuevos artistas de Hip Hop',
                logoUrl: 'https://picsum.photos/seed/2/200',
                categoria: 'Sello Discográfico',
                ubicacion: 'Online',
                esRecomendado: true,
                tiempoRestante: '7 días',
                requiereMembresia: true,
              ),
              TarjetaOportunidad(
                titulo: 'We Are Triumphant A&R Research',
                logoUrl: 'https://picsum.photos/seed/3/200',
                categoria: 'Sello Discográfico',
                ubicacion: 'Online',
                esRecomendado: true,
                tiempoRestante: '7 días',
                requiereMembresia: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
