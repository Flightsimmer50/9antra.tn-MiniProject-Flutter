import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:beecoderstest/models/course.dart'; 

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour ajouter un cours
  Future<String?> addCourse(String name, String price, Uint8List? imageData) async {
    String? imageUrl;
    if (imageData != null) {
      imageUrl = await uploadImage(imageData); // Appel à la méthode publique uploadImage
    }

    try {
      DocumentReference docRef = await _firestore.collection('courses').add({
        'name': name,
        'price': price,
        'image_url': imageUrl,
      });
      return docRef.id; // Retourne l'ID du document ajouté
    } catch (e) {
      print('Error adding course: $e');
      return null;
    }
  }

  // Méthode pour uploader une image
  Future<String?> uploadImage(Uint8List imageData) async {
  try {
    print('Starting image upload...'); // Log pour commencer l'upload
    final ref = _storage.ref().child('course_images/${DateTime.now().millisecondsSinceEpoch}');
    
    // Suivre l'état de l'upload
    UploadTask uploadTask = ref.putData(imageData);
    
    // Afficher des logs de progression
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Upload progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}'); // Log de progression
    });

    await uploadTask; // Attendre la fin de l'upload
    print('Image uploaded successfully'); // Log après l'upload

    return await ref.getDownloadURL(); // Retourner l'URL de l'image
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
  // Méthode pour récupérer tous les cours
  Stream<List<Course>> getCourses() {
    return _firestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Course.fromFirestore(doc); // Assurez-vous que cette méthode existe dans votre modèle
      }).toList();
    });
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
  Future<void> updateCourse(String courseId, String name, String price, Uint8List? imageData) async {
    String? imageUrl;
    if (imageData != null) {
      imageUrl = await uploadImage(imageData); // Appel à la méthode publique uploadImage
    }

    try {
      await _firestore.collection('courses').doc(courseId).update({
        'name': name,
        'price': price,
        'image_url': imageUrl,
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