import 'package:flutter/material.dart';
import 'package:grovehubmusic/widgets/inicio/side.dart';
import 'header.dart';

class ScaffoldWithNavigation extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavigation({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Header(),
        actions: [
          if (MediaQuery.of(context).size.width < 600)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 600
          ? const Drawer(
              child: BarraLateral(),
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 600) const BarraLateral(),
          Expanded(child: child),
        ],
      ),
    );
  }
}
