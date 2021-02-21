import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchWidget extends StatefulWidget {
  StopwatchWidget({Key key}) : super(key: key);
  @override
  StopwatchWidgetState createState() => StopwatchWidgetState();
}

class StopwatchWidgetState extends State<StopwatchWidget> {
  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Stopwatch _stopwatch;
  Timer _timer;

  @override
  void initState() {
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }

  void handleReset() {
    _stopwatch.reset();
  }

  int getTime() {
    return _stopwatch.elapsedMilliseconds ~/ 1000;
  }

  bool getTimerStatus() {
    return _stopwatch.isRunning;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          //color: Colors.grey[350],
          ),
      child: Column(
        children: [
          Text(
            "TIME",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            formatTime(_stopwatch.elapsedMilliseconds),
            style: TextStyle(fontSize: 70),
          )
        ],
      ),
    );
  }
}
