import 'package:flutter/material.dart';
import 'file_manager.dart'; // Import FileManager for saving user data
import 'login_page.dart'; // Import Login Page for redirection after successful registration

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>(); // Form validation key

  // Controllers for input fields
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false; // Loading state indicator

  // Function to handle user registration
  void _registerUser() async {
    if (_formKey.currentState!.validate()) { // Validate form input
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      // Encode the password before saving
      final hashedPassword = FileManager.encodePassword(passwordController.text, "saltValue"); // Replace "saltValue" with the actual second argument required

      // User data to be saved
      Map<String, dynamic> userData = {
        "username": nameController.text,
        "email": emailController.text,
        "password_hash": hashedPassword, // Should be hashed in real apps
        "created_at": DateTime.now().toIso8601String(),
        "last_login": null
      };

      await FileManager.writeUserData(userData); // Save user to file

      setState(() {
        _isLoading = false; // Stop loading spinner
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration successful!")),
      );

      // Navigate back to Login Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")), // App bar title
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    !value!.contains('@') ? "Enter a valid email" : null,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.length < 6 ? "Password too short" : null,
              ),
              TextFormField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
                validator: (value) =>
                    value != passwordController.text ? "Passwords do not match" : null,
              ),
              SizedBox(height: 20),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _registerUser, // Call register function
                      child: Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}