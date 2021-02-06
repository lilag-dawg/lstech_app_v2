import 'package:flutter_blue/flutter_blue.dart';
import 'package:lstech_app/models/recognizedData.dart';
import './bluetoothDeviceService.dart';

class MyBluetoothDevice {
  final BluetoothDevice device;

  Map<DataType, Stream<int>> supportedDataType = {};

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
        _setSupportedDataType(onValue);
      });
    });
  }

  void _setSupportedDataType(BluetoothDeviceService service) {
    if (service.serviceName == "1818") {
      supportedDataType[DataType.power] = powerStream(
          service.getCharacteristic(powerCharactetistic).characteristic);
    }
    if (service.serviceName == "1816") {
      //supportedDataType.add(DataType.cadence);
    }
    if (service.serviceName == "180F") {
      //supportedDataType.add(DataType.battery);
    }
    if (service.serviceName == "180D") {
      //supportedDataType.add(DataType.cardiac);
    }
  }

  Stream<int> powerStream(BluetoothCharacteristic c) async* {
    await for (var chunk in c.value) {
      if (chunk.isNotEmpty) {
        yield chunk[1]; //not sure if this is the right number for power
      }
    }
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
