import 'package:flutter/material.dart';
import 'package:beecoderstest/screens/adminPage.dart'; // Importer la page Admin
import 'package:beecoderstest/models/course.dart'; // Import the Course model
import 'package:beecoderstest/service/courseService.dart'; // Import Course service

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final CourseService _courseService = CourseService();
  List<Course> _courses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      List<Course> courses = await _courseService.getCourses();
      setState(() {
        _courses = courses.take(6).toList(); // Take the first 6 courses
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching courses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/LogoTheBridge.png',
              height: 40,
            ),
            SizedBox(width: 10),
            Text('Course Platform'),
          ],
        ),
        centerTitle: false,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Ajout du bouton Admin Page
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF9B1B30),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminPage()),
                          );
                        },
                        child: Text('Admin Page'),
                      ),
                    ),
                  ),

                  // Section de promotion
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/CoworkingSpaceImage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Improve your skills on your own',
                              style: TextStyle(fontSize: 24, color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'To prepare for a better future',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9B1B30),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // Action pour le bouton
                              },
                              child: Text('REGISTER NOW'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Section de découverte des cours
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Discover Our Courses',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9B1B30),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                // Action pour le bouton
                              },
                              child: Text('View More'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 4 / 3, // Adjusted aspect ratio
                          ),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _courses.length,
                          itemBuilder: (context, index) {
                            return CourseCard(course: _courses[index]);
                          },
                        ),
                      ],
                    ),
                  ),

                  // Section de contact
                  Container(
                    padding: EdgeInsets.all(20),
                    color: Color(0xFFFFC107),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Us',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Message',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Action pour envoyer le message
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9B1B30),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Send the message'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Background image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(course.imageUrl ?? 'assets/placeholder.png'), // Default image if null
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Course name and price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '${course.price} DT / Month',
                  style: TextStyle(color: Color(0xFF9B1B30)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}