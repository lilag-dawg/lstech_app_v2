import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceCharacteristic.dart';
import 'package:provider/provider.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/models/recognizedData.dart';

import 'bluetoothManagementScreen.dart';

class CrankLengthScreen extends StatefulWidget {
  @override
  _CrankLengthScreenState createState() => _CrankLengthScreenState();
}

class _CrankLengthScreenState extends State<CrankLengthScreen> {
  final myController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showDialog(BluetoothDeviceManager deviceManager) async {
    BluetoothDeviceCharacteristic char;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Crank Length"),
            content: TextField(
                controller: myController,
                decoration:
                    InputDecoration(hintText: "Enter crank length value")),
            actions: [
              TextButton(
                child: Text("Apply"),
                onPressed: () async {
                  char = deviceManager.ossDevice
                      .getService("1818")
                      .getCharacteristic(powerWriteCharactetistic);
                  if (char != null) {
                    //await char.characteristic.write();
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void showInSnackBar(String value, BuildContext context,
      BluetoothDeviceManager deviceManager) {
    final snackBar = SnackBar(
      content: Text(value),
      action: SnackBarAction(
        label: 'GO',
        onPressed: () {
          _handleTapBLE(context, deviceManager);
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handleTapBLE(
      BuildContext context, BluetoothDeviceManager deviceManager) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BluetoothManagementScreen(deviceManager: deviceManager)));
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceManager = Provider.of<BluetoothDeviceManager>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Crank Length"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Crank Length (MM)", style: TextStyle(fontSize: 12)),
              Text(
                "12.45",
                style: TextStyle(fontSize: 70),
              ),
              OutlineButton(
                child: Text("CHANGE"),
                onPressed: () async {
                  if (deviceManager.ossDevice != null) {
                    await _showDialog(deviceManager);
                  } else {
                    showInSnackBar(
                        "No device found! Click to connect to a device",
                        context,
                        deviceManager);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
