import 'package:flutter/material.dart';
import 'package:lstech_app/constant.dart' as constant;

class StatisticScreen extends StatelessWidget {
  final double caloriesDepense;

  final int cadenceMax;
  final double cadenceMoy;

  final int puissanceMax;
  final double puissanceMoy;

  final int currentTimerTime;

  StatisticScreen(
      {Key key,
      this.cadenceMax,
      this.cadenceMoy,
      this.caloriesDepense,
      this.currentTimerTime,
      this.puissanceMax,
      this.puissanceMoy})
      : super(key: key);

  String formatTime(int secs) {
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Widget _trainingBox(String units, Object data, double sizeFactor) {
    if (data == null) {
      data = " - ";
      //data = 172.34234;
    }
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Text(
            units,
            style: TextStyle(fontSize: 12 * sizeFactor),
          ),
          Text(
            (data is double) ? data.toStringAsFixed(2) : data.toString(),
            style: TextStyle(fontSize: 70 * sizeFactor),
          )
        ],
      ),
    );
  }

  Widget _timeBox(String units, int data, double sizeFactor) {
    return Container(
      padding: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Text(
            units,
            style: TextStyle(fontSize: 12 * sizeFactor),
          ),
          Text(
            formatTime(data),
            style: TextStyle(fontSize: 70 * sizeFactor),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        backgroundColor: constant.lsTechGreen,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("Max RPM", cadenceMax,
                      MediaQuery.of(context).size.width / 500),
                ),
                Expanded(
                  child: _trainingBox("Average RPM", cadenceMoy,
                      MediaQuery.of(context).size.width / 500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("Max Power", puissanceMax,
                      MediaQuery.of(context).size.width / 500),
                ),
                Expanded(
                  child: _trainingBox("Average Power", puissanceMoy,
                      MediaQuery.of(context).size.width / 500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _trainingBox("Total calories", caloriesDepense,
                      MediaQuery.of(context).size.width / 400),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _timeBox("Time", currentTimerTime,
                      MediaQuery.of(context).size.width / 400),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
