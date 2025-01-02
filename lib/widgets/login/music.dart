import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      'https://assets2.lottiefiles.com/packages/lf20_GkXqzWYd4O.json', // Animación de ondas de música
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}
