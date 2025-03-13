import 'package:flutter/material.dart';
import 'package:planner/add_task_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'tasks_screen.dart'; // Import the TasksScreen class
import 'login_page.dart';
import 'Pomo_Menu_Classes/pomo_button.dart';
import 'Pomo_Menu_Classes/timer_test_page.dart';


// Home screen widget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

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
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: focusedDay,
            calendarFormat: calendarFormat,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
            },
            onFormatChanged: (format) {
              setState(() {
                calendarFormat = format;
              });
            },
          ),
        ],
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