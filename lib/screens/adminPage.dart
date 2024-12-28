import 'package:flutter/material.dart';
import 'package:beecoderstest/screens/addCourse.dart';
import 'package:beecoderstest/models/course.dart';
import 'package:beecoderstest/service/courseService.dart';
import 'package:beecoderstest/service/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'dart:io';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final CourseService _courseService = CourseService();
  final StorageService _storageService = StorageService();
  List<Course> _courses = [];
  bool _isLoading = true;
  bool _isSelecting = false;
  List<bool> _selectedCourses = [];
  Uint8List? _imageData;
  String? localImagePath;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      List<Course> courses = await _courseService.getCourses();
      setState(() {
        _courses = courses;
        _selectedCourses = List<bool>.filled(courses.length, false);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? selectedImage = await picker.pickImage(source: ImageSource.gallery);
    
    if (selectedImage != null) {
      final bytes = await selectedImage.readAsBytes();
      setState(() {
        _imageData = bytes;
        localImagePath = selectedImage.path; // Update the local image path
      });
    } else {
      print('No image selected.'); // Debug
    }
  }

  Future<void> _showEditCourseDialog(BuildContext context, Course course) async {
    final TextEditingController nameController = TextEditingController(text: course.name);
    final TextEditingController priceController = TextEditingController(text: course.price);
    localImagePath = course.imageUrl;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Course Name')),
              TextField(controller: priceController, decoration: InputDecoration(labelText: 'Course Price')),
              
              // Button to select a new image
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await _pickImage();
                  setState(() {}); // Update the UI
                },
                child: Text('Select New Image'),
              ),

              // Display the selected image
              if (_imageData != null)
                Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String? newImageUrl;

                if (_imageData != null) {
                  // Upload the image to Cloudinary
                  final imageFile = File(localImagePath!);
                  newImageUrl = await _storageService.uploadImage(imageFile);
                  print('Image URL: $newImageUrl'); // Debug
                } else {
                  newImageUrl = localImagePath; // Keep the old image if no new one is selected
                  print('No new image selected, keeping old URL.'); // Debug
                }

                // Update the course with new values
                await _courseService.updateCourse(
                  course.id,
                  nameController.text,
                  priceController.text,
                  newImageUrl, // Use new or old image URL
                );

                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      _selectedCourses[index] = !_selectedCourses[index];
    });
  }

  void _deleteSelectedCourses() async {
    setState(() {
      _isLoading = true; // Indicate loading
    });

    try {
      for (int i = _courses.length - 1; i >= 0; i--) {
        if (_selectedCourses[i]) {
          await _courseService.deleteCourse(_courses[i].id); // Delete course
          _courses.removeAt(i); // Remove course from local list
        }
      }
      _selectedCourses = List<bool>.filled(_courses.length, false); // Reset selections
    } catch (e) {
      print('Error deleting courses: $e');
    } finally {
      setState(() {
        _isSelecting = false; // Exit selection mode
        _isLoading = false; // End loading
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
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Manage Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelecting = !_isSelecting;
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
                          showCheckbox: _isSelecting,
                          onCheckboxChanged: (value) {
                            _toggleSelection(index);
                          },
                          onEdit: () => _showEditCourseDialog(context, _courses[index]),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
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
  final Course course;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<bool?> onCheckboxChanged;
  final bool showCheckbox;
  final VoidCallback onEdit;

  CourseTile({
    required this.course,
    required this.isSelected,
    required this.onTap,
    required this.onCheckboxChanged,
    required this.showCheckbox,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        color: isSelected ? Colors.blueGrey : Colors.white,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(course.imageUrl ?? 'assets/LogoTheBrige.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (showCheckbox)
                  Checkbox(
                    value: isSelected,
                    onChanged: onCheckboxChanged,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        course.price,
                        style: TextStyle(fontSize: 16, color: Colors.white),
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