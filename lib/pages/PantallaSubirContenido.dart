// import 'package:flutter/material.dart';
// import 'package:grovehubmusic/widgets/form/formmusic.dart';

// class PantallaSubirContenido extends StatefulWidget {
//   const PantallaSubirContenido({super.key});

//   @override
//   State<PantallaSubirContenido> createState() => _PantallaSubirContenidoState();
// }

// class _PantallaSubirContenidoState extends State<PantallaSubirContenido> {
//   final IAService _iaService = IAService();
//   List<Map<String, dynamic>> _camposFormulario = [];
//   bool _cargando = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subir Contenido'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Sube tu contenido',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _generarFormulario,
//               icon: const Icon(Icons.auto_awesome),
//               label: const Text('Generar formulario con IA'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 foregroundColor: Colors.white,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               ),
//             ),
//             const SizedBox(height: 24),
//             if (_cargando)
//               const Center(child: CircularProgressIndicator())
//             else if (_camposFormulario.isNotEmpty)
//               FormularioDinamico(campos: _camposFormulario)
//             else
//               const Center(
//                 child: Text(
//                   'Haz clic en "Generar formulario con IA" para comenzar',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _generarFormulario() async {
//     setState(() {
//       _cargando = true;
//     });

//     try {
//       final campos = await _iaService.generarCamposFormulario();
//       setState(() {
//         _camposFormulario = campos;
//         _cargando = false;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error al generar el formulario: $e')),
//       );
//       setState(() {
//         _cargando = false;
//       });
//     }
//   }
// }
