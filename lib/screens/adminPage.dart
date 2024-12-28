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
  bool _isSelecting = false; // Indicateur de mode sélection
  List<bool> _selectedCourses = []; // Liste pour suivre les sélections

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
        _selectedCourses = List<bool>.filled(courses.length, false); // Initialiser la liste de sélection
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false; // Fin du chargement même en cas d'erreur
      });
    }
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedCourses[index] = !_selectedCourses[index];
    });
  }

  void _deleteSelectedCourses() async {
    setState(() {
      _isLoading = true; // Indiquer que nous sommes en cours de chargement
    });

    try {
      for (int i = _courses.length - 1; i >= 0; i--) {
        if (_selectedCourses[i]) {
          await _courseService.deleteCourse(_courses[i].id); // Appeler le service pour supprimer le cours
          _courses.removeAt(i); // Supprimer le cours de la liste locale
        }
      }
      _selectedCourses = List<bool>.filled(_courses.length, false); // Réinitialiser les sélections
    } catch (e) {
      print('Error deleting courses: $e');
      // Gérer l'erreur si nécessaire
    } finally {
      setState(() {
        _isSelecting = false; // Quitter le mode sélection
        _isLoading = false; // Fin du chargement
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        actions: [
          if (_isSelecting) 
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelectedCourses,
            ),
        ],
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelecting = !_isSelecting; // Activer ou désactiver le mode sélection
                      });
                    },
                    child: Text(_isSelecting ? 'Cancel Selection' : 'Select Courses'),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        return CourseTile(
                          course: _courses[index],
                          isSelected: _isSelecting && _selectedCourses[index],
                          onTap: () => _toggleSelection(index),
                          showCheckbox: _isSelecting, // Afficher la case à cocher uniquement si en mode sélection
                          onCheckboxChanged: (value) {
                            _toggleSelection(index);
                          },
                        );
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
  final bool isSelected; // Indiquer si la carte est sélectionnée
  final VoidCallback onTap; // Callback pour gérer le tap
  final ValueChanged<bool?> onCheckboxChanged; // Callback pour gérer la case à cocher
  final bool showCheckbox; // Indiquer si la case à cocher doit être affichée

  CourseTile({
    required this.course,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.showCheckbox,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Gérer le tap pour sélectionner
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        color: isSelected ? Colors.blueGrey : Colors.white, // Changer la couleur si sélectionné
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
            child: Row(
              children: [
                if (showCheckbox) // Afficher la case à cocher uniquement si en mode sélection
                  Checkbox(
                    value: isSelected,
                    onChanged: onCheckboxChanged, // Gérer la case à cocher
                  ),
                Expanded(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}