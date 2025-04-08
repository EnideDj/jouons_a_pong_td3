import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jouons_a_pong/main.dart';

void main() {
  testWidgets('Page principale affiche Pong dans AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Jeu Pong'), findsOneWidget);
  });

  testWidgets('Le bouton paramètres est présent', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Le score est affiché', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.textContaining('Score'), findsWidgets);
  });
}