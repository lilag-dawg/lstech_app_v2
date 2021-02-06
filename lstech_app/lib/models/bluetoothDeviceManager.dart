import 'package:flutter/cupertino.dart';
import 'package:lstech_app/models/myBluetoothDevice.dart';

class BluetoothDeviceManager extends ChangeNotifier {
  MyBluetoothDevice ossDevice;
  BluetoothDeviceManager();

  void setDevice(MyBluetoothDevice device) {
    ossDevice = device;
    notifyListeners();
  }

  void remove() {
    ossDevice = null;
  }
}
