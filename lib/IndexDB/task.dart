import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import '../IndexDB/idb_file.dart'; // Import your IdbFile class

/**
 * THIS CLASS IS DECPRECATED AND SHOULD BE REMOVED ONCE TASK_MANAGE.DART IS FULLY FUNCTIONAL
 * ITS ONLY PUPROSE NOW IS TO SERVE AS A GUIDE FOR CODE SUGGESTION  
 */


/// Class representing an task object as created in the add_task_screen screen
class Task {
  final String id;
  String taskName;
  String taskCategory;
  String taskPriority; 
  DateTime startDate;
  DateTime endDate;
  TimeOfDay startTime;
  TimeOfDay endTime;
  int anticipatedTime; 

//getter for task ID field
String get idNum { return id; }
  
  
  Task({
    String? id,
    required this.taskName,
    required this.taskCategory,
    required this.taskPriority,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.anticipatedTime,
  }) : id = id ?? Uuid().v4(); // Generate a new UUID if not provided

 // Helper method to convert TimeOfDay to string, This is used for JSON storage conversion
  String timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

// Helper method to convert string to TimeOfDay, This is used for JSON storage conversion
static TimeOfDay timeOfDayFromString(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

  //this creates a JSON map from a task object
  Map<String, dynamic> toJson() {
    return{
      'id': id,
      'taskName': taskName,
      'taskCategory': taskCategory,
      'taskPriority': taskPriority,
      'startDate' : startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'startTime': timeOfDayToString(startTime),
      'endTime' : timeOfDayToString(endTime),
      'anticipatedTime' : anticipatedTime,
    };
  }
  /// this creates a task object from a json string
  factory Task.fromJson(Map<String, dynamic> json) {
    try {
    return Task(
      id: json['id'] as String?,
      taskName: json['taskName'] ?? 'Untitled Task',
      taskCategory: json['taskCategory'] ?? 'Uncategorized',
      taskPriority: json['taskPriority'] ?? 'Medium',
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now().add(Duration(hours: 1)),
      startTime: json['startTime'] != null ? timeOfDayFromString(json['startTime']) : TimeOfDay.now(),
      endTime: json['endTime'] != null ? timeOfDayFromString(json['endTime']) : TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute),
      anticipatedTime: json['anticipatedTime'] ?? 30,
    );
  } catch (e) {
    print("Error parsing Task from JSON: $e");
    print("Problematic JSON: $json");
    
    // Return a default task as fallback
    return Task(
      taskName: 'Error Task',
      taskCategory: 'Error',
      taskPriority: 'Medium',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(hours: 1)),
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute),
      anticipatedTime: 30,
    );
  }
}
}



///Manage task CRUD operations
class TaskStorage {
  static const String _tasksFilePath = '/tasks/tasks_data.json';


  // New load task method, 
  static Future<List<Map<String, dynamic>>> loadTasks() async {
  //Load DB
  final file = IdbFile(_tasksFilePath);
  
  try {
    // Check if the file exists
    if (await file.exists()) {
      // Read the JSON string
      final String jsonString = await file.readAsString();
      
      // Guard against empty file
      if (jsonString.isEmpty) {
        return [];
      }
      
      // Instead of parsing the entire JSON at once, try to create a new valid JSON list
      try {
        final parsed = jsonDecode(jsonString);
        if (parsed is! List) {
          print("Warning: JSON data is not a list");
          return [];
        }
        
        // Convert to a simple format first - avoid using Task objects for now
        List<Map<String, dynamic>> simpleTasks = [];
        
        for (var item in parsed) {
          // Create a simplified task with only the essential fields
          // Convert everything to strings to avoid type issues
          final simpleTask = {
            'id': (item['id'] ?? Uuid().v4()).toString(),
            'name': (item['taskName'] ?? 'Untitled').toString(),
            'category': (item['taskCategory'] ?? 'Uncategorized').toString(),
            'priority': (item['taskPriority'] ?? 'Medium').toString(),
            'startDate': DateTime.now().toIso8601String(),  // Use current date as fallback
            'startTime': '09:00',  // Use fixed time as fallback
            'endDate': DateTime.now().add(Duration(days: 1)).toIso8601String(),
            'endTime': '17:00',
            'anticipatedTime': 30,
            'status': 'to-do'
          };
          
          simpleTasks.add(simpleTask);
        }
        
        return simpleTasks;
      } catch (e) {
        print("Error parsing JSON: $e");
        return [];
      }
    }
  } catch (e) {
    print("Error loading tasks: $e");
  }
  
  // Return empty list if file doesn't exist or there was an error
  return [];
}




  ///Method to add Tasks to storage
  static Future<void> addTask(Task task) async {
    // Load existing tasks
    final tasks = await loadTasks();

    print("JSON being saved: ${jsonEncode(task.toJson())}");
    
    //convert imported task into a taskMap
    Map<String, dynamic> taskMap = task.toJson();

    // Add new taskMap
    tasks.add(taskMap); //tasks = List<Map<>>
    
    // Save all tasks
    await saveTasks(tasks); //tasks = List<Map<>>
  }//END ADDTASK





  ///Method to save lists of tasks to indexed DB storage
  static Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    //load DB
    final file = IdbFile(_tasksFilePath);

  //convert to jSON format
  //final List<Map<String, dynamic>> tasksJson = tasks.toJson().toList(); //toJson need Map<>

  // Serialize to a JSON string
    final String jsonString = jsonEncode(tasks);
    
    // Write to IndexedDB
    await file.writeAsString(jsonString);
  }// END SAVETASKS




  // //TODO correct this delete task method once priority task methods are working
  // /// Delete an task by ID
  // static Future<bool> deleteTask(String id) async {
  //   // Load existing tasks
  //   final tasks = await loadTasks();
    
  //   // Find the task
  //   final initialLength = tasks.length;
  //   tasks.removeWhere((event) => event.id == id);
    
  //   // If an task was removed
  //   if (tasks.length < initialLength) {
  //     // Save the updated list
  //     await saveTasks(tasks);
  //     return true;
  //   }
    
  //   return false;
  // }//END DELETE TASK
  




  // //TODO correct this update task method once priority task methods are working
  // /// Update an existing event
  // static Future<bool> updateTask(Task updatedTask) async {
  //   // Load existing events
  //   final tasks = await loadTasks();
    
  //   // Find the event index
  //   final index = tasks.indexWhere((event) => event.id == updatedTask.id);
    
  //   // If event found
  //   if (index >= 0) {
  //     // Replace with updated event
  //     tasks[index] = updatedTask;
      
  //     // Save the updated list
  //     await saveTasks(tasks);
  //     return true;
  //   }
    
  //   return false;
  // }// END UPDATE TASK


/// TODO old load task method returns list not list<Map> delete when new method works
  // /// Load all tasks from storage
  // static Future<List<Task>> loadTasks() async {
  //   final file = IdbFile(_tasksFilePath);
    
  //   // Check if the file exists
  //   if (await file.exists()) {
  //     // Read the JSON string
  //     final String jsonString = await file.readAsString();
      
  //     // Parse the JSON string
  //     final List<dynamic> tasksJson = jsonDecode(jsonString);
      
  //     // Convert to Event objects
  //     return tasksJson.map((json) => Task.fromJson(json)).toList();
  //   }
    
  //   // Return empty list if file doesn't exist
  //   return [];
  // }// END LOAD TASKS
  
  /// Add a single event



} // END TASK STORAGE