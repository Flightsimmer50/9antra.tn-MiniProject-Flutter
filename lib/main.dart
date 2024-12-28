import 'package:beecoderstest/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importer Firebase
import 'screens/landingPage.dart';  // Page d'accueil

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Assurez-vous que les widgets sont initialisés
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); // Initialiser Firebase
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
      debugShowCheckedModeBanner: false,
      home: LandingPage(),  // Afficher LandingPage au démarrage
    );
  }
}