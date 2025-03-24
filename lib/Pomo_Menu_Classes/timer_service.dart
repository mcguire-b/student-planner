import 'package:flutter/material.dart';
import 'dart:async';

class TimerService extends ChangeNotifier {
  static final TimerService _instance = TimerService._internal();
  factory TimerService() => _instance;
  TimerService._internal();

  Duration _remainingTime = Duration(minutes: 30);
  Timer? _timer;
  bool _isRunning = false;

  Duration get remainingTime => _remainingTime;
  bool get isRunning => _isRunning;

  //method to start timer, gets called in pomo_timer.dart widget building.
  void startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer?.cancel();
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime.inSeconds <= 0) {
          resetTimer();
        } else {
          _remainingTime -= Duration(seconds: 1);
          notifyListeners();
        }
      });
    }
  }

  //method to pause timer, gets called in pomo_timer.dart widget building.
  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  //method to reset timer, gets called in pomo_timer.dart widget building.
  void resetTimer() {
    _timer?.cancel();
    _remainingTime = Duration(minutes: 30);
    _isRunning = false;
    notifyListeners();
  }

  //disposes of timer when needed to avoid memory leak issues.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
