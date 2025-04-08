# Jouons à Pong - TP N°3

## Description

Ce projet est une application mobile Flutter reprenant le célèbre **jeu Pong**, enrichi de plusieurs niveaux, d’un système de score et de briques destructibles ou indestructibles.  
Le jeu est rythmé, responsive et propose une interface interactive simple à utiliser.

### Fonctionnalités principales :
- Contrôle de la batte avec le doigt (**glisser horizontalement**).
- Système de **score** et de **meilleur score enregistré**.
- **Progression de niveaux** avec difficulté croissante.
- Apparition de **briques indestructibles** à partir du niveau 2.
- **Sauvegarde locale** du meilleur score avec `SharedPreferences`.
- Interface complète avec **page de paramètres** pour réinitialiser le score.

---

## Structure du projet

```env
├── lib/
│   ├── main.dart                # Point d’entrée de l’application
│   ├── page_principale.dart     # Logique principale du jeu Pong
│   ├── page_parametre.dart      # Page des paramètres
│   ├── balle.dart               # Widget représentant la balle
│   ├── batte.dart               # Widget représentant la batte
│   ├── brique.dart              # Widget représentant une brique
├── pubspec.yaml                 # Dépendances et configuration Flutter
```
## Installation

1. **Clonez le projet** :

```bash
git clone https://github.com/EnideDj/gestions_temps_td2
```
2.	Installez les dépendances :
```bash
flutter pub get
```
3.	Exécutez l’application :
      Pour exécuter l’application sur un émulateur ou un appareil physique, utilisez la commande suivante :
```bash
flutter run
```
4.	Exécutez les tests :
      Pour exécuter les tests unitaires, utilisez la commande suivante :
```bash
flutter test
```


## Remarques
•	La taille de la batte diminue avec les niveaux, augmentant la difficulté progressivement.
•	Le bouton Rejouer s’affiche si la partie est terminée.

## ENIDE DJENDER - FISA-TI-27 - IMT NORD EUROPE 
#jouons_a_pong_td3
