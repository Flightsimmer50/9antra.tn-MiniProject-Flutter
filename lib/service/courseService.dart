import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:beecoderstest/models/course.dart'; 

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour ajouter un cours
  Future<String?> addCourse(String name, String price, String? localImagePath) async {
    try {
      DocumentReference docRef = await _firestore.collection('courses').add({
        'name': name,
        'price': price,
        'image_path': localImagePath, // Stocker le chemin de l'image locale
      });
      return docRef.id; // Retourne l'ID du document ajouté
    } catch (e) {
      print('Error adding course: $e');
      return null;
    }
  }

  // Méthode pour récupérer tous les cours
  Future<List<Course>> getCourses() async {
    try {
      // Récupérer les documents de la collection 'courses'
      QuerySnapshot snapshot = await _firestore.collection('courses').get();

      // Mapper chaque document à un objet Course
      return snapshot.docs.map((doc) {
        return Course.fromFirestore(doc); // Utiliser la méthode fromFirestore
      }).toList();
    } catch (e) {
      print('Error fetching courses: $e');
      return []; // Retourner une liste vide en cas d'erreur
    }
  }

  // Méthode pour récupérer un cours par ID
  Future<Course?> getCourseById(String courseId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('courses').doc(courseId).get();
      if (doc.exists) {
        return Course.fromFirestore(doc);
      } else {
        print('Course not found');
        return null;
      }
    } catch (e) {
      print('Error fetching course: $e');
      return null;
    }
  }

  // Méthode pour mettre à jour un cours
  Future<void> updateCourse(String courseId, String name, String price, String? localImagePath) async {
    try {
      await _firestore.collection('courses').doc(courseId).update({
        'name': name,
        'price': price,
        'image_path': localImagePath, // Mettre à jour le chemin de l'image locale
      });
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  // Méthode pour supprimer un cours
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('courses').doc(courseId).delete();
    } catch (e) {
      print('Error deleting course: $e');
    }
  }
}