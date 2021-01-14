import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/screens/bluetoothManagementScreen.dart';
import 'package:lstech_app/screens/crankLengthScreen.dart';
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

  void _handleTapCrankLength(
      BuildContext context, BluetoothDeviceManager deviceManager) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CrankLengthScreen()));
  }

  Widget _customSettingCard(
      String title,
      IconData icon,
      String subtitle,
      String tag,
      Color color,
      BuildContext context,
      BluetoothDeviceManager deviceManager) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        size: 35,
        color: color,
      ),
      subtitle: Text(subtitle),
      onTap: () {
        if (tag == "ble") {
          _handleTapBLE(context, deviceManager);
        }
        if (tag == "crank_length") {
          _handleTapCrankLength(context, deviceManager);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceManager = Provider.of<BluetoothDeviceManager>(context);
    return Column(
      children: [
        _customSettingCard(
            "Bluetooth management",
            Icons.bluetooth,
            "Connect to environnent devices",
            "ble",
            Colors.blueAccent,
            context,
            deviceManager),
        _customSettingCard(
            "Change crank Length",
            Icons.miscellaneous_services,
            "Customize the length of the crankset",
            "crank_length",
            Colors.purple,
            context,
            deviceManager),
      ],
    );
  }
}
