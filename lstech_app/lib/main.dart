import 'package:flutter/material.dart';
import 'package:lstech_app/models/bluetoothDeviceManager.dart';
import 'package:lstech_app/screens/navigationScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BluetoothDeviceManager>(
          create: (context) => BluetoothDeviceManager(),
        ),
      ],
      child: MaterialApp(
        title: 'LsTech+ Demo',
        home: NavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
