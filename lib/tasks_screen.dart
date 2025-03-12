import 'package:flutter/material.dart';
import 'add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [
    // Sample task for testing
    {
      'name': 'Finish Homework',
      'category': 'School',
      'startTime': '3:00 PM',
      'endTime': '5:00 PM',
      'priority': 'High',
      'anticipatedTime': 120,
    },
    {
      'name': 'Project Meeting',
      'category': 'Work',
      'startTime': '10:00 AM',
      'endTime': '11:30 AM',
      'priority': 'Medium',
      'anticipatedTime': 90,
    },
    {
      'name': 'Grocery Shopping',
      'category': 'Personal',
      'startTime': '6:00 PM',
      'endTime': '7:00 PM',
      'priority': 'Low',
      'anticipatedTime': 60,
    }
  ];

  List<bool> isEditing = [false, false, false]; // Corresponding edit states TO DO REMOVE FALSE

  // Filtering Variables
  String? _selectedCategory;
  String? _selectedPriority;

  // Sorting Variables
  bool _sortByPriorityHighToLow = true;
  bool _sortByCategoryAscending = true;

  List<String> categories = ['School', 'Work', 'Personal'];
  List<String> priorities = ['High', 'Medium', 'Low'];

  void navigateToAddTaskScreen() async {
    final newTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
        isEditing.add(false);
      });
    }
  }

  void _sortTasksByPriority() {
    setState(() {
      tasks.sort((a, b) {
        List<String> order = _sortByPriorityHighToLow ? ['High', 'Medium', 'Low'] : ['Low', 'Medium', 'High'];
        return order.indexOf(a['priority']).compareTo(order.indexOf(b['priority']));
      });
      _sortByPriorityHighToLow = !_sortByPriorityHighToLow;
    });
  }

  void _sortTasksByCategory() {
    setState(() {
      tasks.sort((a, b) => _sortByCategoryAscending
          ? a['category'].compareTo(b['category'])
          : b['category'].compareTo(a['category']));
      _sortByCategoryAscending = !_sortByCategoryAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the task list based on selected category and priority
    final filteredTasks = tasks.where((task) {
      final matchesCategory = _selectedCategory == null || task['category'] == _selectedCategory;
      final matchesPriority = _selectedPriority == null || task['priority'] == _selectedPriority;
      return matchesCategory && matchesPriority;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Tasks'),
        ),
        actions: [
          // Filter Dropdown Button
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String? selectedFilter) {
              setState(() {
                if (categories.contains(selectedFilter) || selectedFilter == null) {
                  _selectedCategory = selectedFilter;
                } else if (priorities.contains(selectedFilter) || selectedFilter == 'All Priorities') {
                  _selectedPriority = selectedFilter == 'All Priorities' ? null : selectedFilter;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Categories"),
                    _selectedCategory == null ? Icon(Icons.check, color: Colors.blue) : SizedBox(),
                  ],
                ),
              ),
              ...categories.map((category) => PopupMenuItem(
                    value: category,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(category),
                        _selectedCategory == category ? Icon(Icons.check, color: Colors.blue) : SizedBox(),
                      ],
                    ),
                  )),
              PopupMenuDivider(), // Divider for clarity
              PopupMenuItem(
                value: 'All Priorities',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("All Priorities"),
                    _selectedPriority == null ? Icon(Icons.check, color: Colors.blue) : SizedBox(),
                  ],
                ),
              ),
              ...priorities.map((priority) => PopupMenuItem(
                    value: priority,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(priority),
                        _selectedPriority == priority ? Icon(Icons.check, color: Colors.blue) : SizedBox(),
                      ],
                    ),
                  )),
            ],
          ),


          // Sort Button
          PopupMenuButton<String>(
            icon: Icon(Icons.swap_vert),
            onSelected: (String value) {
              if (value == 'Priority') {
                _sortTasksByPriority();
              } else if (value == 'Category') {
                _sortTasksByCategory();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Priority', child: Text("Sort by Priority (${_sortByPriorityHighToLow ? 'High → Low' : 'Low → High'})")),
              PopupMenuItem(value: 'Category', child: Text("Sort by Category (${_sortByCategoryAscending ? 'A → Z' : 'Z → A'})")),
            ],
          ),

          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddTaskScreen,
          ),
        ],
      ),
      body: Column(
        children: [
          filteredTasks.isEmpty
              ? Expanded(
                  child: Center(
                    child: Text(
                      'No tasks found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
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
                                      child: Text(editing ? 'Save' : 'Edit'),
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
