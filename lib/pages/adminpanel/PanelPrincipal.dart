import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/admin/headeradmin.dart';
import 'package:grovehubmusic/widgets/admin/listadmin.dart';
import 'package:grovehubmusic/widgets/admin/navadmin.dart';

class PanelPrincipal extends StatelessWidget {
  const PanelPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Row(
        children: [
          const BarraLateralAdmin(),
          Expanded(
            child: Column(
              children: [
                const EncabezadoAdmin(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: const TablaUsuarios(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
