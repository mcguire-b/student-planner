import 'package:flutter/material.dart';
import 'package:planner/Screens/add_task_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tasks_screen.dart'; // Import the TasksScreen class
import '../login_page.dart';
import '../Pomo_Menu_Classes/pomo_button.dart';
import '../Pomo_Menu_Classes/timer_test_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../file_manager.dart'; // Import FileManager
import 'package:intl/intl.dart';




// Home screen widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TaskDataSource _taskDataSource = TaskDataSource([]);
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Load tasks when screen starts
  }

void _loadTasks() async {
  List<Map<String, dynamic>> taskData = await FileManager.readTaskData();

  // Convert task data into list of Appointment objects
  List<Appointment> appointments = taskData.map((task) {
    // Combine the start date and start time into a complete DateTime
    DateTime startDateTime = _combineDateAndTime(task['startDate'], task['startTime']);
    DateTime endDateTime = _combineDateAndTime(task['endDate'], task['endTime']);
    
    return Appointment(
      startTime: startDateTime,
      endTime: endDateTime,
      subject: task["name"],  // Task name as the subject
      color: Colors.blue,     // Set a color for the task
    );
  }).toList();

  setState(() {
    _taskDataSource = TaskDataSource(appointments);
  });
}

// Helper function to combine date and time strings into DateTime
DateTime _combineDateAndTime(String date, String time) {
  // Combine date and time in the format 'yyyy-MM-dd h:mm a'
  String dateTimeString = '$date $time';
  
  // Parse the combined string into a DateTime object
  return DateFormat('yyyy-MM-dd h:mm a').parse(dateTimeString);
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Planner - Home'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen()),
              );
            },
          ),
        ],
      ),
      body: SfCalendar(
        view: CalendarView.week, // Change to week view
        firstDayOfWeek: 1, // Start week on Monday
        timeSlotViewSettings: TimeSlotViewSettings(
          startHour: 8, // Start time at 8 AM
          endHour: 22, // End time at 10 PM
          timeIntervalHeight: 50, // Adjust slot height
        ),
        dataSource: _taskDataSource, // Load tasks into the calendar
      ),
            floatingActionButton: PomoButton(
            menuItems: [
              PomoMenu(
                value: 'nav: task page', label: 'Goto: Add Task',
                icon: Icons.arrow_forward_sharp, 
                onTap: () {
                  Navigator.push(context,
                   MaterialPageRoute(builder: (context) => AddTaskScreen()));
                },
              ),
              // pomoMenu(
              //   value: 'Nav: home page', label: 'Goto: Home Page',
              //   icon: Icons.arrow_forward_sharp,
              //   onTap: () {
              //     Navigator.push(context, 
              //       MaterialPageRoute(builder: (context) => HomeScreen()));
              //   }
              // ),
              PomoMenu(
                value: 'test 3', label: 'Goto: Timer Test Page',
                icon: Icons.arrow_forward_sharp,
                onTap: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TimerTestPage(title: '',)));
                }
              ),
            ],
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
   
class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<Appointment> source) {
    appointments = source;
  }
}
