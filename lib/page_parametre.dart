import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageParametre extends StatefulWidget {
  const PageParametre({super.key});

  @override
  State<PageParametre> createState() => _PageParametreState();
}

class _PageParametreState extends State<PageParametre> {
  int meilleurScore = 0;

  @override
  void initState() {
    super.initState();
    chargerMeilleurScore();
  }

  Future<void> chargerMeilleurScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      meilleurScore = prefs.getInt('meilleur_score') ?? 0;
    });
  }

  Future<void> resetMeilleurScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('meilleur_score');
    setState(() {
      meilleurScore = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meilleur score enregistré :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '$meilleurScore',
              style: const TextStyle(fontSize: 24, color: Colors.blueAccent),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: resetMeilleurScore,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Réinitialiser le meilleur score"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
