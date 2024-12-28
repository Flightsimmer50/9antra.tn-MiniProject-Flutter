import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart'; // Pour kIsWeb
import 'dart:async'; // Pour Completer
import 'dart:io'; // Importer pour utiliser la classe File
import 'package:beecoderstest/service/courseService.dart'; // Assurez-vous que le chemin est correct

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  Uint8List? _imageData;
  final CourseService _courseService = CourseService(); // Instance de CourseService

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
        setState(() {
          _imageData = File(selectedImage.path).readAsBytesSync(); // Lire les octets
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

  void _addCourse() async {
    String name = nameController.text;
    String price = priceController.text;

    String? imageUrl;
    if (_imageData != null) {
      print('Uploading image...'); // Log avant l'upload
      imageUrl = await _courseService.uploadImage(_imageData!); // Utiliser la méthode uploadImage
      if (imageUrl != null) {
        print('Image uploaded successfully: $imageUrl'); // Log après l'upload réussi
      } else {
        print('Image upload failed'); // Log si l'upload échoue
      }
    } else {
      print('No image selected for upload'); // Log si aucune image n'est sélectionnée
    }

    // Ajouter le cours à Firestore en utilisant CourseService
    print('Adding course: Name: $name, Price: $price, Image URL: $imageUrl'); // Log avant l'ajout
    String? courseId = await _courseService.addCourse(name, price, _imageData);

    if (courseId != null) {
      print('Course added successfully with ID: $courseId'); // Log après l'ajout réussi
      // Réinitialiser les champs après l'ajout
      nameController.clear();
      priceController.clear();
      setState(() {
        _imageData = null; // Réinitialiser l'image
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Course added!')));
    } else {
      print('Failed to add course.'); // Log si l'ajout échoue
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