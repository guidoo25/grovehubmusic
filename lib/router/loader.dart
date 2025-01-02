import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  final Future<void> future;
  final Widget child;

  const LoadingScreen({required this.future, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return child;
        } else {
          return Center(
            child: Opacity(
              opacity: 0.7, // Ajusta la opacidad según sea necesario
              child: SizedBox(
                width: 250, // Ajusta el tamaño según sea necesario
                height: 300,
                child: Lottie.asset('assets/disco.json'),
              ),
            ),
          );
        }
      },
    );
  }
}
