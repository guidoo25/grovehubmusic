import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/admin/headeradmin.dart';
import 'package:grovehubmusic/widgets/admin/tabla_usuarios.dart';
import 'package:grovehubmusic/widgets/admin/navadmin.dart';

class PanelPrincipal extends StatelessWidget {
  final Widget child;
  const PanelPrincipal({
    super.key,
    required this.child,
  });

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
                    child: child,
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
