import 'package:flutter/material.dart';
import 'package:beecoderstest/screens/adminPage.dart'; // Importer la page Admin

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/LogoTheBridge.png', // Assurez-vous que le nom et le chemin sont corrects
              height: 40, // Ajustez la taille selon vos besoins
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
            // Ajout du bouton Admin Page
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B1B30),
                          foregroundColor: Colors.white,
                        ),
                  onPressed: () {
                    // Navigation vers la page Admin
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  },
                  child: Text('Admin Page'),
                ),
              ),
            ),

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
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Improve your skills on your own',
                        style: TextStyle(fontSize: 24, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'To prepare for a better future',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B1B30),
                          foregroundColor: Colors.white,
                        ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discover Our Courses',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B1B30),
                          foregroundColor: Colors.white,
                        ),
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
            Container(
              padding: EdgeInsets.all(20),
              color: Color(0xFFFFC107),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Action pour envoyer le message
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9B1B30),
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Send the message'),
                    ),
                  ),
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