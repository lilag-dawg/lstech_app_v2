import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceCharacteristic.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/constant.dart' as constant;
import 'package:lstech_app/models/recognizedData.dart';

class DeviceInformationScreen extends StatelessWidget {
  final BluetoothDeviceManager deviceManager;
  DeviceInformationScreen({Key key, @required this.deviceManager})
      : super(key: key);

  String convertRawToString(List<int> value) {
    String name = "";
    for (int i = 0; i < value.length; i++) {
      if (value[i] == 0) break;

      name = name + String.fromCharCode(value[i]);
    }
    return name;
  }

  Future<List<Information>> _getDataInfo(List<String> charIDs) async {
    BluetoothDeviceCharacteristic char;
    List<Information> result = [];
    String text;

    await Future.forEach(charIDs, (id) async {
      char = deviceManager.ossDevice.getService("180A").getCharacteristic(id);
      if (char != null) {
        List<int> value = await char.characteristic.read();
        text = convertRawToString(value);
      }
      switch (id) {
        case manufacturerNameCharactetistic:
          result.add(Information("Manufacturer Name", text));
          break;
        case serialNumberCharactetistic:
          result.add(Information("Serial Number", text));
          break;
        case hardwareRevCharactetistic:
          result.add(Information("Hardware Revision", text));
          break;
        case firmwareRevCharactetistic:
          result.add(Information("Firmware Resivion", text));
          break;
      }
    });
    return result;
  }

  Widget _myFutureBuilder(List<String> charIDs) {
    List<Information> resultList = [];
    return FutureBuilder(
        future: _getDataInfo(charIDs),
        builder:
            (BuildContext context, AsyncSnapshot<List<Information>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            resultList = snapshot.data;
          } else {
            for (String id in charIDs) {
              switch (id) {
                case manufacturerNameCharactetistic:
                  resultList.add(Information("Manufacturer Name", " - "));
                  break;
                case serialNumberCharactetistic:
                  resultList.add(Information("Serial Number", " - "));
                  break;
                case hardwareRevCharactetistic:
                  resultList.add(Information("Hardware Revision", " - "));
                  break;
                case firmwareRevCharactetistic:
                  resultList.add(Information("Firmware Resivion", " - "));
                  break;
              }
            }
          }
          return _diplayInformation(resultList);
        });
  }

  Widget _diplayInformation(List<Information> informations) {
    return Column(
      children: informations
          .map(
            (inf) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(inf.name + ": ", style: TextStyle(fontSize: 20)),
                Text(inf.value, style: TextStyle(fontSize: 20)),
              ],
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> charIDs = [
      manufacturerNameCharactetistic,
      serialNumberCharactetistic,
      hardwareRevCharactetistic,
      firmwareRevCharactetistic
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceManager.ossDevice.device.name),
        backgroundColor: constant.lsTechGreen,
      ),
      body: Center(
        child: Column(
          children: [
            _myFutureBuilder(charIDs),
          ],
        ),
      ),
    );
  }
}

class Information {
  Information(this.name, this.value);

  String name;
  String value;
}
