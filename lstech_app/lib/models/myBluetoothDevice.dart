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
      supportedDataType[DataType.cadence] = cadenceStream(
          service.getCharacteristic(cscCharactetistic).characteristic);
    }
    if (service.serviceName == "180F") {
      supportedDataType[DataType.battery] = batteryStream(
          service.getCharacteristic(batteryCharacteristic).characteristic);
    }
    if (service.serviceName == "180D") {
      //supportedDataType.add(DataType.cardiac);
    }
  }

  Stream<int> powerStream(BluetoothCharacteristic c) async* {
    await for (var chunk in c.value) {
      if (chunk.isNotEmpty) {
        yield (chunk[3] << 8) + chunk[2];
      }
    }
  }

  Stream<int> batteryStream(BluetoothCharacteristic c) async* {
    await for (var chunk in c.value) {
      if (chunk.isNotEmpty) {
        yield chunk[0];
      }
    }
  }

  Stream<int> cadenceStream(BluetoothCharacteristic c) async* {
    int flag = 0;
    int currentCrankRev = 0;
    int lastCrankRev = 0;
    int currentCrankTime = 0;
    int lastCrankTime = 0;
    int lastCadence = 0;
    int currentCadence = 0;
    int zeroCount =
        0; // used to count how many consecutive value are 0, if count is superior to 3 --> reset cadence

    await for (var chunk in c.value) {
      if (chunk.isNotEmpty) {
        flag = chunk[0];
        switch (flag) {
          case 1:
            //no cadence value here
            break;
          case 2:
            lastCrankRev = currentCrankRev;
            currentCrankRev = (chunk[2] << 8) + chunk[1];
            lastCrankTime = currentCrankTime;
            currentCrankTime = ((chunk[4] << 8) + chunk[3]);
            break;
          case 3:
            lastCrankRev = currentCrankRev;
            currentCrankRev = (chunk[8] << 8) + chunk[7];
            lastCrankTime = currentCrankTime;
            currentCrankTime = ((chunk[10] << 8) + chunk[9]);
            break;
          default:
            break;
        }
        if (lastCrankRev != 0 && currentCrankRev != 0) {
          if (currentCadence == lastCadence) {
            zeroCount += 1;
          } else {
            zeroCount = 0;
          }
          lastCadence = currentCadence;
          currentCadence = convertRawToCadence(currentCrankRev, lastCrankRev,
              currentCrankTime, lastCrankTime, lastCadence, zeroCount);
          yield currentCadence;
        }
      }
    }
  }

  int convertRawToCadence(int currentCrankRev, int lastCrankRev,
      int currentCrankTime, int lastCrankTime, int lastCadence, int zeroCount) {
    int currentCadence = 0;
    if (currentCrankTime < lastCrankTime) {
      currentCrankTime = currentCrankTime + 65536;
    }
    if (currentCrankTime == lastCrankTime ||
        (currentCrankRev == lastCrankRev && zeroCount < 3)) {
      return lastCadence;
    } else {
      currentCadence = ((currentCrankRev - lastCrankRev) *
          (1024 * 60) ~/
          (currentCrankTime - lastCrankTime));
      return currentCadence;
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
