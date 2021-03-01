import 'package:flutter/material.dart';
import 'package:lstech_app/widgets/homeWidget.dart';
import 'package:lstech_app/widgets/settingWidget.dart';
import 'package:lstech_app/widgets/trainingWidget.dart';
import 'package:lstech_app/constant.dart' as constant;

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    TrainingScreen(),
    SettingWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/foreground.png',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Wattza',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900)),
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(2, -12),
                        child: Text(
                          'TM',
                          textScaleFactor: 0.5,
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
                  ]),
                ))
          ],
        ),
        backgroundColor: constant.lsTechGreen,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike), label: "Training"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: constant.lsTechGreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
