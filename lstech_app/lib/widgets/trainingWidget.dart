import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/startPauseWidget.dart';
import 'package:lstech_app/widgets/stopwatchWidget.dart';

class TrainingScreen extends StatelessWidget {
  final GlobalKey<StopwatchWidgetState> _key = GlobalKey();

  Widget _trainingBox(String units, int value) {
    // int will probably change for a stream
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          //color: Colors.grey[350],
          ),
      child: Column(
        children: [
          Text(
            units,
            style: TextStyle(fontSize: 12),
          ),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 70),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("POWER", 122),
                ),
                Expanded(
                  child: _trainingBox("CADENCE", 78),
                )
              ],
            ),
            StopwatchWidget(key: _key),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("CALORIES", 20),
                ),
                Expanded(
                  child: _trainingBox("HEARTH RATE", 146),
                )
              ],
            ),
            StartPauseWidget(
              onIconPressed: () {
                _key.currentState.handleStartStop();
              },
              onResetPressed: () {
                _key.currentState.handleReset();
              },
            )
          ],
        ),
      ),
    );
  }
}
