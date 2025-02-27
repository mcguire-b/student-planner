import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page file





void main() {
  runApp(StudentPlannerApp());
}

// Root widget of the application
class StudentPlannerApp extends StatelessWidget {
  const StudentPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Start with the Login Page
    );
  }
}

