import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String name;
  final String price;
   String? imageUrl;

  Course({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
  });

  // Méthode pour créer un Course à partir d'un DocumentSnapshot
  factory Course.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Course(
      id: doc.id,
      name: data['name'] ?? '',
      price: data['price'] ?? '',
      imageUrl: data['image_path'],
    );
  }
}