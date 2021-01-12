import 'package:flutter/material.dart';
import 'package:lstech_app/screens/bluetoothManagementScreen.dart';

class SettingWidget extends StatelessWidget {
  void _handleTapBLE(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BluetoothManagementScreen()));
  }

  Widget _customSettingCard(String title, String tag, BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () {
          if (tag == "ble") {
            _handleTapBLE(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customSettingCard("Bluetooth management", "ble", context),
        _customSettingCard("Language", "langue", context),
      ],
    );
  }
}
