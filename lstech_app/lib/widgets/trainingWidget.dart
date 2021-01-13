import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/widgets/startPauseWidget.dart';
import 'package:lstech_app/widgets/stopwatchWidget.dart';
import 'package:provider/provider.dart';

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

  Widget _batteryLevel(String nameOfSensor, int value) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          //color: Colors.grey[350],
          ),
      child: Column(
        children: [
          Text(
            nameOfSensor + " BATTERY LEVEL :",
            style: TextStyle(fontSize: 12),
          ),
          Text(
            value.toString() + " %",
            style: TextStyle(fontSize: 70),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //final deviceManager = Provider.of<BluetoothDeviceManager>(context);

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
            _batteryLevel("Wattza421", 67),
            SizedBox(
              height:
                  120, // todo not happy with this widget (find a away to anchor at bottom)
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
