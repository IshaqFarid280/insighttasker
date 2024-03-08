import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _duration = 0;

  void _startTimer() {
    if (_duration > 0) {
      // Start the countdown timer only if duration is greater than 0
      _startTimerTick();
    }
  }

  void _startTimerTick() {
    if (_duration > 0) {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          // Decrease the duration by 1 second
          _duration--;
        });

        // Continue the countdown if the duration is not yet 0
        if (_duration > 0) {
          _startTimerTick();
        }
      });
    }
  }

  void _increaseTimer() {
    setState(() {
      _duration += 10; // Increase timer duration by 10 seconds
    });
  }

  void _decreaseTimer() {
    if (_duration > 0) {
      setState(() {
        _duration -= 10; // Decrease timer duration by 10 seconds
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Timer'),
        backgroundColor: Colors.black, // Set app bar background color to black
      ),
      backgroundColor: Colors.black, // Set scaffold background color to black
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Timer: $_duration seconds',
              style: TextStyle(fontSize: 24.0, color: Colors.white), // Set text color to white
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseTimer,
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set button background color to blue
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _decreaseTimer,
                  child: Icon(Icons.remove),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Set button background color to blue
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTimer,
              child: Text('Start Timer'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Set button background color to blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}
