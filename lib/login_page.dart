import 'package:flutter/material.dart';
import 'file_manager.dart'; // Import FileManager for accessing stored user data
import 'registration_page.dart'; // Import Registration Page
import 'Screens/home_screen.dart'; // Import Home Screen


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState(); // Creates mutable state
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  // Controllers to manage text input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false; // Loading state for UI feedback

  // Function to handle login process
  void _loginUser() async {
    if (_formKey.currentState!.validate()) { // Validate the form
      setState(() {
        _isLoading = true; // Show loading spinner
      });

      List<Map<String, dynamic>> users = await FileManager.readUserData(); // Read stored users
      String email = emailController.text;
      String password = FileManager.encodePassword(passwordController.text);

      print("Stored Users: $users"); // Debugging step

      // Check if user exists and password is correct
      var user = users.firstWhere(
        (u) => u["email"] == email && u["password_hash"] == password,
        orElse: () => <String, dynamic>{}, //
      );

      if (user.isNotEmpty) { // Correctly checking if the user exists
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login Successful!")),
        );

        // Navigate to Home Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else { // If user not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password!")),
        );
      }

      setState(() {
        _isLoading = false; // Stop loading spinner
      });
    }
  }

  // Function to allow guest login
  void _loginAsGuest() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Logged in as Guest!")),
    );

    // Navigate to Home Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Study Flow Login")), // App bar title
      body: Padding(
        padding: EdgeInsets.all(16.0), // Add padding
        child: Form(
          key: _formKey, // Attach form key
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Email input field
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.isEmpty || !value.contains('@') ? "Enter a valid email" : null,
              ),
              // Password input field
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? "Enter your password" : null,
              ),
              SizedBox(height: 20),

              // Conditional loading spinner or login button
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loading spinner
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: _loginUser, // Call login function
                          child: Text("Login"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to Registration Page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => RegistrationPage()),
                            );
                          },
                          child: Text("Don't have an account? Register here"),
                        ),
                        SizedBox(height: 10), // Add spacing
                        
                        // Guest Login Button
                        TextButton(
                          onPressed: _loginAsGuest, // Call guest login function
                          child: Text("Continue as Guest"),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}


