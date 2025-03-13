import 'package:flutter/material.dart';
import 'dart:async';

class PomoTimer extends StatefulWidget {
  @override
  _PomoTimerState createState() => _PomoTimerState();
}

class _PomoTimerState extends State<PomoTimer>{
  //duration of countdown timer: default 30 minute pomodoro
  Duration _duration = Duration(minutes: 30);
  // timer object
  Timer? _timer;
  //countdown variable
  // ignore: unused_field
  int _countdownValue = 0;
  //bool to track if timer is running
  bool _isRunning = false;

  @override
  //initial state of timer
  void initState() {
    super.initState();
    //uncomment line below if you want timer to start without button press
    //startTimer();
  }

  @override
  //dispose of timer, prevent memory leak
  void dispose() {
    _timer?.cancel();
    super.dispose();
    }

  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        //the countdown has reached 0 seconds later, cancel
        if (_duration.inSeconds <= 0) {
          resetTimer();
        }// end if timer == 0
        //other actions
        else {
          // reduce timer by 1 second
          setState(() {
            _countdownValue = _duration.inSeconds;
            _duration = _duration - Duration(seconds: 1);
          });
        }// end else reduce time by 1
      }); 
    }//end if not running statement
  }//end start timer method

  void pauseTimer() {
    if (_isRunning) {
      _isRunning = false;
      _timer?.cancel();
    }
  }//end pause method

  void resetTimer() {
    _isRunning = false;
    _timer?.cancel();
    setState(() {
      _duration = Duration(minutes: 30);
    });//end set state
  } // end reset timer

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
              '${formatTime(_duration)}',
              style: TextStyle(fontSize: 18),
            ),
            //start timer button
            ElevatedButton(
              onPressed: resetTimer,
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
              onPressed: pauseTimer,
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
              onPressed: startTimer,
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
