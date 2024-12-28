import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:beecoderstest/service/courseService.dart'; // Your Firestore service
import 'package:beecoderstest/service/storage_service.dart'; // Your Cloudinary service

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
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      // Use image_picker for both web and mobile
      final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        final bytes = await selectedImage.readAsBytes();
        setState(() {
          _imageData = bytes; // Use the image bytes
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to pick image.')));
    }
  }

  Future<void> _addCourse() async {
    String name = nameController.text.trim();
    String price = priceController.text.trim();

    // Check if an image has been selected
    String? imageUrl;
    if (_imageData != null) {
      // Upload the image to Cloudinary
      imageUrl = await _storageService.uploadImageFromBytes(_imageData!);

      if (imageUrl == null) {
        print('Failed to upload image to Cloudinary.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image.')));
        return; // Stop if the upload fails
      }
    } else {
      print('No image selected for upload');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select an image.')));
      return;
    }

    // Add the course to Firestore
    print('Adding course: Name: $name, Price: $price, Image URL: $imageUrl');
    String? courseId = await _courseService.addCourse(name, price, imageUrl);

    if (courseId != null) {
      print('Course added successfully with ID: $courseId');
      nameController.clear();
      priceController.clear();
      setState(() {
        _imageData = null; // Reset the image
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
              Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover), // Display the image
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