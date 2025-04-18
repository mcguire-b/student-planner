import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'notification_service.dart'; // import your notification service


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugins are ready
  await NotificationService.initialize();
  runApp(StudentPlannerApp());
}

// Root widget of the application
class StudentPlannerApp extends StatelessWidget {
  const StudentPlannerApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner from UI
      title: 'Student Planner', // App title
      theme: ThemeData(primarySwatch: Colors.blue), // Define theme
      home: LoginPage(), // Set the Login Page as the first screen
    );
  }
}

