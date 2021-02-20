import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lstech_app/models/bluetoothDeviceConnexionStatus.dart';
import 'package:lstech_app/models/myBluetoothDevice.dart';
import 'package:lstech_app/widgets/customBluetoothTile.dart';
import 'package:lstech_app/constant.dart' as constant;

import '../models/bluetoothDeviceManager.dart';
import 'deviceInformationScreen.dart';

final bool isWorkingOnEmulator = false;

class BluetoothManagementScreen extends StatefulWidget {
  final BluetoothDeviceManager deviceManager;
  BluetoothManagementScreen({Key key, @required this.deviceManager})
      : super(key: key);

  @override
  _BluetoothManagementScreenState createState() =>
      _BluetoothManagementScreenState();
}

class _BluetoothManagementScreenState extends State<BluetoothManagementScreen> {
  List<BluetoothDevice> alreadyConnectedDevices = [];
  List<BluetoothDeviceConnexionStatus> devicesConnexionStatus = [];
  StreamSubscription<List<ScanResult>> scanSubscription;
  bool isDoneScanning;

  Future<void> performScan() async {
    scanSubscription = FlutterBlue.instance.scanResults.listen((scanResults) {
      for (ScanResult r in scanResults) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((d) => d.getDevice == r.device);
        if (!isDeviceAlreadyAdded && r.device.name.length != 0) {
          //added r.device.name.length != 0 to only add named device
          devicesConnexionStatus.add(BluetoothDeviceConnexionStatus(
            device: r.device,
            connexionStatus: BluetoothDeviceConnexionStatus.disconnected,
          ));
        }
      }
    });

    await getConnectedDevice().then((alreadyConnectedDevices) async {
      for (BluetoothDevice d in alreadyConnectedDevices) {
        bool isDeviceAlreadyAdded =
            devicesConnexionStatus.any((device) => device.getDevice == d);
        if (!isDeviceAlreadyAdded) {
          devicesConnexionStatus.add(BluetoothDeviceConnexionStatus(
            device: d,
            connexionStatus: BluetoothDeviceConnexionStatus.connected,
          ));
          await addBluetoothDevice(d);
        } else {
          int errorFromScanResult = devicesConnexionStatus
              .indexWhere((device) => device.getDevice == d);
          devicesConnexionStatus[errorFromScanResult].setConnexionStatus =
              BluetoothDeviceConnexionStatus.connected;
        }
      }
    });
  }

  Future<List<BluetoothDevice>> getConnectedDevice() async {
    List<BluetoothDevice> devices = await FlutterBlue.instance.connectedDevices;
    return devices;
  }

  Future<void> addBluetoothDevice(BluetoothDevice device) async {
    await MyBluetoothDevice.create(device).then((createdBluetoothDevice) {
      widget.deviceManager.setDevice(createdBluetoothDevice);
    });
  }

  Future<void> _handleOnpressChanged(
      BluetoothDeviceConnexionStatus c, String currentStatus) async {
    final selectedDevice =
        devicesConnexionStatus.firstWhere((item) => item == c);
    if (currentStatus == BluetoothDeviceConnexionStatus.connected) {
      await c.device.disconnect().then(
          (_) => currentStatus = BluetoothDeviceConnexionStatus.disconnected);
      widget.deviceManager.remove();
    } else {
      await c.device
          .connect()
          .then((value) async =>
              await addBluetoothDevice(c.device).then((value) async {
                currentStatus = BluetoothDeviceConnexionStatus.connected;
                for (BluetoothDeviceConnexionStatus dc
                    in devicesConnexionStatus) {
                  if (dc.connexionStatus ==
                          BluetoothDeviceConnexionStatus.connected &&
                      dc != c) {
                    await dc.device.disconnect().then((_) =>
                        dc.connexionStatus =
                            BluetoothDeviceConnexionStatus.disconnected);
                  }
                }
              }))
          .timeout(Duration(seconds: 10), onTimeout: () {
        currentStatus = BluetoothDeviceConnexionStatus.disconnected;
        return null; //on pourrait rajouter un snackbar pour montrer à l'utilisateur que le connexion avec l'appareil n'a pas pu être établie
      });
    }
    setState(() {
      selectedDevice.setConnexionStatus = currentStatus;
    });
  }

  void _handleTrailingPressed(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DeviceInformationScreen(
                  deviceManager: widget.deviceManager,
                )));
  }

  List<Widget> _buildCustomTiles(List<BluetoothDeviceConnexionStatus> result) {
    return result
        .map(
          (d) => CustomBluetoothTile(
            currentDevice: d,
            onTapTile: (String currentStatus) async {
              setState(() {
                d.setConnexionStatus =
                    BluetoothDeviceConnexionStatus.inTransistion;
              });
              await _handleOnpressChanged(d, currentStatus);
            },
            onTrailingPress: (BuildContext context) {
              _handleTrailingPressed(context);
            },
          ),
        )
        .toList();
  }

  Widget _buildScanningButton() {
    return StreamBuilder(
        stream: FlutterBlue.instance.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return Container(
              child: RaisedButton(
                child: Text("stop scan"),
                color: Colors.red,
                onPressed: () => FlutterBlue.instance.stopScan(),
              ),
            );
          } else {
            return Center(
                child: RaisedButton(
                    child: Text("Search for Wattza"),
                    onPressed: () {
                      setState(() {
                        isDoneScanning = false;
                      });
                      startAScan();
                    }));
          }
        });
  }

  Widget _buildAnimations() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void startAScan() {
    isDoneScanning = false;
    if (!isWorkingOnEmulator) {
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)).then((_) {
        setState(() {
          isDoneScanning = true;
        });
      });
      performScan();
    }
  }

  @override
  void initState() {
    startAScan();
    super.initState();
  }

  @override
  void dispose() {
    if (!isWorkingOnEmulator) {
      FlutterBlue.instance.stopScan();
      scanSubscription.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth Manager"),
          backgroundColor: constant.lsTechGreen,
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            (isDoneScanning)
                ? Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Column(
                          children: _buildCustomTiles(devicesConnexionStatus),
                        ),
                      ),
                    ],
                  )
                : _buildAnimations(),
            (isWorkingOnEmulator)
                ? RaisedButton(
                    child: Text("Remettre à plus tard"),
                    color: Colors.red,
                    onPressed: () {})
                : _buildScanningButton(),
          ]),
        ));
  }
}
