import 'package:flutter/material.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController anticipatedTimeController = TextEditingController();
  
  String category = 'Work'; // Default category
  String priority = 'Medium'; // Default priority
  TimeOfDay? startTime;
  TimeOfDay? endTime;

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

  // Function to submit event
  void submitTask() {
    if (nameController.text.isNotEmpty &&
        startTime != null &&
        endTime != null &&
        anticipatedTimeController.text.isNotEmpty) {
      Map<String, dynamic> newTask = {
        'name': nameController.text,
        'category': category,
        'priority': priority,
        'startTime': startTime!.format(context),
        'endTime': endTime!.format(context),
        'anticipatedTime': anticipatedTimeController.text,
      };

      Navigator.pop(context, newTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 244, 224, 255),
            border: Border.all(color: Colors.white, width: 2), // Black border around the body
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          padding: const EdgeInsets.all(16.0), // Padding inside the border
          margin: const EdgeInsets.all(10.0), // Space around the container
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Event Name'),
              ),

              SizedBox(height: 10),

              // Category Dropdown
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

              // Priority Dropdown
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

              // Start Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(startTime == null ? 'Pick Start Time' : 'Start: ${startTime!.format(context)}'),
                  ElevatedButton(
                    onPressed: () => pickTime(true),
                    child: Text('Select'),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // End Time Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(endTime == null ? 'Pick End Time' : 'End: ${endTime!.format(context)}'),
                  ElevatedButton(
                    onPressed: () => pickTime(false),
                    child: Text('Select'),
                  ),
                ],
              ),

              SizedBox(height: 10),

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
    );
  }
}
