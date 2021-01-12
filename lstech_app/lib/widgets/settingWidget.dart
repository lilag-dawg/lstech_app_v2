import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/screens/bluetoothManagementScreen.dart';
import 'package:provider/provider.dart';

class SettingWidget extends StatelessWidget {
  void _handleTapBLE(
      BuildContext context, BluetoothDeviceManager deviceManager) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                BluetoothManagementScreen(deviceManager: deviceManager)));
  }

  Widget _customSettingCard(String title, String tag, BuildContext context,
      BluetoothDeviceManager deviceManager) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () {
          if (tag == "ble") {
            _handleTapBLE(context, deviceManager);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceManager = Provider.of<BluetoothDeviceManager>(context);
    return Column(
      children: [
        _customSettingCard(
            "Bluetooth management", "ble", context, deviceManager),
        _customSettingCard("Language", "langue", context, deviceManager),
      ],
    );
  }
}
