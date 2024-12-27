import 'package:flutter/material.dart';
import 'screens/landingPage.dart';  // Page d'accueil

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LandingPage(),  // Afficher LandingPage au démarrage
    );
  }
}
