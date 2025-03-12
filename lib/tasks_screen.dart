import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [
    // Hardcoded task for testing
    {
      'name': 'Finish Homework',
      'category': 'School',
      'startTime': '3:00 PM',
      'endTime': '5:00 PM',
      'priority': 'High',
      'anticipatedTime': 120,
    }
  ];

  List<bool> isEditing = [false]; // Hardcoded corresponding edit state

  void navigateToAddTaskScreen() async {
    final newTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        isEditing.add(false); // Default to non-edit mode
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
      body: Column(
        children: [
          tasks.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'You currently have no tasks',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final bool editing = isEditing[index];

                      // Controllers for inline editing
                      TextEditingController nameController =
                          TextEditingController(text: task['name']);
                      TextEditingController categoryController =
                          TextEditingController(text: task['category']);
                      TextEditingController startTimeController =
                          TextEditingController(text: task['startTime']);
                      TextEditingController endTimeController =
                          TextEditingController(text: task['endTime']);
                      TextEditingController priorityController =
                          TextEditingController(text: task['priority']);
                      TextEditingController anticipatedTimeController =
                          TextEditingController(text: task['anticipatedTime'].toString());

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 244, 224, 255),
                          border: Border.all(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with Task Title and Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Task Title (Left side)
                                editing
                                    ? Expanded(child: TextField(controller: nameController))
                                    : Text(
                                        task['name'],
                                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                      ),

                                // Buttons (Right side)
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (editing) {
                                            tasks[index] = {
                                              'name': nameController.text,
                                              'category': categoryController.text,
                                              'startTime': startTimeController.text,
                                              'endTime': endTimeController.text,
                                              'priority': priorityController.text,
                                              'anticipatedTime': int.tryParse(anticipatedTimeController.text) ?? 0,
                                            };
                                          }
                                          isEditing[index] = !editing;
                                        });
                                      },
                                      child: Text(editing ? 'Save' : 'Edit'), // Edit button first now
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          tasks.removeAt(index);
                                          isEditing.removeAt(index);
                                        });
                                      },
                                      child: Text('Remove'),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 8),

                            // Category and Duration
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      editing
                                          ? TextField(controller: categoryController)
                                          : Text(task['category']),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Duration:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      editing
                                          ? Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(controller: startTimeController),
                                                ),
                                                Text(' - '),
                                                Expanded(
                                                  child: TextField(controller: endTimeController),
                                                ),
                                              ],
                                            )
                                          : Text('${task['startTime']} - ${task['endTime']}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),

                            // Priority and Anticipated Time
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Priority:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      editing
                                          ? TextField(controller: priorityController)
                                          : Text(task['priority']),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Anticipated Time:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      editing
                                          ? TextField(controller: anticipatedTimeController)
                                          : Text('${task['anticipatedTime']} min'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
