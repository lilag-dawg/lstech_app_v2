import 'package:flutter_blue/flutter_blue.dart';
import './bluetoothDeviceService.dart';

class MyBluetoothDevice {
  final BluetoothDevice device;
  List<BluetoothDeviceService> services = [];

  MyBluetoothDevice._create(this.device);

  static Future<MyBluetoothDevice> create(BluetoothDevice d) async {
    MyBluetoothDevice ossDevice = MyBluetoothDevice._create(d);
    await ossDevice._discoverServices(d);
    return ossDevice;
  }

  Future<void> _discoverServices(BluetoothDevice d) async {
    List<BluetoothService> dServices = await d.discoverServices();
    await Future.forEach(dServices, (BluetoothService s) async {
      await BluetoothDeviceService.create(
              s.uuid.toString().toUpperCase().substring(4, 8), s)
          .then((onValue) {
        services.add(onValue);
      });
    });
  }

  BluetoothDeviceService getService(String name) {
    BluetoothDeviceService selected;
    services.forEach((s) {
      if (s.name == name) {
        selected = s;
      }
    });
    return selected;
  }

  get getDevice {
    return device;
  }
}
