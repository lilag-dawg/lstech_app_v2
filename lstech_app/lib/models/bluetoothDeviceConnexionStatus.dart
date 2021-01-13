import 'package:flutter_blue/flutter_blue.dart';

class BluetoothDeviceConnexionStatus {
  final BluetoothDevice device;
  String connexionStatus;
  static String connected = "connected";
  static String inTransistion = "standby";
  static String disconnected = "disconnected";

  BluetoothDeviceConnexionStatus({this.device, this.connexionStatus});

  BluetoothDevice get getDevice {
    return device;
  }

  set setConnexionStatus(String status) {
    connexionStatus = status;
  }
}
