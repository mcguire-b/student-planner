import 'package:flutter/material.dart';
import 'package:planner/IndexDB/task_manage.dart';
import 'package:planner/Screens/home_screen.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';


class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  List<Task> tasks = [];

  List<bool> isEditing = []; // Corresponding edit states

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> loadedTasks = await ManageTasks.loadTasks();
    setState(() {
      tasks = loadedTasks.map<Task>((map) => Task.fromMap(map)).toList();
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
      _loadTasks(); // Reload tasks, which resets `isEditing`
    }
    _loadTasks();
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
                ? ['Personal', 'School', 'Work']
                : ['Work', 'School', 'Personal'];
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
        int aTotalMinutes = a.anticipatedHours * 60 + a.anticipatedMinutes;
        int bTotalMinutes = b.anticipatedHours * 60 + b.anticipatedMinutes;

        return _sortByTimeAscending
            ? aTotalMinutes.compareTo(bTotalMinutes)
            : bTotalMinutes.compareTo(aTotalMinutes);
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
        backgroundColor: const Color.fromARGB(179, 254, 175, 255),
        title: Center(
          child: Text(
            'Tasks',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20, // Optional: Adjust font size if needed
            ),
          ),
        ),
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
                child: 
                ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    final bool editing = isEditing[index];

                    // Controllers for inline editing
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
                    TextEditingController anticipatedHoursController =
                        TextEditingController(text: task.anticipatedHours.toString());
                    TextEditingController anticipatedMinutesController =
                        TextEditingController(text: task.anticipatedMinutes.toString());

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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Task Title (left side)
                              Expanded(
                                child: editing
                                    ? TextField(controller: nameController)
                                    : Text(
                                        task.taskName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                      ),
                              ),
                              // Buttons (top-right side)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.purple),
                                    tooltip: 'Edit Task',
                                    onPressed: () {
                                      setState(() {
                                        isEditing[index] = true;
                                        nameController.text = task.taskName;
                                        categoryController.text = task.taskCategory;
                                        priorityController.text = task.taskPriority;
                                        anticipatedHoursController.text =
                                            task.anticipatedHours.toString();
                                        anticipatedMinutesController.text =
                                            task.anticipatedMinutes.toString();
                                        startDateController.text = task.startDate.toString();
                                        startTimeController.text = task.startTime.toString();
                                        endDateController.text = task.endDate.toString();
                                        endTimeController.text = task.endTime.toString();
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.purple),
                                    tooltip: 'Delete Task',
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete Task'),
                                          content: Text('Are you sure you want to delete this task?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        // Call ManageTasks.deleteTask instead of FileManager.deleteTask
                                        bool success = await ManageTasks.deleteTask(task.id); // Your delete logic

                                        if (success) {
                                          // Refresh the task list if the deletion was successful
                                          _loadTasks();
                                        } else {
                                          // Handle failure (e.g., show an error message)
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Failed to delete task')),
                                          );
                                        }
                                      }
                                    },
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
                                      ?DropdownButtonFormField<String>(
                                        value: task.taskCategory,
                                        decoration: InputDecoration(labelText: 'Category'),
                                        items: ['Work', 'Personal', 'School', 'Other']
                                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            task.taskCategory = value!;
                                          });
                                          ManageTasks.saveTask(Task.taskToMap(task)); 
                                        },
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
                                          '${DateFormat('M-dd-yyyy').format(task.startDate)} ${task.startTime.format(context)} - '
                                          '${DateFormat('M-dd-yyyy').format(task.endDate)} ${task.endTime.format(context)}',
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4),

                          // Priority and Anticipated Time
                          // TODO priority controller always active, not just when editing
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
                                    ?DropdownButtonFormField<String>(
                                      value: task.taskPriority,
                                      decoration: InputDecoration(labelText: 'Priority'),
                                      items: ['High', 'Medium', 'Low']
                                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          task.taskPriority = value!;
                                        });
                                        ManageTasks.saveTask(Task.taskToMap(task)); 
                                      },
                                    )
                                    : Text(task.taskPriority ?? 'Medium'),
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
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
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
                                                            '${task.anticipatedHours} hr ${task.anticipatedMinutes} min',
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            '${task.anticipatedHours} hr ${task.anticipatedMinutes} min',
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          //Status Dropdown
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
                                      ?DropdownButtonFormField<String>(
                                        value: task.status,
                                        decoration: InputDecoration(labelText: 'Status'),
                                        items: ['To-Do', 'In Progress', 'Completed']
                                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            task.status = value!;
                                          });
                                          ManageTasks.saveTask(Task.taskToMap(task)); 
                                        },
                                    )
                                    : Text(task.status ?? 'To-Do'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Save and Cancel buttons when editing (Change: Added these buttons)
                          if (editing) ...[
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditing[index] = false; // Change: Stop editing mode
                                      // Revert changes if canceled (Change: Reset fields to original task values)
                                      nameController.text = task.taskName;
                                      priorityController.text = task.taskPriority;
                                      categoryController.text = task.taskCategory;
                                      anticipatedHoursController.text = task.anticipatedHours.toString();
                                      anticipatedMinutesController.text = task.anticipatedMinutes.toString();
                                    });
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      // TODO finish all edit options
                                      // Save changes (Change: Save changes to task fields)
                                      task.taskName = nameController.text;
                                      task.taskCategory = categoryController.text;
                                      task.anticipatedHours = int.parse(anticipatedHoursController.text);
                                      task.anticipatedMinutes = int.parse(anticipatedMinutesController.text);
                                      task.status = task.status;
                                      isEditing[index] = false; // Change: Stop editing mode
                                    });
                                    // Optionally, save the updated task in the database (Change: Update task in database)
                                    ManageTasks.saveTask(Task.taskToMap(task));
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            ),
                          ],
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
