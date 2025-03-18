import 'dart:io'; // Provides File and Directory classes for file system operations
import 'dart:convert'; // Provides JSON encoding and decoding capabilities
import 'package:path_provider/path_provider.dart'; // Helps find local file system paths
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';


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
  // Get task data file
  static Future<File> get _taskFile async {
    final path = await _localPath;
    return File('$path/tasks.json');
  }

  // Write task data
  static Future<bool> writeTaskData(Map<String, dynamic> newTask) async {
    try {
      List<Map<String, dynamic>> existingTasks = await readTaskData();

      bool taskExists = existingTasks.any((task) =>
          task["name"] == newTask["name"] &&
          task["startDate"] == newTask["startDate"]);

      if (!taskExists) {
        existingTasks.add(newTask);

        if (kIsWeb) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('tasks', jsonEncode(existingTasks));
        } else {
          final file = await _taskFile;
          await file.writeAsString(jsonEncode(existingTasks));
        }
        return true; // Task successfully saved
      } else {
        print("Task already exists!");
        return false;
      }
    } catch (e) {
      print("Error saving task: $e");
      return false;
    }
  }

  static Future<void> writeUpdatedTasks(List<Map<String, dynamic>> updatedTasks) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('tasks', jsonEncode(updatedTasks));
    } else {
      final file = await _taskFile;
      await file.writeAsString(jsonEncode(updatedTasks));
    }
  }

  static Future<List<Map<String, dynamic>>> readTaskData() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final String? tasksJson = prefs.getString('tasks');
      return tasksJson != null ? List<Map<String, dynamic>>.from(jsonDecode(tasksJson)) : [];
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/tasks.json');
      return await file.exists() ? List<Map<String, dynamic>>.from(jsonDecode(await file.readAsString())) : [];
    }
  }
  
}
