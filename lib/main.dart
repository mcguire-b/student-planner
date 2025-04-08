import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
//import 'Database/database.dart'; // may need this import for web support later on

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures plugins are ready
  runApp(StudentPlannerApp());

  //final database = AppDatabase(); //may need to re-enable this line for web support later
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

