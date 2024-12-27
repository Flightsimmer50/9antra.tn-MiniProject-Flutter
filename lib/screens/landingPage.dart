import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/LogoTheBridge.png', 
              height: 40, 
            ),
            SizedBox(width: 10), // Espace entre le logo et le titre
            Text('Course Platform'),
          ],
        ),
        centerTitle: false, // Aligner le titre à gauche
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Section de promotion
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/CoworkingSpaceImage.png'), 
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  // Rectangle semi-transparent
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7), // Couleur blanche semi-transparente
                    borderRadius: BorderRadius.circular(10), // Coins arrondis
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Improve your skills on your own',
                        style: TextStyle(fontSize: 24, color: Colors.black), // Texte en noir
                      ),
                      SizedBox(height: 10),
                      Text(
                        'To prepare for a better future',
                        style: TextStyle(fontSize: 18, color: Colors.black), // Texte en noir
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton
                        },
                        child: Text('REGISTER NOW'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Section de découverte des cours
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pour espacer le texte et le bouton
                    children: [
                      Text(
                        'Discover Our Courses',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Action pour le bouton
                        },
                        child: Text('View More'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      CourseCard(courseName: 'Spring Boot / Angular'),
                      CourseCard(courseName: 'Node JS / React'),
                      CourseCard(courseName: 'Flutter / Firebase'),
                      CourseCard(courseName: 'Business Intelligence'),
                      CourseCard(courseName: 'Artificial Intelligence'),
                      CourseCard(courseName: 'DevOps'),
                    ],
                  ),
                ],
              ),
            ),
            // Section de contact
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  // Ajoutez un formulaire de contact ici
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseName;

  CourseCard({required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(courseName, style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('350 DT / Month', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}