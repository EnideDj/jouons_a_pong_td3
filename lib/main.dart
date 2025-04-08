import 'package:flutter/material.dart';
import 'page_principale.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP3 Pong',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PagePrincipale()
    );
  }
}