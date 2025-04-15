import 'package:flutter/material.dart';
import 'package:planner/Pomo_Menu_Classes/pomo_timer.dart';
import 'pomo_button.dart';
import '../Screens/home_screen.dart';
import 'package:planner/Screens/add_task_screen.dart';



class TimerTestPage extends StatelessWidget {
  final String title;

  TimerTestPage (
    {
      required this.title
    }
    );//end constructor

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('This is a test page for Pomo Timer'),
        ),
        body: Center(
          child: Column(children: [
            PomoTimer()
          ],
        )
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}