import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:async'; // Pour Completer
import 'package:beecoderstest/service/courseService.dart'; // Votre service Firestore
import 'package:beecoderstest/service/storage_service.dart'; // Votre service Cloudinary

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  Uint8List? _imageData;
  final CourseService _courseService = CourseService();
  final StorageService _storageService = StorageService();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Gérer le sélecteur d'images pour le web
      html.File? selectedImage = await _selectImageForWeb();
      if (selectedImage != null) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(selectedImage);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _imageData = reader.result as Uint8List; // Convertir en Uint8List
          });
        });
      }
    } else {
      // Gérer le sélecteur d'images pour mobile
      final ImagePicker picker = ImagePicker();
      final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        final bytes = await selectedImage.readAsBytes();
        setState(() {
          _imageData = bytes; // Utiliser les octets de l'image
        });
      }
    }
  }

  Future<html.File?> _selectImageForWeb() async {
    final completer = Completer<html.File>();
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      completer.complete(files[0]);
    });

    return completer.future;
  }

  Future<void> _addCourse() async {
  String name = nameController.text.trim();
  String price = priceController.text.trim();

  // Vérifiez si une image a été sélectionnée
  String? imageUrl;
  if (_imageData != null) {
    // Télécharger l'image sur Cloudinary
    if (kIsWeb) {
      // Utilisation de uploadImageFromBytes pour les applications Web
      imageUrl = await _storageService.uploadImageFromBytes(_imageData!);
    } else {
      // Pour mobile, utilisez image_picker pour obtenir le fichier
      final ImagePicker picker = ImagePicker();
      final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
      
      if (selectedImage != null) {
        // Lire les octets de l'image
        final bytes = await selectedImage.readAsBytes();
        // Uploader l'image sur Cloudinary
        imageUrl = await _storageService.uploadImageFromBytes(bytes);
      } else {
        print('No image selected for upload');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
        return;
      }
    }

    if (imageUrl == null) {
      print('Failed to upload image to Cloudinary.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image.')));
      return; // Arrêter si l'upload échoue
    }
  } else {
    print('No image selected for upload');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
    return;
  }

  // Ajouter le cours à Firestore
  print('Adding course: Name: $name, Price: $price, Image URL: $imageUrl');
  String? courseId = await _courseService.addCourse(name, price, imageUrl);

  if (courseId != null) {
    print('Course added successfully with ID: $courseId');
    nameController.clear();
    priceController.clear();
    setState(() {
      _imageData = null; // Réinitialiser l'image
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course added!')));
  } else {
    print('Failed to add course.');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add course.')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name of Course'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price in DT'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image from Gallery'),
            ),
            SizedBox(height: 20),
            if (_imageData != null)
              Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover), // Afficher l'image
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addCourse,
              child: Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}