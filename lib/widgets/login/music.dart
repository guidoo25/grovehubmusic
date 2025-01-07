import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: Image.asset(
        'logo2.png', // Animación de ondas de música
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
