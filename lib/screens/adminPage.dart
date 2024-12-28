import 'package:flutter/material.dart';
import 'package:beecoderstest/screens/addCourse.dart'; // Importer la page AddCourse
import 'package:beecoderstest/models/course.dart'; // Importer la classe Course

class AdminPage extends StatelessWidget {
  // Liste de cours pour exemple avec des IDs fictifs et des images
  final List<Course> courses = [
    Course(
      id: '1',
      name: 'Spring Boot / Angular',
      price: '350 DT',
      imageUrl: 'https://example.com/spring-boot-angular.jpg',
    ),
    Course(
      id: '2',
      name: 'Node JS / React',
      price: '300 DT',
      imageUrl: 'https://example.com/node-js-react.jpg',
    ),
    Course(
      id: '3',
      name: 'Flutter / Firebase',
      price: '400 DT',
      imageUrl: 'https://example.com/flutter-firebase.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage Courses',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Liste des cours
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseTile(course: courses[index]);
                },
              ),
            ),

            SizedBox(height: 20),
            Container(
              width: double.infinity, // Occupe toute la largeur
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCourse()),
                  );
                },
                child: Text('Add Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class CourseTile extends StatelessWidget {
  final Course course; // Utiliser la classe Course

  CourseTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(course.imageUrl ?? 'https://example.com/default_image.png'),
            fit: BoxFit.cover, // Adapter l'image à la taille de la carte
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.name,
                style: TextStyle(fontSize: 18, color: Colors.white), // Changer la couleur du texte
              ),
              SizedBox(height: 8.0),
              Text(
                course.price,
                style: TextStyle(fontSize: 16, color: Colors.white), // Changer la couleur du texte
              ),
            ],
          ),
        ),
      ),
    );
  }
}