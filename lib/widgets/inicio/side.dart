import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BarraLateral extends StatelessWidget {
  const BarraLateral({super.key});

  @override
  Widget build(BuildContext context) {
    final String rutaActual = GoRouterState.of(context).matchedLocation;

    return Container(
      width: 240,
      color: const Color(0xFF121212),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _construirElementoNav(
            context,
            Icons.home,
            'Inicio',
            '/',
            rutaActual == '/',
          ),
          _construirElementoNav(
            context,
            Icons.search,
            'Buscar',
            '/explorar',
            rutaActual == '/explorar',
          ),
          _construirElementoNav(
            context,
            Icons.forum_outlined,
            'Foro',
            '/foro',
            rutaActual == '/foro',
          ),
          _construirElementoNav(
            context,
            Icons.whatshot,
            'Hot Picks',
            '/hot-picks',
            rutaActual == '/hot-picks',
          ),
          _construirElementoNav(
            context,
            Icons.work_outline,
            'Oportunidades',
            '/oportunidades',
            rutaActual == '/oportunidades',
          ),
          const SizedBox(height: 32),
          _construirElementoNav(
            context,
            Icons.add_box,
            'Crear lista',
            '/crear-lista',
            false,
          ),
          _construirElementoNav(
            context,
            Icons.favorite,
            'Canciones que te gustan',
            '/me-gusta',
            rutaActual == '/me-gusta',
          ),
          const Divider(height: 32, color: Colors.grey),
          Expanded(
            child: ListView(
              children: [
                _construirElementoLista('Lista de reproducción 1'),
                _construirElementoLista('Lista de reproducción 2'),
                _construirElementoLista('Lista de reproducción 3'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirElementoNav(
    BuildContext context,
    IconData icono,
    String etiqueta,
    String ruta,
    bool estaSeleccionado,
  ) {
    return ListTile(
      leading: Icon(
        icono,
        color: estaSeleccionado ? const Color(0xFF1DB954) : Colors.grey,
      ),
      title: Text(
        etiqueta,
        style: TextStyle(
          color: estaSeleccionado ? Colors.white : Colors.grey,
          fontWeight: estaSeleccionado ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: estaSeleccionado,
      onTap: () => context.go(ruta),
    );
  }

  Widget _construirElementoLista(String nombre) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        nombre,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
