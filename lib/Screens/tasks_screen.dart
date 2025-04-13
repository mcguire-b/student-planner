import 'package:flutter/material.dart';
import 'package:planner/Screens/home_screen.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:planner/file_manager.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> tasks = [];

  List<bool> isEditing = []; // Corresponding edit states TO DO REMOVE FALSE

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> loadedTasks = await FileManager.readTaskData();
    setState(() {
      tasks = List.from(loadedTasks);
      isEditing = List.filled(tasks.length, false);
    });
  }

  // Filtering Variables
  String? _selectedCategory;
  String? _selectedPriority;

  // Sorting Variables
  bool _sortByPriorityHighToLow = true;
  bool _sortByCategoryAscending = true;
  bool _sortByTimeAscending = true;

  List<String> categories = ['School', 'Work', 'Personal'];
  List<String> priorities = ['High', 'Medium', 'Low'];

  void navigateToAddTaskScreen() async {
    final newTask = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );

    if (newTask != null) {
      await FileManager.writeTaskData(newTask);
      _loadTasks(); // Reload tasks, which resets `isEditing`
    }
  }

  void _sortTasksByPriority() {
    setState(() {
      tasks.sort((a, b) {
        List<String> order =
            _sortByPriorityHighToLow
                ? ['High', 'Medium', 'Low']
                : ['Low', 'Medium', 'High'];
        return order
            .indexOf(a['priority'])
            .compareTo(order.indexOf(b['priority']));
      });
      _sortByPriorityHighToLow = !_sortByPriorityHighToLow;
    });
  }

  void _sortTasksByCategory() {
    setState(() {
      tasks.sort((a, b) {
        List<String> order =
            _sortByCategoryAscending
                ? ['School', 'Work', 'Personal']
                : ['Personal', 'Work', 'School'];
        return order
            .indexOf(a['category'])
            .compareTo(order.indexOf(b['category']));
      });
      _sortByCategoryAscending = !_sortByCategoryAscending;
    });
  }

  void _sortTasksByAnticipatedTime() {
  setState(() {
    tasks.sort((a, b) {
      // Parse the hours and minutes for each task
      int hoursA = int.tryParse(a['anticipatedHours'] ?? '0') ?? 0;
      int minutesA = int.tryParse(a['anticipatedMinutes'] ?? '0') ?? 0;
      int totalMinutesA = hoursA * 60 + minutesA; // Total minutes for task A

      int hoursB = int.tryParse(b['anticipatedHours'] ?? '0') ?? 0;
      int minutesB = int.tryParse(b['anticipatedMinutes'] ?? '0') ?? 0;
      int totalMinutesB = hoursB * 60 + minutesB; // Total minutes for task B

      return _sortByTimeAscending
          ? totalMinutesA.compareTo(totalMinutesB)
          : totalMinutesB.compareTo(totalMinutesA);
    });
    _sortByTimeAscending = !_sortByTimeAscending;
  });
}

  void _sortTasksByTime() {
    setState(() {
      tasks.sort((a, b) {
        DateTime dateTimeA = DateFormat(
          'yyyy-MM-dd hh:mm a',
        ).parse('${a['startDate']} ${a['startTime']}');
        DateTime dateTimeB = DateFormat(
          'yyyy-MM-dd hh:mm a',
        ).parse('${b['startDate']} ${b['startTime']}');

        return _sortByTimeAscending
            ? dateTimeA.compareTo(dateTimeB)
            : dateTimeB.compareTo(dateTimeA);
      });
      _sortByTimeAscending = !_sortByTimeAscending;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter the task list based on selected category and priority
    final filteredTasks =
        tasks.where((task) {
          final matchesCategory =
              _selectedCategory == null ||
              task['category'] == _selectedCategory;
          final matchesPriority =
              _selectedPriority == null ||
              task['priority'] == _selectedPriority;
          return matchesCategory && matchesPriority;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(179, 254, 175, 255),
        title: Center(child: Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        actions: [
          // Filter Dropdown Button
          PopupMenuButton<String>(
            icon: Icon(Icons.filter_list),
            onSelected: (String? selectedFilter) {
              setState(() {
                if (categories.contains(selectedFilter) ||
                    selectedFilter == 'All Categories') {
                  _selectedCategory =
                      selectedFilter == 'All Categories'
                          ? null
                          : selectedFilter;
                } else if (priorities.contains(selectedFilter) ||
                    selectedFilter == 'All Priorities') {
                  _selectedPriority =
                      selectedFilter == 'All Priorities'
                          ? null
                          : selectedFilter;
                }
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'All Categories',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("All Categories"),
                        _selectedCategory == null
                            ? Icon(Icons.check, color: Colors.purple)
                            : SizedBox(),
                      ],
                    ),
                  ),
                  ...categories.map(
                    (category) => PopupMenuItem(
                      value: category,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(category),
                          _selectedCategory == category
                              ? Icon(Icons.check, color: Colors.purple)
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuDivider(), // Divider for clarity
                  PopupMenuItem(
                    value: 'All Priorities',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("All Priorities"),
                        _selectedPriority == null
                            ? Icon(Icons.check, color: Colors.purple)
                            : SizedBox(),
                      ],
                    ),
                  ),
                  ...priorities.map(
                    (priority) => PopupMenuItem(
                      value: priority,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(priority),
                          _selectedPriority == priority
                              ? Icon(Icons.check, color: Colors.purple)
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
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
              } else if (value == 'Time') {
                _sortTasksByTime();
              } else if (value == 'Anticipated Time') {
                _sortTasksByAnticipatedTime();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'Priority',
                    child: Text(
                      "Sort by Priority (${_sortByPriorityHighToLow ? 'High → Low' : 'Low → High'})",
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Category',
                    child: Text(
                      "Sort by Category (${_sortByCategoryAscending ? 'A → Z' : 'Z → A'})",
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Time',
                    child: Text(
                      "Sort by Time (${_sortByTimeAscending ? 'Earliest → Latest' : 'Latest → Earliest'})",
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Anticipated Time',
                    child: Text(
                      "Sort by Anticipated Time (${_sortByTimeAscending ? 'Shortest → Longest' : 'Longest → Shortest'})",
                    ),
                  ),
                ],
          ),

          IconButton(icon: Icon(Icons.add), onPressed: navigateToAddTaskScreen),
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
                    TextEditingController startDateController =
                        TextEditingController(text: task['startDate'] ?? '');
                    TextEditingController endDateController =
                        TextEditingController(text: task['endDate'] ?? '');
                    TextEditingController priorityController =
                        TextEditingController(text: task['priority']);
                    TextEditingController anticipatedHoursController =
                        TextEditingController(
                          text: task['anticipatedHours'].toString(),
                        );
                    TextEditingController anticipatedMinutesController =
                        TextEditingController(
                          text: task['anticipatedMinutes'].toString(),
                        );

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
                              Expanded(
                                child:
                                    editing
                                        ? TextField(controller: nameController)
                                        : Flexible(
                                          child: Text(
                                            task['name'],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                2, // Allows multi-line if necessary
                                            softWrap: true,
                                          ),
                                        ),
                              ),

                              // Buttons (Right side)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (editing) {
                                        setState(() {
                                          tasks[index] = {
                                            'name': nameController.text,
                                            'category': categoryController.text,
                                            'startDate':
                                                startDateController.text,
                                            'endDate': endDateController.text,
                                            'startTime':
                                                startTimeController.text,
                                            'endTime': endTimeController.text,
                                            'priority': priorityController.text,
                                            'anticipatedHours':
                                                int.tryParse(
                                                  anticipatedHoursController
                                                      .text,
                                                ) ??
                                                0,
                                            'anticipatedMinutes':
                                                int.tryParse(
                                                  anticipatedMinutesController
                                                      .text,
                                                ) ??
                                                0,
                                            'status':
                                                tasks[index]['status'] ??
                                                'to-do',
                                          };
                                        });

                                        await FileManager.writeUpdatedTasks(
                                          tasks,
                                        );
                                        _loadTasks();
                                      }

                                      setState(() {
                                        isEditing[index] = !editing;
                                      });
                                    },

                                    child: Text(editing ? 'Save' : 'Edit'),
                                  ),
                                  SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        // Ensure tasks and isEditing are modifiable
                                        tasks = List.from(tasks);
                                        isEditing = List.from(isEditing);

                                        if (index >= 0 &&
                                            index < tasks.length) {
                                          tasks.removeAt(index);
                                          isEditing.removeAt(index);
                                        }
                                      });

                                      await FileManager.writeUpdatedTasks(
                                        tasks,
                                      );
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
                                    Text(
                                      'Category:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    editing
                                        ? TextField(
                                          controller: categoryController,
                                        )
                                        : Text(task['category']),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Duration:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    editing
                                        ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        startDateController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Start Date',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        startTimeController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Start Time',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        endDateController,
                                                    decoration: InputDecoration(
                                                      labelText: 'End Date',
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Expanded(
                                                  child: TextField(
                                                    controller:
                                                        endTimeController,
                                                    decoration: InputDecoration(
                                                      labelText: 'End Time',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                        : Text(
                                          '${task['startTime']} ${task['startDate']} - ${task['endTime']} ${task['endDate']}',
                                        ),
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
                                    Text(
                                      'Priority:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    editing
                                        ? TextField(
                                            controller: priorityController,
                                          )
                                        : Text(task['priority']),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Anticipated Time:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    editing
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: TextField(
                                                  controller: anticipatedHoursController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(labelText: 'Hours'),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: TextField(
                                                  controller: anticipatedMinutesController,
                                                  keyboardType: TextInputType.number,
                                                  decoration: InputDecoration(labelText: 'Minutes'),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            // Check if anticipatedHours and anticipatedMinutes are not empty and display them
                                            task['anticipatedHours'] != null && task['anticipatedMinutes'] != null
                                                ? '${task['anticipatedHours']}h ${task['anticipatedMinutes']}m'
                                                : '0h 0m', // Fallback value if they're not available
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Status Dropdown
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    editing
                                        ? DropdownButton<String>(
                                          value: task['status'] ?? 'to-do',
                                          items:
                                              [
                                                    'to-do',
                                                    'in progress',
                                                    'completed',
                                                  ]
                                                  .map(
                                                    (status) =>
                                                        DropdownMenuItem(
                                                          value: status,
                                                          child: Text(status),
                                                        ),
                                                  )
                                                  .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              tasks[index]['status'] = value!;
                                            });
                                          },
                                        )
                                        : Text(task['status'] ?? 'to-do'),
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
      floatingActionButton: PomoButton(
        //TODO Oooooooooooooooooooooooooooooooooooooo
        menuItems: [
          PomoMenu(
            value: 'nav: task page',
            label: 'Quick Add Task',
            icon: Icons.create_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTaskScreen()),
              );
            },
          ),
          PomoMenu(
            value: 'nav: home',
            label: 'Goto: Home Page',
            icon: Icons.arrow_forward_sharp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
