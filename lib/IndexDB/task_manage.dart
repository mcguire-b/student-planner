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
    };
  }


} // end of task class

class ManageTasks {
  
  // static Future<void> saveTask(Map<String, dynamic> taskToSave) async {
  //   print("in saveTask method, taskToSave is: $taskToSave");
  //   // Load the database file
  //   try {
  //     //load file
  //     final idbFile = IdbFile('TasksDB');
  //     bool exists = await idbFile.exists();
  //     print("save task does it exist? $exists");
  //     //on successful load
  //     if (await idbFile.exists()) {
  //       //TODO debug check to see if adding multiple tasks works with this code
  //       //convert the task to save into a json string
  //       String jsonTask = jsonEncode(taskToSave);
  //       //add the string to the task file
  //       idbFile.writeAsString(jsonTask);
  //     } 
  //     //on fail to load, may not need this with the try/catach
  //     else {
  //       print("did not load db file in saveTasks method");
  //       //TODO else logic
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }//end saveTasks


  

    static Future<void> saveTask(Map<String, dynamic> taskToSave) async {
    print("in saveTask method, taskToSave is: $taskToSave");
    // Load the database file
    try {
      //get task ID
      final id = taskToSave['id'];
      //open DB at task ID location
      final idbFile = IdbFile(id);
      //create json formatted task string
      String jsonTask = jsonEncode(taskToSave);

      print("saveTask Method: JsonTask String: $jsonTask");

      //write the json string task to the DB
      await idbFile.writeAsString(jsonTask);
      print("SaveTask Method: Task saved under key: $id");

    } 
    catch (e) {
      print('Save Task Error: $e');
    }
  }//end saveTasks


  //changes 
//



  // static Future<List<Map<String, dynamic>>> loadTasks() async {
  //   // try loading the database file
  //   List<Map<String, dynamic>> taskMapList = []; 
  //   try {
  //     //load the file
  //     final idbFile = IdbFile("TasksDB");
  //     if (await idbFile.exists()) {
  //       print("If Statement: loaded db file in loadTasks method");
  //       //TODO make this a loop capable of handling multiple tasks
  //       //read the file
  //       String tasksString = await idbFile.readAsString();
  //       print('tasksString (In loadTask method), $tasksString');
  //       //decode task from json into a map<String, dynamic>
  //       Map<String, dynamic> taskMap = jsonDecode(tasksString);
  //       print('taskMap (In loadTask method), $taskMap');
  //       //add the map to the list of task maps
  //       taskMapList.add(taskMap);
  //     } 
  //     else {
  //       print("did not load db file in loadTasks method");
  //       //TODO else logic may not need an else due to try and catch?
  //     }
  //   } catch (e) { 
  //     print('Error: $e');
  //   }
  //   print('TaskMapList (In loadTask method), $taskMapList');
  //   return taskMapList;
  // } //end LoadTasks


  static Future<List<Map<String, dynamic>>> loadTasks() async {
    // try loading the database file
    //List<Map<String, dynamic>> taskMapList = []; 
    try {
      final rawTasks = await IdbFile.getAllTasks();
      final taskMapList = rawTasks.map((entry) {
        final rawJson = entry['contents'];
        return jsonDecode(rawJson) as Map<String, dynamic>;
      }).toList();

      print("loadTasks Method: taskMapList: $taskMapList");

      return taskMapList;
    } 
    catch (e) { 
      print('Load Task Error: $e');
      return [];
    }
    //print('TaskMapList (In loadTask method), $taskMapList');
    //return taskMapList;
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




    //TODO Edit Task function
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

