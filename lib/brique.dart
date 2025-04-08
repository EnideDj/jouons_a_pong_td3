import 'package:flutter/material.dart';

class Brique extends StatelessWidget {
  final double largeur;
  final double hauteur;
  final Color couleur;

  const Brique({
    super.key,
    required this.largeur,
    required this.hauteur,
    this.couleur = Colors.orange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: largeur,
      height: hauteur,
      decoration: BoxDecoration(
        color: couleur,
        border: Border.all(color: Colors.white),
      ),
    );
  }
}