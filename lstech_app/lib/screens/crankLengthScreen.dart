import 'package:flutter/material.dart';

class CrankLengthScreen extends StatefulWidget {
  @override
  _CrankLengthScreenState createState() => _CrankLengthScreenState();
}

class _CrankLengthScreenState extends State<CrankLengthScreen> {
  final myController = TextEditingController();

  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change Crank Length"),
            content: TextField(
                controller: myController,
                decoration:
                    InputDecoration(hintText: "Enter crank length value")),
            actions: [
              TextButton(
                child: Text("Apply"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crank Length"),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Crank Length (MM)", style: TextStyle(fontSize: 12)),
              Text(
                "12.45",
                style: TextStyle(fontSize: 70),
              ),
              OutlineButton(
                child: Text("CHANGE"),
                onPressed: () async {
                  await _showDialog();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
