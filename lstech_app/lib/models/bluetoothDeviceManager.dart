import 'package:flutter/cupertino.dart';
import 'package:lstech_app/models/myBluetoothDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  MyBluetoothDevice ossDevice;
  BluetoothDeviceManager();

  static String connectionHandlingService = "1802"; // check pour enum
  static String cablibrationService = "1803";

  static String nombreCapteursCharact = "16A1";
  static String listCapteursCharact = "16A2";
  static String paringRequestCharact = "16A3";
  static String sensorDataType = "16A4";
  static String calibrationCharact = "16B1";

  void setDevice(MyBluetoothDevice device) {
    ossDevice = device;
    notifyListeners();
  }

  void remove() {
    ossDevice = null;
  }
}
