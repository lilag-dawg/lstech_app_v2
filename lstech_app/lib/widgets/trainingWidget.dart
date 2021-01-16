import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/widgets/startPauseWidget.dart';
import 'package:lstech_app/widgets/stopwatchWidget.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatelessWidget {
  final GlobalKey<StopwatchWidgetState> _key = GlobalKey();

  Widget _trainingBox(String units, int value, double sizeFactor) {
    // int will probably change for a stream
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          //color: Colors.grey[350],
          ),
      child: Column(
        children: [
          Text(
            units,
            style: TextStyle(fontSize: 12 * sizeFactor),
          ),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 70 * sizeFactor),
          )
        ],
      ),
    );
  }

  Widget _batteryLevel(String nameOfSensor, int value, double sizeFactor) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
          //color: Colors.grey[350],
          ),
      child: Column(
        children: [
          Text(
            nameOfSensor + " BATTERY LEVEL :",
            style: TextStyle(fontSize: 12 * sizeFactor),
          ),
          Text(
            value.toString() + " %",
            style: TextStyle(fontSize: 70 * sizeFactor),
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
            _trainingBox("POWER", 122, 1.75),
            _trainingBox("CADENCE", 78, 1.75),
            StopwatchWidget(key: _key),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("CALORIES", 20, 0.5),
                ),
                Expanded(
                  child: _trainingBox("HEARTH RATE", 146, 0.5),
                ),
                Expanded(
                  child: _batteryLevel("Wattza421", 67, 0.5),
                )
              ],
            ),
            SizedBox(
              height: 20,
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
