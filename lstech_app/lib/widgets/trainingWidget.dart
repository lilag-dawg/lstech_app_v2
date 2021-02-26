import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/models/recognizedData.dart';
import 'package:lstech_app/screens/statisticScreen.dart';
import 'package:lstech_app/widgets/startPauseWidget.dart';
import 'package:lstech_app/widgets/stopwatchWidget.dart';
import 'package:provider/provider.dart';

class TrainingScreen extends StatefulWidget {
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final GlobalKey<StopwatchWidgetState> _key = GlobalKey();

  double caloriesDepense;
  int cadenceMax;
  double cadenceMoy;
  int puissanceMax;
  double puissanceMoy;
  bool isTimerRunning;
  int currentTimerTime;

  bool isResetPressed;

  Widget _trainingBox(String units, Stream<int> source, double sizeFactor) {
    int valueForStatsMax;
    double valueForStatsMoy;

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
                if (snapshot.hasData) {
                  if (isResetPressed) {
                    valueForStatsMoy = null;
                    valueForStatsMax = null;
                  } else {
                    if (isTimerRunning) {
                      if (valueForStatsMax == null) {
                        valueForStatsMax = snapshot.data;
                      }
                      if (snapshot.data > valueForStatsMax) {
                        valueForStatsMax = snapshot.data;
                      }
                      if (valueForStatsMoy == null) {
                        valueForStatsMoy = snapshot.data.toDouble();
                      } else {
                        valueForStatsMoy =
                            (valueForStatsMoy + snapshot.data) / 2;
                      }
                      switch (units) {
                        case "POWER":
                          puissanceMax = valueForStatsMax;
                          puissanceMoy = valueForStatsMoy;
                          break;
                        case "CADENCE":
                          cadenceMax = valueForStatsMax;
                          cadenceMoy = valueForStatsMoy;
                          break;
                        default:
                          break;
                      }
                    }
                  }

                  if (cadenceMax == null &&
                      cadenceMoy == null &&
                      puissanceMax == null &&
                      puissanceMoy == null &&
                      valueForStatsMax == null &&
                      valueForStatsMoy == null) {
                    isResetPressed = false;
                  }
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                } else {
                  return Text(
                    " - ",
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _trainingBoxCalories(
      String units, Stream<double> source, double sizeFactor) {
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
          StreamBuilder<double>(
              stream: source,
              builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toStringAsFixed(2),
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                } else {
                  return Text(
                    " - ",
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget _batteryLevel(
      String nameOfSensor, Stream<int> source, double sizeFactor) {
    if (nameOfSensor == null) {
      nameOfSensor = " - ";
    }
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
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data.toString() + " %",
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                } else {
                  return Text(
                    " -  %",
                    style: TextStyle(fontSize: 70 * sizeFactor),
                  );
                }
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    isTimerRunning = false;
    isResetPressed = false;
    Timer.periodic(Duration(seconds: 1), (timer) {
      currentTimerTime = _key.currentState.getTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceManager = Provider.of<BluetoothDeviceManager>(context);

    Stream<int> powerStream;
    Stream<int> cadenceStream;
    Stream<int> batteryStream;
    Stream<int> hearthRateStream;
    Stream<double> calorieStream;
    String deviceName;

    Stream<double> calorieStreamFunction() async* {
      List<PowerData> powerReading =
          List<PowerData>.generate(10, (_) => PowerData(0, 0));
      int i = 0;
      int k = 0;
      int sum = 0;
      double value = 0;
      int currentTime = 0;
      await for (var chunk in powerStream) {
        currentTime = currentTimerTime;
        if (isTimerRunning) {
          k = 0;
          sum = 0;
          powerReading[i].time = currentTime;
          powerReading[i].power = chunk;
          i++;
          if (i == 10) {
            i = 0;
          }
          for (PowerData p in powerReading) {
            if (p.time <= currentTime && p.time >= currentTime - 3) {
              sum += p.power;
              k++;
            }
          }
          if (k != 0) {
            value = (3 * (sum / k) / 4184) * currentTime;
          } else {
            value = 0;
          }
        } else {
          if (currentTime == 0) {
            value = 0;
          }
        }
        caloriesDepense = value;
        yield value;
      }
    }

    if (deviceManager.ossDevice != null) {
      powerStream = deviceManager.ossDevice.supportedDataType[DataType.power]
          .asBroadcastStream();
      cadenceStream =
          deviceManager.ossDevice.supportedDataType[DataType.cadence];
      batteryStream =
          deviceManager.ossDevice.supportedDataType[DataType.battery];
      deviceName = deviceManager.ossDevice.device.name;

      if (powerStream != null) {
        calorieStream = calorieStreamFunction();
      }
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
                  child: _trainingBoxCalories("CALORIES", calorieStream, 0.7),
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
                isTimerRunning = _key.currentState.getTimerStatus();
              },
              onResetPressed: () {
                _key.currentState.handleReset();
                isResetPressed = true;
                cadenceMax = null;
                cadenceMoy = null;
                puissanceMax = null;
                puissanceMoy = null;
                caloriesDepense = null;
              },
              onSavePressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatisticScreen(
                            cadenceMax: cadenceMax,
                            cadenceMoy: cadenceMoy,
                            puissanceMax: puissanceMax,
                            puissanceMoy: puissanceMoy,
                            caloriesDepense: caloriesDepense,
                            currentTimerTime: currentTimerTime)));
              },
            )
          ],
        ),
      ),
    );
  }
}

class PowerData {
  PowerData(this.time, this.power);
  int time;
  int power;
}
