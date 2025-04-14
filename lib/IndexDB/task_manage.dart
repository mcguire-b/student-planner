import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs
import '../IndexDB/idb_file.dart'; // Import your IdbFile class

// Task type object 
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
  
  //Constructor
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
  static String timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }
 
// Method to convert Task object to Map<String, dynamic>
   static Map<String, dynamic> taskToMap(Task taskToConvert) {
    return{
    'id': taskToConvert.id,
    'taskName': taskToConvert.taskName,
    'taskCategory': taskToConvert.taskCategory,
    'taskPriority': taskToConvert.taskPriority,
    'startDate': taskToConvert.startDate.toIso8601String(),
    'endDate': taskToConvert.endDate.toIso8601String(),
    'startTime': timeOfDayToString(taskToConvert.startTime),
    'endTime': timeOfDayToString(taskToConvert.endTime),
    'anticipatedTime': taskToConvert.anticipatedTime,
    };
  }
} // end of task class

class ManageTasks {
  
  static Future<void> saveTask(Map<String, dynamic> taskToSave) async {
    // Load the database file
    try {
      //load file
      final idbFile = IdbFile('/tasks/tasks_data.json');
      //on successful load
      if (await idbFile.exists()) {
        //TODO debug check to see if adding multiple tasks works with this code
        //convert the task to save into a json string
        String jsonTask = jsonEncode(taskToSave);
        //add the string to the task file
        idbFile.writeAsString(jsonTask);
      } 
      //on fail to load, may not need this with the try/catach
      else {
        //TODO else logic
      }
    } catch (e) {
      print('Error: $e');
    }
  }//end saveTasks

  static Future<List<Map<String, dynamic>>> loadTasks() async {
    // try loading the database file
    List<Map<String, dynamic>> taskMapList = []; 
    try {
      //load the file
      final idbFile = IdbFile('/tasks/tasks_data.json');
      if (await idbFile.exists()) {
        //TODO make this a loop capable of handling multiple tasks
        //read the file
        String tasksString = await idbFile.readAsString();
        //decode task from json into a map<String, dynamic>
        Map<String, dynamic> taskMap = jsonDecode(tasksString);
        //add the map to the list of task maps
        taskMapList.add(taskMap);
      } 
      else {
        //TODO else logic
      }
    } catch (e) { 
      print('Error: $e');
    }
    return taskMapList;
  } //end LoadTasks




  //TODO Delete Task function
  static Future<bool> deleteTask(String idOfTaskToDelete) async {
    try {
      //load the file
      final idbFile = IdbFile('taskRecords.txt');
      if (await idbFile.exists()) {
      } 
      else {
        //TODO else logic
      }
    } catch (e) { 
      print('Error: $e');
    }
    return false;
  }// end delete task




    //TODO Edit  Task function
  static Future<bool> editTask(String idOfTaskToEdit) async {
    try {
      //load the file
      final idbFile = IdbFile('taskRecords.txt');
      if (await idbFile.exists()) {
      } 
      else {
        //TODO else logic
      }
    } catch (e) { 
      print('Error: $e');
    }
    return false;
  }// end editTask




}// end ManageTasks class

