import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<String> tasks = []; // List to store tasks
  TextEditingController taskController = TextEditingController(); // Controller for task input field
  
  // Function to add a task to the list
  void addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
      });
      taskController.clear();
    }
  }

  void navigateToAddTaskScreen() async {
    final newTask = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null && newTask.isNotEmpty) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddTaskScreen,
          ),
        ],
      ),
      body: tasks.isEmpty 
        ? Center( // Show this message when there are no tasks
            child: Text(
              'You currently have no tasks',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
            : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(tasks[index]),
                      ),
                      // delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.purple),
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
