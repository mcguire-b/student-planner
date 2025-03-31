import 'dart:io'; // Provides File and Directory classes for file system operations
import 'dart:convert'; // Provides JSON encoding and decoding capabilities
import 'package:path_provider/path_provider.dart'; // Helps find local file system paths
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart' as crypto; // provides hashing functions
import 'dart:math';//for generating random salt


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

  //Function to generate a random salt 
  static String generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }


  //hashing function using sha-256 hashing algorithm
  static String encodePassword(String password, String salt) {
    var bytes = utf8.encode(password + salt);//convert the password to bytes combine salt
    var digest = crypto.sha256.convert(bytes);//hash the password
    return digest.toString();//return the hashed password
  }

  // Method to write new user data to the file
  // Takes a Map of user data as input
  static Future<bool> writeUserData(Map<String, dynamic> userData) async {
    try {
      List<Map<String, dynamic>> existingUsers = await readUserData();

    // Check if user already exists by email
    bool userExists = existingUsers.any((user) => user["email"] == userData["email"]);

    if (!userExists) {
      //add salt and the password
      String salt = generateSalt();
      userData["salt"] = salt;
      userData["password"] = encodePassword(userData["password"], salt);


      existingUsers.add(userData);

      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('users', jsonEncode(existingUsers));
      } else {
        final file = await _userFile;
        await file.writeAsString(jsonEncode(existingUsers));
      }

      return true;
    } else {
      print("User already exists!");
      return false;
    }
    } catch (e) {
      print("Error writing user data: $e");
      return false;
    }
  }

  // Method to read user data from the file
  // Returns a list of user data maps
  static Future<List<Map<String, dynamic>>> readUserData() async {
    try {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final String? usersJson = prefs.getString('users');
      return usersJson != null
          ? List<Map<String, dynamic>>.from(jsonDecode(usersJson))
          : [];
    } else {
      final file = await _userFile;

      if (await file.exists()) {
        String content = await file.readAsString();
        if (content.trim().isEmpty) {
          return [];
        }
        return List<Map<String, dynamic>>.from(jsonDecode(content));
      }

      return [];
    }
    } catch (e) {
      // Handle any errors that occur during file reading
      print("Error reading user data: $e");
      return [];
    }
  }

  //method to verify user password during login
  static Future<bool> verifyPassword(String email, String inputPassword) async {
    List <Map<String, dynamic>> existingUsers = await readUserData();

    final user = existingUsers.firstWhere((user) =>  user["email"] == email, orElse: () => {});
    if(user.isEmpty) return false;

    String salt = user["salt"];
    String hashedInput = encodePassword(inputPassword, salt);

    return hashedInput == user["password"];
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
