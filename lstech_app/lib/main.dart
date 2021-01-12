import 'package:flutter/material.dart';
import 'package:lstech_app/screens/navigationScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LsTech+ App',
      home: NavigationScreen(),
    );
  }
}
