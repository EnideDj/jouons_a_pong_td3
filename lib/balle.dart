import 'package:flutter/material.dart';

class Balle extends StatelessWidget {
  static const double diametre = 50;

  const Balle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diametre,
      height: diametre,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}