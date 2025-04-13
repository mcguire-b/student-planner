import 'package:flutter/material.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';
import 'home_screen.dart';
import 'package:planner/file_manager.dart';


class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController anticipatedHoursController = TextEditingController();
  final TextEditingController anticipatedMinutesController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String category = 'Work'; // Default category
  String priority = 'Medium'; // Default priority
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

        // Calculate anticipated time after both are picked
        if (startTime != null && endTime != null) {
          calculateAnticipatedTime();
        }
      });
    }
  }

  void calculateAnticipatedTime() {
    if (startTime != null && endTime != null) {
      final start = Duration(hours: startTime!.hour, minutes: startTime!.minute);
      final end = Duration(hours: endTime!.hour, minutes: endTime!.minute);

      final diff = end - start;

      // If the time goes past midnight, adjust
      final adjustedDiff = diff.isNegative ? diff + Duration(days: 1) : diff;

      final hours = adjustedDiff.inHours;
      final minutes = adjustedDiff.inMinutes % 60;

      anticipatedHoursController.text = hours.toString();
      anticipatedMinutesController.text = minutes.toString();
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

  void submitTask() async {
    if (nameController.text.isNotEmpty &&
        startTime != null &&
        endTime != null &&
        startDate != null &&
        endDate != null &&
        anticipatedHoursController.text.isNotEmpty || anticipatedMinutesController.text.isNotEmpty) {
          
      Map<String, dynamic> newTask = {
        'name': nameController.text,
        'category': category,
        'priority': priority,
        'startDate': "${startDate!.toLocal()}".split(' ')[0],
        'endDate': "${endDate!.toLocal()}".split(' ')[0],
        'startTime': startTime!.format(context),
        'endTime': endTime!.format(context),
        'anticipatedHours': anticipatedHoursController.text,
        'anticipatedMinutes': anticipatedMinutesController.text,
      };

      // Save task to file
      bool success = await FileManager.writeTaskData(newTask);
      if (success) {
        print("Task saved successfully!");
      } else {
        print("Failed to save task.");
      }


      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task saved successfully!")),
        );
        Navigator.pop(context, newTask); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving task!")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: TextStyle(fontWeight: FontWeight.bold),
          ),
        backgroundColor: const Color.fromARGB(179, 254, 175, 255),
      ),
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
                value: category,
                decoration: InputDecoration(labelText: 'Event Category'),
                items: ['Work', 'Personal', 'School', 'Other']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value!;
                  });
                },
              ),

              SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value!;
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

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: anticipatedHoursController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Anticipated Hours'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: anticipatedMinutesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Anticipated Minutes'),
                    ),
                  ),
                ],
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