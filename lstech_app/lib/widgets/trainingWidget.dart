import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/models/recognizedData.dart';
import 'package:lstech_app/widgets/startPauseWidget.dart';
import 'package:lstech_app/widgets/stopwatchWidget.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatelessWidget {
  final GlobalKey<StopwatchWidgetState> _key = GlobalKey();

  Widget _trainingBox(String units, Stream<int> source, double sizeFactor) {
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
          StreamBuilder<int>(
              stream: source,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text(
                  snapshot.data.toString(),
                  style: TextStyle(fontSize: 70 * sizeFactor),
                );
              })
        ],
      ),
    );
  }

  Widget _batteryLevel(
      String nameOfSensor, Stream<int> source, double sizeFactor) {
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
          StreamBuilder<int>(
              stream: source,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text(
                  snapshot.data.toString() + " %",
                  style: TextStyle(fontSize: 70 * sizeFactor),
                );
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceManager = Provider.of<BluetoothDeviceManager>(context);

    Stream<int> powerStream;
    Stream<int> cadenceStream;
    Stream<int> batteryStream;
    Stream<int> calorieStream;
    Stream<int> hearthRateStream;
    String deviceName;

    if (deviceManager.ossDevice != null) {
      powerStream = deviceManager.ossDevice.supportedDataType[DataType.power];
      cadenceStream =
          deviceManager.ossDevice.supportedDataType[DataType.cadence];
      batteryStream =
          deviceManager.ossDevice.supportedDataType[DataType.battery];
      deviceName = deviceManager.ossDevice.device.name;
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _trainingBox("POWER", powerStream, 1.75),
            _trainingBox("CADENCE", cadenceStream, 1.75),
            StopwatchWidget(key: _key),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("CALORIES", calorieStream, 0.7),
                ),
                Expanded(
                  child: _trainingBox("HEARTH RATE", hearthRateStream, 0.7),
                ),
                Expanded(
                  child: _batteryLevel(deviceName, batteryStream, 0.7),
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
