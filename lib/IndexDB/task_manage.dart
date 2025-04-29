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
  int anticipatedHours;
  int anticipatedMinutes; 
  String? status;
  
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
    required this.anticipatedHours,
    required this.anticipatedMinutes,
    required this.status
  }) : id = id ?? Uuid().v4(); // Generate a new UUID if not provided

// Helper method to convert TimeOfDay to string, This is used for JSON storage conversion
  static String timeOfDayToString(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  static String dateTimeToString(DateTime date){
    final month = date.month.toString();
    final year = date.year.toString();
    final day = date.day.toString();
    return '$year-$month-$day';

  }

  static TimeOfDay stringToTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  factory Task.fromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'],
    taskName: map['taskName'],
    taskCategory: map['taskCategory'],
    taskPriority: map['taskPriority'],
    startDate: DateTime.parse(map['startDate']),
    endDate: DateTime.parse(map['endDate']),
    startTime: stringToTimeOfDay(map['startTime']),
    endTime: stringToTimeOfDay(map['endTime']),
    anticipatedHours: map['anticipatedHours'],
    anticipatedMinutes: map['anticipatedMinutes'],
    status: map['status'],

  );
}
 
// Method to convert Task object to Map<String, dynamic>
   static Map<String, dynamic> taskToMap(Task taskToConvert) {
    return{
    'id': taskToConvert.id,
    'taskName': taskToConvert.taskName,
    'taskCategory': taskToConvert.taskCategory,
    'taskPriority': taskToConvert.taskPriority,
    'startDate': taskToConvert.startDate.toIso8601String(),//dateTimeToString(taskToConvert.startDate),
    'endDate': taskToConvert.endDate.toIso8601String(),//dateTimeToString(taskToConvert.endDate),
    'startTime': timeOfDayToString(taskToConvert.startTime),
    'endTime': timeOfDayToString(taskToConvert.endTime),
    'anticipatedHours': taskToConvert.anticipatedHours,
    'anticipatedMinutes': taskToConvert.anticipatedMinutes,
    'status': taskToConvert.status,
    };
  }


} // end of task class

class ManageTasks {

    static Future<void> saveTask(Map<String, dynamic> taskToSave) async {
    // Load the database file
    try {
      //get task ID
      final id = taskToSave['id'];
      //open DB at task ID location
      final idbFile = IdbFile(id);
      //create json formatted task string
      String jsonTask = jsonEncode(taskToSave);
      //write the json string task to the DB
      await idbFile.writeAsString(jsonTask);
    } 
    catch (e) {
      print('Save Task Error: $e');
    }
  }//end saveTasks


  static Future<List<Map<String, dynamic>>> loadTasks() async {
    // try loading the database file
    try {
      final rawTasks = await IdbFile.getAllTasks();
      final taskMapList = rawTasks.map((entry) {
        final rawJson = entry['contents'];
        return jsonDecode(rawJson) as Map<String, dynamic>;
      }).toList();

      return taskMapList;
    } 
    catch (e) { 
      print('Load Task Error: $e');
      return [];
    }
  } //end LoadTasks



  static Future<bool> deleteTask(String idOfTaskToDelete) async {
    try {
      // Open the IndexedDB file for the task
      final idbFile = IdbFile(idOfTaskToDelete);

      // Check if the file exists
      if (await idbFile.exists()) {
        // Delete the task file
        await idbFile.delete();

        //print("Task with ID $idOfTaskToDelete has been deleted.");
        return true;
      } else {
        //print("Task with ID $idOfTaskToDelete does not exist.");
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // May not need this function as in-line editing in tasks_screen 
  // in conjunction with the saveTask function appears to be functional
  static Future<bool> editTask(String idOfTaskToEdit) async {
    //open file
    final idbFile = IdbFile(idOfTaskToEdit);

    try {
      //locate task to edit
      if (await idbFile.exists()) {
        return true;

      } else {
        print('task not found: ID: $idOfTaskToEdit');
        return false;
      }

      return true;

    }

    catch (error) {
      print('Error: $error');
      return false;
    }
  }
}// end ManageTasks class

