import 'package:flutter/material.dart';

class TrainingScreen extends StatelessWidget {
  Widget _trainingBox(String units, int value) {
    // int will probably change for a stream

    return Container(
      color: Colors.grey,
      child: Column(
        children: [Text(value.toString()), Text(units)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_trainingBox("watts", 122), _trainingBox("RPM", 78)],
          ),
          _trainingBox("Burned calories", 20),
          _trainingBox("seconds", 25),
          _trainingBox("battery level", 100),
        ],
      ),
    );
  }
}
