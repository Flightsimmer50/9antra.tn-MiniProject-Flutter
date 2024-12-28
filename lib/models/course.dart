// lib/models/course.dart

class Course {
  final String _id; // Champ privé pour l'identifiant
  final String name;
  final String price;
  final String imageUrl; // Champ pour l'URL de l'image

  Course({
    required String id,
    required this.name,
    required this.price,
    required this.imageUrl, // Ajout du paramètre pour l'URL de l'image
  }) : _id = id;

  // Fournir une méthode pour accéder à l'identifiant
  String get id => _id;
}