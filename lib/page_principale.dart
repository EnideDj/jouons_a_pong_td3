import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'balle.dart';
import 'batte.dart';
import 'brique.dart';
import 'page_parametre.dart';

enum Direction { haut, bas, gauche, droite }

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> with SingleTickerProviderStateMixin {
  late AnimationController controleur;
  late Animation animation;

  double largeur = 400;
  double hauteur = 400;
  double posX = 0;
  double posY = 0;
  double largeurBatte = 0;
  double hauteurBatte = 0;
  double positionBatte = 0;
  double increment = 1.5;

  Direction hDir = Direction.droite;
  Direction vDir = Direction.bas;

  int score = 0;
  int meilleurScore = 0;
  int niveau = 1;
  final int niveauMax = 10;

  double randX = 1;
  double randY = 1;

  bool partieTerminee = false;

  List<Map<String, dynamic>> briques = [];
  double largeurBrique = 80;
  double hauteurBrique = 30;

  double nombreAleatoire() {
    final random = Random();
    return (random.nextInt(50) + 75) / 100;
  }

  Future<void> chargerMeilleurScore() async {
    final prefs = await SharedPreferences.getInstance();
    meilleurScore = prefs.getInt('meilleur_score') ?? 0;
  }

  Future<void> mettreAJourMeilleurScore() async {
    final prefs = await SharedPreferences.getInstance();
    if (score > meilleurScore) {
      meilleurScore = score;
      await prefs.setInt('meilleur_score', score);
    }
  }

  void initialiserBriques() {
    briques.clear();
    int nbIndestructibles = niveau - 1;
    int lignes = 2 + niveau;

    List<Offset> candidates = [];

    for (int l = 0; l < lignes; l++) {
      double y = 50 + (l * 40);
      for (double x = 10; x < largeur - largeurBrique; x += largeurBrique + 10) {
        candidates.add(Offset(x, y));
      }
    }

    candidates.shuffle();

    for (int i = 0; i < candidates.length; i++) {
      bool indestructible = i < nbIndestructibles;
      briques.add({
        'offset': candidates[i],
        'indestructible': indestructible,
      });
    }

    largeurBatte = largeur / (2 + (niveauMax - niveau) * 0.4);
    increment = 1.5 + (niveau * 0.2);
  }

  @override
  void initState() {
    super.initState();
    chargerMeilleurScore();
    initialiserBriques();
    posX = 0;
    posY = 0;

    controleur = AnimationController(
      duration: const Duration(minutes: 10000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controleur)
      ..addListener(() {
        safeSetState(() {
          double nextX = hDir == Direction.droite
              ? posX + (increment * randX)
              : posX - (increment * randX);

          double nextY = vDir == Direction.bas
              ? posY + (increment * randY)
              : posY - (increment * randY);

          posX = nextX.clamp(0, largeur - Balle.diametre);
          posY = nextY.clamp(0, hauteur - Balle.diametre);
        });

        testerBordures();
      });

    controleur.forward();
  }

  @override
  void dispose() {
    controleur.dispose();
    super.dispose();
  }

  void safeSetState(Function function) {
    if (mounted && controleur.isAnimating && !partieTerminee) {
      setState(() {
        function();
      });
    }
  }

  void testerBordures() {
    if (posX <= 0) {
      hDir = Direction.droite;
      randX = nombreAleatoire();
    }
    if (posX >= largeur - Balle.diametre) {
      hDir = Direction.gauche;
      randX = nombreAleatoire();
    }
    if (posY <= 0) {
      vDir = Direction.bas;
      randY = nombreAleatoire();
    }

    for (final brique in briques) {
      Offset offset = brique['offset'];
      bool collision = posX + Balle.diametre >= offset.dx &&
          posX <= offset.dx + largeurBrique &&
          posY + Balle.diametre >= offset.dy &&
          posY <= offset.dy + hauteurBrique;

      if (collision) {
        double centreBalleX = posX + Balle.diametre / 2;
        double centreBalleY = posY + Balle.diametre / 2;
        double centreBriqueX = offset.dx + largeurBrique / 2;
        double centreBriqueY = offset.dy + hauteurBrique / 2;

        double dx = (centreBalleX - centreBriqueX).abs();
        double dy = (centreBalleY - centreBriqueY).abs();

        if (dx > dy) {
          hDir = (hDir == Direction.gauche) ? Direction.droite : Direction.gauche;
          randX = nombreAleatoire();
        } else {
          vDir = (vDir == Direction.haut) ? Direction.bas : Direction.haut;
          randY = nombreAleatoire();
        }

        if (brique['indestructible']) {
          posX += hDir == Direction.droite ? 2 : -2;
          posY += vDir == Direction.bas ? 2 : -2;
        } else {
          briques.remove(brique);
          score += 5;
        }
        break;
      }
    }

    if (briques.where((b) => !b['indestructible']).isEmpty) {
      if (niveau < niveauMax) {
        setState(() {
          niveau++;
          posX = 0;
          posY = 0;
        });
        initialiserBriques();
      } else {
        controleur.stop();
        setState(() {
          partieTerminee = true;
        });
        afficherVictoire(context);
      }
    }

    double zoneRebond = hauteur - hauteurBatte - Balle.diametre;

    if (posY + Balle.diametre >= zoneRebond && posY + Balle.diametre <= hauteur) {
      bool balleSurBatte = (posX + Balle.diametre >= positionBatte) &&
          (posX <= positionBatte + largeurBatte);

      if (balleSurBatte) {
        vDir = Direction.haut;
        randY = nombreAleatoire();
        score++;
      } else if (posY + Balle.diametre >= hauteur - 1) {
        controleur.stop();
        mettreAJourMeilleurScore();
        setState(() {
          partieTerminee = true;
        });
        afficherMessage(context);
      }
    }

    posX = posX.clamp(0, largeur - Balle.diametre);
    posY = posY.clamp(0, hauteur - Balle.diametre);
  }

  void afficherMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Perdu !"),
          content: const Text("Tu veux rejouer ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                  niveau = 1;
                  hDir = Direction.droite;
                  vDir = Direction.bas;
                  randX = 1;
                  randY = 1;
                  partieTerminee = false;
                  initialiserBriques();
                });
                controleur.repeat();
              },
              child: const Text("OUI"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("NON"),
            ),
          ],
        );
      },
    );
  }

  void afficherVictoire(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Bravo !"),
          content: const Text("Tu as terminé tous les niveaux !"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                  niveau = 1;
                  partieTerminee = false;
                  initialiserBriques();
                });
                controleur.repeat();
              },
              child: const Text("Rejouer"),
            )
          ],
        );
      },
    );
  }

  void deplacerBatte(DragUpdateDetails maj, BuildContext context) {
    safeSetState(() {
      positionBatte += maj.delta.dx;
      if (positionBatte < 0) positionBatte = 0;
      if (positionBatte > largeur - largeurBatte) {
        positionBatte = largeur - largeurBatte;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        hauteur = constraints.maxHeight;
        largeur = constraints.maxWidth;
        hauteurBatte = hauteur / 20;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Jeu Pong'),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  controleur.stop();
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PageParametre()),
                  );

                  await chargerMeilleurScore();
                  if (!partieTerminee) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Reprendre la partie ?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              controleur.repeat();
                            },
                            child: const Text("Oui"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                posX = 0;
                                posY = 0;
                                score = 0;
                                niveau = 1;
                                partieTerminee = false;
                                initialiserBriques();
                              });
                              controleur.repeat();
                            },
                            child: const Text("Recommencer"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
          body: Stack(
            children: [
              Positioned(
                top: 20,
                right: 20,
                child: Text(
                  'Score : $score | Meilleur : $meilleurScore | Niveau : $niveau',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...briques.map((brique) => Positioned(
                top: brique['offset'].dy,
                left: brique['offset'].dx,
                child: Brique(
                  largeur: largeurBrique,
                  hauteur: hauteurBrique,
                  couleur: brique['indestructible'] ? Colors.grey[800]! : Colors.orange,
                ),
              )),
              Positioned(
                top: posY,
                left: posX,
                child: const Balle(),
              ),
              Positioned(
                bottom: 0,
                left: positionBatte,
                child: GestureDetector(
                  onHorizontalDragUpdate: (maj) => deplacerBatte(maj, context),
                  child: Batte(
                    largeur: largeurBatte,
                    hauteur: hauteurBatte,
                  ),
                ),
              ),
              if (partieTerminee)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          posX = 0;
                          posY = 0;
                          score = 0;
                          niveau = 1;
                          partieTerminee = false;
                          initialiserBriques();
                        });
                        controleur.repeat();
                      },
                      child: const Text('Rejouer'),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}