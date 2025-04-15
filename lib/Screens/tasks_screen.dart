import 'package:flutter/material.dart';
import 'package:planner/IndexDB/task_manage.dart';
import 'package:planner/Screens/home_screen.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';
import 'package:planner/file_manager.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';
//import '../IndexDB/task.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  //List<Map<String, dynamic>> tasks = [];
  List<Task> tasks = [];

  List<bool> isEditing = []; // Corresponding edit states TODO REMOVE FALSE

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> loadedTasks = await ManageTasks.loadTasks();
    setState(() {
      //tasks = loadedTasks.map((map) => Task.fromMap(map)).toList();
      tasks = loadedTasks.map<Task>((map) => Task.fromMap(map)).toList();
      print('Task Screen loaded Tasks $loadedTasks');
      print('Task Screen: tasks: $tasks');
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
        List<String> order =_sortByPriorityHighToLow
                ? ['High', 'Medium', 'Low']
                : ['Low', 'Medium', 'High'];
        return order
            .indexOf(a.taskPriority)
            .compareTo(order.indexOf(b.taskPriority));
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
            .indexOf(a.taskCategory)
            .compareTo(order.indexOf(b.taskCategory));
      });
      _sortByCategoryAscending = !_sortByCategoryAscending;
    });
  }

  void _sortTasksByAnticipatedTime() {
    setState(() {
      tasks.sort((a, b) {
        return _sortByTimeAscending
            ? a.anticipatedTime.compareTo(b.anticipatedTime)
            : b.anticipatedTime.compareTo(a.anticipatedTime);
      });
      _sortByTimeAscending = !_sortByTimeAscending;
    });
  }

  void _sortTasksByTime() {
    setState(() {
      tasks.sort((a, b) {
        DateTime dateTimeA = DateFormat(
          'yyyy-MM-dd hh:mm a',
        ).parse('${a.startDate} ${a.startTime}');
        DateTime dateTimeB = DateFormat(
          'yyyy-MM-dd hh:mm a',
        ).parse('${b.startDate} ${b.startTime}');

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
              task.taskCategory == _selectedCategory;
          final matchesPriority =
              _selectedPriority == null ||
              task.taskPriority == _selectedPriority;
          return matchesCategory && matchesPriority;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tasks')),
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
                    //TODO .toString() might not work here but, 
                    //i need to clear the error to test other things
                    TextEditingController nameController =
                        TextEditingController(text: task.taskName);
                    TextEditingController categoryController =
                        TextEditingController(text: task.taskCategory);
                    TextEditingController startTimeController =
                        TextEditingController(text: task.startTime.toString());
                    TextEditingController endTimeController =
                        TextEditingController(text: task.endTime.toString());
                    TextEditingController startDateController =
                        TextEditingController(text: task.startDate.toString());
                    TextEditingController endDateController =
                        TextEditingController(text: task.endDate.toString());
                    TextEditingController priorityController =
                        TextEditingController(text: task.taskPriority);
                    TextEditingController anticipatedTimeController =
                        TextEditingController(
                          text: task.anticipatedTime.toString(),
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
                          //Row with Task Title and Buttons
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
                                            task.taskName,
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
                              //TODO Fix whatever this function is.....
                              // Buttons (Right side)
                            //   Row(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: [
                            //       ElevatedButton(
                            //         onPressed: () async {
                            //           if (editing) {
                            //             setState(() {
                            //               tasks[index] = {
                            //                 'name': nameController.text,
                            //                 'category': categoryController.text,
                            //                 'startDate':
                            //                     startDateController.text,
                            //                 'endDate': endDateController.text,
                            //                 'startTime':
                            //                     startTimeController.text,
                            //                 'endTime': endTimeController.text,
                            //                 'priority': priorityController.text,
                            //                 'anticipatedTime':
                            //                     int.tryParse(
                            //                       anticipatedTimeController
                            //                           .text,
                            //                     ) ??
                            //                     0,
                            //                 'status':
                            //                     tasks[index]['status'] ??
                            //                     'to-do',
                            //               };
                            //             });

                            //             await FileManager.writeUpdatedTasks(
                            //               tasks,
                            //             );
                            //             _loadTasks();
                            //           }

                            //           setState(() {
                            //             isEditing[index] = !editing;
                            //           });
                            //         },

                            //         child: Text(editing ? 'Save' : 'Edit'),
                            //       ),
                            //       SizedBox(width: 8),
                            //       ElevatedButton(
                            //         onPressed: () async {
                            //           setState(() {
                            //             // Ensure tasks and isEditing are modifiable
                            //             tasks = List.from(tasks);
                            //             isEditing = List.from(isEditing);

                            //             if (index >= 0 &&
                            //                 index < tasks.length) {
                            //               tasks.removeAt(index);
                            //               isEditing.removeAt(index);
                            //             }
                            //           });

                            //           await FileManager.writeUpdatedTasks(
                            //             tasks,
                            //           );
                            //         },
                            //         child: Text('Remove'),
                            //       ),
                            //     ],
                            //   ),
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
                                        : Text(task.taskCategory),
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
                                          '${task.startTime} ${task.startDate} - ${task.endTime} ${task.endDate}',
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
                                        : Text(task.taskPriority),
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
                                        ? TextField(
                                          controller: anticipatedTimeController,
                                        )
                                        : Text(
                                          '${task.anticipatedTime} min',
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Status Dropdown
                          //TODO fix this later
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Text(
                          //             'Status:',
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           editing
                          //               ? DropdownButton<String>(
                          //                 value: task['status'] ?? 'to-do',
                          //                 items:
                          //                     [
                          //                           'to-do',
                          //                           'in progress',
                          //                           'completed',
                          //                         ]
                          //                         .map(
                          //                           (status) =>
                          //                               DropdownMenuItem(
                          //                                 value: status,
                          //                                 child: Text(status),
                          //                               ),
                          //                         )
                          //                         .toList(),
                          //                 onChanged: (value) {
                          //                   setState(() {
                          //                     tasks[index]['status'] = value!;
                          //                   });
                          //                 },
                          //               )
                          //               : Text(task['status'] ?? 'to-do'),
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
      floatingActionButton: PomoButton(
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
