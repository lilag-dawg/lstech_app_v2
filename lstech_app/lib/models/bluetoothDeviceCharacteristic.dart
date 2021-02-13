import 'package:flutter_blue/flutter_blue.dart';
import 'package:lstech_app/models/recognizedData.dart';

class BluetoothDeviceCharacteristic {
  final String characteristicName;
  final BluetoothCharacteristic characteristic;

  BluetoothDeviceCharacteristic._create(
      this.characteristicName, this.characteristic);

  static Future<BluetoothDeviceCharacteristic> create(
      String characteristicName, BluetoothCharacteristic characteristic) async {
    BluetoothDeviceCharacteristic myCharacteristic =
        BluetoothDeviceCharacteristic._create(
            characteristicName, characteristic);
    switch (characteristicName) {
      case powerCharactetistic:
        await characteristic.setNotifyValue(true);
        break;
      case cscCharactetistic:
        await characteristic.setNotifyValue(true);
        break;
      case batteryCharacteristic:
        await characteristic.setNotifyValue(true);
        break;
      case powerWriteCharactetistic:
        await characteristic.setNotifyValue(true);
        break;
      default:
        break;
    }
    return myCharacteristic;
  }

  get name {
    return characteristicName;
  }

  get getCharacteristic {
    return characteristic;
  }
}
