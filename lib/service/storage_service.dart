import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

class StorageService with ChangeNotifier {
  String? _imageUrl; // Pour stocker l'URL de l'image
  String? get imageUrl => _imageUrl; // Getter pour l'URL de l'image

  // Méthode pour télécharger l'image sur Cloudinary via HTTP
  Future<String?> uploadImage(File imageFile) async {
    final String cloudName = 'dqzdkadev';
    final String uploadPreset = 'testbridge';

    try {
      // Créer un multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );

      // Ajouter le fichier à la requête
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Le nom du champ que Cloudinary attend
          imageFile.path,
          filename: basename(imageFile.path), // Nom du fichier
        ),
      );

      // Ajouter le preset
      request.fields['upload_preset'] = uploadPreset;

      // Envoyer la requête
      var response = await request.send();

      // Vérifier la réponse
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final responseJson = json.decode(responseData.body);
        _imageUrl = responseJson['secure_url']; // Récupérer l'URL sécurisée
        notifyListeners(); // Notifie les auditeurs
        return _imageUrl; // Retourner l'URL de l'image
      } else {
        print('Erreur lors du téléchargement : ${responseData.body}');
        return null; // Retourner null en cas d'erreur
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Retourner null en cas d'exception
    }
  }

  // Méthode pour télécharger une image à partir de Uint8List (Web)
  Future<String?> uploadImageFromBytes(Uint8List imageData) async {
    final String cloudName = 'dqzdkadev';
    final String uploadPreset = 'testbridge';

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
      );

      // Ajouter le fichier à la requête
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageData,
          filename: 'uploaded_image.jpg', // Nom du fichier
        ),
      );

      // Ajouter le preset
      request.fields['upload_preset'] = uploadPreset;

      // Envoyer la requête
      var response = await request.send();

      // Vérifier la réponse
      final responseData = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        final responseJson = json.decode(responseData.body);
        _imageUrl = responseJson['secure_url']; // Récupérer l'URL sécurisée
        notifyListeners(); // Notifie les auditeurs
        return _imageUrl; // Retourner l'URL de l'image
      } else {
        print('Erreur lors du téléchargement : ${responseData.body}');
        return null; // Retourner null en cas d'erreur
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Retourner null en cas d'exception
    }
  }
}