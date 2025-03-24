import 'package:flutter/material.dart';
import 'timer_service.dart';


class PomoTimer extends StatefulWidget {
  @override
  _PomoTimerState createState() => _PomoTimerState();
}

class _PomoTimerState extends State<PomoTimer>{
  // late means its initialized before first use
  late TimerService _timerService;

  @override
  // create object
  void initState() {
    super.initState();
    //start timer service
    _timerService = TimerService();
    _timerService.addListener(_updateTimer);
  }

  @override
  void dispose() {
    //remove listener to avoid memory leaks if object is removed
    _timerService.removeListener(_updateTimer);
    super.dispose();
  }

  // updates timer when the widget state changes, i.e page change or timer close/open
  void _updateTimer() {
    if (mounted) {
      setState(() {});
    }
  }

  //Method used to format the timer into a MM:ss format when displayed to user
  String formatTime(Duration time){
    // pad left of duration with 00 to push minutes and second to the right
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    //variable to store minutes, ensuring it is not higher than 59
    final minutes = twoDigits(time.inMinutes.remainder(60));
    //variable to store seconds, ensuring it is not higher than 59
    final seconds = twoDigits(time.inSeconds.remainder(60));
    //return string with minutes and seconds
    return "$minutes:$seconds";
  }

  //UI for the Pomo Timer
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              formatTime(_timerService.remainingTime),
              style: TextStyle(fontSize: 18),
            ),
            //start timer button
            ElevatedButton(
              onPressed: _timerService.resetTimer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: Size(25, 15),
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Reset'),
              ),//reset button
            //pause button
            SizedBox(width: 5),
            ElevatedButton(
              onPressed: _timerService.pauseTimer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: Size(25, 15),
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Pause'),
              ),// pause
             // reset timer button
            SizedBox(width: 5),
            ElevatedButton(
              onPressed: _timerService.startTimer,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                minimumSize: Size(25, 15),
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Start'),
              ),//start
          ] //end menu children
        )
    ],);
  }

}//Pomo Timer class
