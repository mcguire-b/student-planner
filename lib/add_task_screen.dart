import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController taskController = TextEditingController();

  void submitTask() {
    if (taskController.text.isNotEmpty) {
      Navigator.pop(context, taskController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: taskController,
              decoration: InputDecoration(labelText: 'Enter task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
