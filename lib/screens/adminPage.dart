import 'package:flutter/material.dart';
import 'package:beecoderstest/screens/addCourse.dart'; // Importer la page AddCourse
import 'package:beecoderstest/models/course.dart'; // Importer la classe Course
import 'package:beecoderstest/service/courseService.dart'; // Importer votre service

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];
  bool _isLoading = true; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      // Récupérer les cours depuis Firestore
      List<Course> courses = await _courseService.getCourses();

      setState(() {
        _courses = courses;
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false; // Fin du chargement même en cas d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Afficher un indicateur de chargement
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manage Courses',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        return CourseTile(course: _courses[index]);
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
        height: 150, // Hauteur de la carte
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(course.imageUrl ?? 'assets/LogoTheBrige.png'),
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
                style: TextStyle(fontSize: 18, color: Colors.white), // Couleur du texte
              ),
              SizedBox(height: 8.0),
              Text(
                course.price,
                style: TextStyle(fontSize: 16, color: Colors.white), // Couleur du texte
              ),
            ],
          ),
        ),
      ),
    );
  }
}