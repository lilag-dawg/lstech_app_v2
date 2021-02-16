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

  final minValue = 160;
  final maxValue = 180;
  String cranklength;

  final double sizeFactor = 2;

  List<int> encodeDoubleToListInt(double valueInDouble) {
    List<int> result = [];
    int valueInInt = valueInDouble.toInt();
    if (valueInDouble % 1 == 0) {
      result.add((valueInInt & 0xFF) << 1);
    } else {
      result.add(((valueInInt & 0xFF) << 1) + 1);
    }
    result.add(valueInInt >> 7);
    return result;
  }

  String decodeListIntToString(List<int> value) {
    String text;
    print(value);
    if (value.length != 1) {
      text = ((value[0] >> 1) + (value[1] << 7)).toString();
    } else {
      text = (value[0] >> 1).toString();
    }
    if (value[0] & 0x1 == 1) {
      text = text + ".5";
    }
    return text;
  }

  Future<void> _showTextControlDialog() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error with value"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text("Value must be between 160 and 180mm")],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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
                decoration: InputDecoration(
                    hintText: "Enter crank length value in mm")),
            actions: [
              TextButton(
                child: Text("Apply"),
                onPressed: () async {
                  char = deviceManager.ossDevice
                      .getService("1818")
                      .getCharacteristic(powerWriteCharactetistic);
                  if (char != null) {
                    if (num.tryParse(myController.text) == null ||
                        minValue > double.parse(myController.text) ||
                        double.parse(myController.text) > maxValue) {
                      await _showTextControlDialog();
                    } else {
                      List<int> dataToSend = encodeDoubleToListInt(
                          double.parse(myController.text));
                      await char.characteristic.write(
                          [0x04, dataToSend[0], dataToSend[1]]).then((_) {
                        Navigator.of(context).pop();
                        setState(() {
                          cranklength =
                              myController.text; //only used to rerender page
                        });
                      });
                    }
                  }
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

  Future<String> currentCrankLengthValue(
      BluetoothDeviceManager deviceManager) async {
    BluetoothDeviceCharacteristic char;
    String text;
    if (deviceManager.ossDevice == null) {
      text = "-";
    } else {
      char = deviceManager.ossDevice
          .getService("1818")
          .getCharacteristic(powerWriteCharactetistic);
      if (char != null) {
        await char.characteristic.write([0x05]);
        await for (List<int> value in char.characteristic.value) {
          if (value.isNotEmpty) {
            text = decodeListIntToString(value);
            break;
          }
        }
      }
    }
    return text;
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
              Text("Crank Length (MM)",
                  style: TextStyle(fontSize: 12 * sizeFactor)),
              FutureBuilder(
                  future: currentCrankLengthValue(deviceManager),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data,
                          style: TextStyle(fontSize: 70 * sizeFactor),
                        );
                      }
                      return Text(
                        " - ",
                        style: TextStyle(fontSize: 70 * sizeFactor),
                      );
                    }
                  }),
              OutlineButton(
                child:
                    Text("CHANGE", style: TextStyle(fontSize: 12 * sizeFactor)),
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
