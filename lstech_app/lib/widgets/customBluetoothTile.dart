//import 'dart:js';

import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceConnexionStatus.dart';

class CustomBluetoothTile extends StatelessWidget {
  final BluetoothDeviceConnexionStatus currentDevice;
  final Function(String) onTapTile;
  final Function(BuildContext) onTrailingPress;

  const CustomBluetoothTile(
      {this.currentDevice, this.onTapTile, this.onTrailingPress});

  void _handleTapTile() {
    onTapTile(currentDevice.connexionStatus);
  }

  Widget _buildTitle() {
    if (currentDevice.device.name.length > 0) {
      return Text(currentDevice.device.name,
          style: TextStyle(color: Colors.white));
    } else {
      return Text(currentDevice.device.id.toString(),
          style: TextStyle(color: Colors.white));
    }
  }

  Widget _buildLeading() {
    if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.connected) {
      return Icon(
        Icons.bluetooth_connected,
        color: Colors.green,
      );
    } else {
      return Icon(
        Icons.bluetooth_disabled,
        color: Colors.red,
      );
    }
  }

  Widget _buildSubtitle() {
    if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.connected) {
      return Text(BluetoothDeviceConnexionStatus.connected,
          style: TextStyle(color: Colors.green));
    } else if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.inTransistion) {
      return Text(BluetoothDeviceConnexionStatus.inTransistion,
          style: TextStyle(color: Colors.grey));
    } else {
      return Text(BluetoothDeviceConnexionStatus.disconnected,
          style: TextStyle(color: Colors.red));
    }
  }

  Widget _buildTrailing(BuildContext context) {
    if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.connected) {
      return IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            onTrailingPress(context);
          });
    } else {
      return SizedBox.shrink();
    }
  }

  Color _buildColor() {
    if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.connected) {
      return Colors.green[100];
    } else if (currentDevice.connexionStatus ==
        BluetoothDeviceConnexionStatus.inTransistion) {
      return Colors.black38;
    } else {
      return Colors.red[100];
    }
  }

  @override
  Widget build(BuildContext context) {
    print(currentDevice.connexionStatus + " " + currentDevice.device.name);
    return Card(
        child: ListTile(
            leading: _buildLeading(),
            title: _buildTitle(),
            subtitle: _buildSubtitle(),
            onTap: () {
              _handleTapTile();
            },
            trailing: _buildTrailing(context),
            enabled: (currentDevice.connexionStatus ==
                    BluetoothDeviceConnexionStatus.inTransistion)
                ? false
                : true),
        color: _buildColor());
  }
}
