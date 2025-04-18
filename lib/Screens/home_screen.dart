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
import '../cross_platform_notification.dart';

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

    List<Appointment> appointments =
        taskData.map((task) {
          DateTime startDateTime = _combineDateAndTime(
            task['startDate'],
            task['startTime'],
          );
          DateTime endDateTime = _combineDateAndTime(
            task['endDate'],
            task['endTime'],
          );

          // 🟪 Assign color based on category
          Color appointmentColor;
          switch (task['category']?.toLowerCase()) {
            case 'work':
              appointmentColor = Color(
                0xFF9C27B0,
              ); // Rich Purple (bold and energizing)
              break;
            case 'personal':
              appointmentColor = Color.fromARGB(
                255,
                227,
                132,
                244,
              ); // Light Lavender Pink (soft & gentle)
              break;
            case 'school':
              appointmentColor = Color(
                0xFF7E57C2,
              ); // Deep Lavender (focused, academic)
              break;
            case 'other':
              appointmentColor = Color(0xFF9B5C8F); // Mauve-Rose (warm, unique)
              break;
            default:
              appointmentColor = Color(0xFFCE93D8); // Fallback: pastel purple
          }

          return Appointment(
            startTime: startDateTime,
            endTime: endDateTime,
            subject: task["name"],
            notes: task["status"],
            color: appointmentColor,
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

  Icon _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Icon(Icons.check_circle, color: Colors.white, size: 14);
      case 'in progress':
        return Icon(Icons.access_time, color: Colors.white, size: 14);
      case 'to-do':
      default:
        return Icon(Icons.push_pin, color: Colors.white, size: 14);
    }
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
              ).then((_) {
                _loadTasks(); // Refresh the calendar when returning
              });
            },
          ),

            // 🛎️ Notification Test Button (NEW)
          IconButton(
            icon: Icon(Icons.notifications_active),
            tooltip: 'Notification',
            onPressed: () {
              CrossPlatformNotifier.showNotification(
                "Time to Study!",
                "Don't forget your flashcards!",
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
          timeIntervalHeight: 80, // Adjust slot height
        ),
        dataSource: _taskDataSource, // Load tasks into the calendar
        appointmentBuilder: (
          BuildContext context,
          CalendarAppointmentDetails details,
        ) {
          final Appointment appointment = details.appointments.first;

          // Format time
          final String timeRange =
              '${DateFormat.jm().format(appointment.startTime)} - ${DateFormat.jm().format(appointment.endTime)}';

          return Container(
            width: details.bounds.width,
            height: details.bounds.height,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: appointment.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.subject, // Title shown first
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  timeRange, // time range shown second
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    _getStatusIcon(appointment.notes),
                    SizedBox(width: 4),
                    Text(
                      appointment.notes ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: PomoButton(
        menuItems: [
          PomoMenu(
            value: 'create: task',
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
            value: 'nav: timer page',
            label: 'Goto: Timer Test Page',
            icon: Icons.arrow_forward_sharp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TimerTestPage(title: ''),
                ),
              );
            },
          ),
          PomoMenu (
            value: 'nav: task page',
            label: 'Goto: Tasks',
            icon: Icons.arrow_forward_sharp,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen(), 
                ),
              );
            },
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
