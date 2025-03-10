import 'dart:io'; // Provides File and Directory classes for file system operations
import 'dart:convert'; // Provides JSON encoding and decoding capabilities
import 'package:path_provider/path_provider.dart'; // Helps find local file system paths


class FileManager {
  // Function to get the local application documents directory path
  // This is a safe, app-specific storage location on the device
  static Future<String> get _localPath async {
    // getApplicationDocumentsDirectory() provides a platform-specific directory 
    // where the app can store files that are persistent and private to the app
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Function to get a specific file for storing user data
  // Uses the local path to create a full file path
  static Future<File> get _userFile async {
    // Combine the local path with a specific filename (users.txt)
    final path = await _localPath;
    return File('$path/users.json');
  }

  //hashing function using base64 encoding
  static String encodePassword(String password) {
    return base64Encode(utf8.encode(password)); // Encoding password
  }

  // Method to write new user data to the file
  // Takes a Map of user data as input
  static Future<bool> writeUserData(Map<String, dynamic> userData) async {
    try {
      // Get the file for storing user data
      final file = await _userFile;

      // Read existing user data
      List<Map<String, dynamic>> users = await readUserData();

      // Check if a user with the same email already exists
      // Prevents duplicate user registrations
      if (users.any((user) => user['email'] == userData['email'])) {
        print("User already exists!");
        return false;
      }

       // Hash the password before storing
      userData["password_hash"] = encodePassword(userData["password_hash"]);

      // Add the new user to the list of existing users
      users.add(userData);
      // Write data safely using writeAsString
      await file.writeAsString(jsonEncode(users), mode: FileMode.write);
      print("User registered successfully.");
      return true;
    } catch (e) {
      print("Error writing user data: $e");
      return false;
    }
  }

  // Method to read user data from the file
  // Returns a list of user data maps
  static Future<List<Map<String, dynamic>>> readUserData() async {
    try {
      // Get the user data file
      final file = await _userFile;

      // Check if the file exists
      if (await file.exists()) {
        // Read the file contents as a string
        String content = await file.readAsString();

        // If the file is empty, return an empty list
        if (content.trim().isEmpty) {
          return [];
        }

        // Decode the JSON string into a list of maps
        // List<Map<String, dynamic>> ensures type safety
        return List<Map<String, dynamic>>.from(jsonDecode(content));
      }

      // Return an empty list if the file doesn't exist
      return [];
    } catch (e) {
      // Handle any errors that occur during file reading
      print("Error reading user data: $e");
      return [];
    }
  }
}