import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';
import 'home_screen.dart';
//import '../IndexDB/task.dart';
import '../IndexDB/task_manage.dart';



class AddTaskScreen extends StatefulWidget {
  //class field for database

  
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController anticipatedTimeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String taskCategory = 'Work'; // Default category
  String taskPriority = 'Medium'; // Default priority
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  DateTime? startDate;
  DateTime? endDate;

  // Function to pick a time
  Future<void> pickTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  // Function to pick a date
  Future<void> pickDate(bool isStartDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";

        if (isStartDate) {
          startDate = pickedDate;
          startDateController.text = formattedDate;
        } else {
          endDate = pickedDate;
          endDateController.text = formattedDate;
        }
      });
    }
  }

    // Index DB implementation of submitTask function
  void submitTask() async {
    // Check data fields are not empty 
    if (nameController.text.isNotEmpty &&
        startTime != null &&
        endTime != null &&
        startDate != null &&
        endDate != null &&
        anticipatedTimeController.text.isNotEmpty) {
      
      // Map user input to new task object
      final newTask = Task(
          taskName: nameController.text, 
          taskCategory: taskCategory, 
          taskPriority: taskPriority, 
          startDate: startDate!, 
          endDate: endDate!, 
          startTime: startTime!, 
          endTime: endTime!, 
          anticipatedTime: int.parse(anticipatedTimeController.text)
      );
      try {
      // //for debug print statements TODO remove from code once its all working
      // String taskID = newTask.idNum;  
      // //debug print statements
      // print("Saving task: ${newTask.taskName}, Start: ${newTask.startDate}, AntTime: ${newTask.anticipatedTime}"); 
      // print("End: ${newTask.endDate}, STime: ${newTask.startTime}, ETime: ${newTask.endTime}");
      // print("Cat: ${newTask.taskCategory}, Prior: ${newTask.taskPriority}, ID: $taskID");

      // TODO Save task to Indexed DB
      //convert a task into a Task map
      Map<String, dynamic> mapOfTask = Task.taskToMap(newTask);
      //save task map to database file
      await ManageTasks.saveTask(mapOfTask); 


      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task saved successfully!')),
      ); 
      // Reset all form fields
      setState(() {
        nameController.clear();
        anticipatedTimeController.clear();
        startDateController.clear();
        endDateController.clear();
        taskCategory = 'Work'; // Reset to default
        taskPriority = 'Medium'; // Reset to default
        startTime = null;
        endTime = null;
        startDate = null;
        endDate = null;
      });
      // Optionally return to previous screen
      Navigator.pop(context);
    } catch (e) {
      // Show error message if something went wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: ${e.toString()}')),
      );
    }
    }// end if statement
    else {
      // Show message if form is incomplete
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    } //end else
  }//end submitTask()

    
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 244, 224, 255),
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),

              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: taskCategory,
                decoration: InputDecoration(labelText: 'Event Category'),
                items: ['Work', 'Personal', 'School', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    taskCategory = value!;
                  });
                },
              ),

              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: taskPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    taskPriority = value!;
                  });
                },
              ),

              SizedBox(height: 10),

              // Start Date Picker
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => pickDate(true),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: startDateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // End Date Picker
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => pickDate(false),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: endDateController,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Start Time Picker
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => pickTime(true),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: startTime != null ? startTime!.format(context) : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // End Time Picker
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => pickTime(false),
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: endTime != null ? endTime!.format(context) : '',
                      ),
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        suffixIcon: Icon(Icons.access_time),
                      ),
                      readOnly: true,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Anticipated Time Field
              TextField(
                controller: anticipatedTimeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Anticipated Time (in minutes)'),
              ),

              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: submitTask,
                  child: Text('Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: PomoButton(
            menuItems: [
              PomoMenu(
                value: 'Nav: Add task page', 
                label: 'Quick Add Task',
                icon: Icons.create_outlined, 
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskScreen())
                  );
                },
              ),
              PomoMenu(
                value: 'test 2', label: 'Goto: Home Page',
                icon: Icons.arrow_forward_sharp,
                onTap: () {
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              )
            ],
          ),
    );
  }
}