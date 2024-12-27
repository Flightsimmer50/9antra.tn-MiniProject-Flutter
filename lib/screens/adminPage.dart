// admin_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  // Controllers pour le formulaire
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _selectedImage;

  // Fonction pour sélectionner une image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Fonction pour uploader l'image et obtenir l'URL
  Future<String> _uploadImage(File image) async {
    try {
      String fileName = 'courses/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors de l\'upload de l\'image: $e');
      return '';
    }
  }

  // Fonction pour ajouter un cours
  Future<void> _addCourse() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    String imageUrl = await _uploadImage(_selectedImage!);
    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'upload de l\'image')),
      );
      return;
    }

    await _firestore.collection('courses').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'price': double.parse(_priceController.text),
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Réinitialiser le formulaire
    _titleController.clear();
    _descriptionController.clear();
    _priceController.clear();
    setState(() {
      _selectedImage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cours ajouté avec succès')),
    );
  }

  // Fonction pour supprimer un cours
  Future<void> _deleteCourse(String courseId, String imageUrl) async {
    await _firestore.collection('courses').doc(courseId).delete();

    // Supprimer l'image de Firebase Storage
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Erreur lors de la suppression de l\'image: $e');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cours supprimé')),
    );
  }

  // Fonction pour mettre à jour un cours
  Future<void> _updateCourse(String courseId, String currentImageUrl) async {
    final TextEditingController _updateTitleController = TextEditingController();
    final TextEditingController _updateDescriptionController = TextEditingController();
    final TextEditingController _updatePriceController = TextEditingController();
    File? _updateSelectedImage;
    String imageUrl = currentImageUrl;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mettre à jour le cours'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _updateTitleController,
                  decoration: const InputDecoration(labelText: 'Titre du cours'),
                ),
                TextField(
                  controller: _updateDescriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: _updatePriceController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                _updateSelectedImage == null
                    ? Image.network(
                        currentImageUrl,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _updateSelectedImage!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                TextButton(
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        _updateSelectedImage = File(image.path);
                      });
                    }
                  },
                  child: const Text('Changer l\'image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_updateTitleController.text.isNotEmpty &&
                    _updateDescriptionController.text.isNotEmpty &&
                    _updatePriceController.text.isNotEmpty) {
                  if (_updateSelectedImage != null) {
                    imageUrl = await _uploadImage(_updateSelectedImage!);
                  }

                  await _firestore.collection('courses').doc(courseId).update({
                    'title': _updateTitleController.text,
                    'description': _updateDescriptionController.text,
                    'price': double.parse(_updatePriceController.text),
                    'imageUrl': imageUrl,
                  });

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cours mis à jour')),
                  );
                }
              },
              child: const Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Interface'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ajouter un Nouveau Cours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre du cours'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _selectedImage == null
                      ? const Text('Aucune image sélectionnée')
                      : Image.file(
                          _selectedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Sélectionner une Image'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addCourse,
                child: const Text('Ajouter le Cours'),
              ),
              const Divider(height: 40, thickness: 2),
              const Text(
                'Liste des Cours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('courses').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Aucun cours disponible'));
                  }

                  var courses = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      var course = courses[index];
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            course['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(course['title']),
                          subtitle: Text('\$${course['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _updateCourse(course.id, course['imageUrl']);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteCourse(course.id, course['imageUrl']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
