import 'package:flutter/material.dart';

class StartPauseWidget extends StatefulWidget {
  final Function onIconPressed;
  final Function onResetPressed;
  final Function onSavePressed; // not used
  const StartPauseWidget(
      {this.onIconPressed, this.onResetPressed, this.onSavePressed});

  @override
  _StartPauseWidgetState createState() => _StartPauseWidgetState();
}

class _StartPauseWidgetState extends State<StartPauseWidget> {
  bool isPlaying;

  @override
  void initState() {
    isPlaying = false;
    super.initState();
  }

  void handleStartStop() {
    setState(() {
      if (isPlaying) {
        isPlaying = false;
      } else {
        isPlaying = true;
      }
    });
    widget.onIconPressed();
  }

  void handleReset() {
    widget.onResetPressed();
  }

  void handleSave() {
    //widget.onSavePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isPlaying
            ? FlatButton(
                child: Text("Reset"),
                onPressed: () {
                  handleReset();
                },
              )
            : SizedBox.shrink(),
        SizedBox(width: 30),
        Ink(
          decoration:
              ShapeDecoration(color: Colors.blue, shape: CircleBorder()),
          child: IconButton(
            icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            color: Colors.white,
            iconSize: 30,
            onPressed: () {
              handleStartStop();
            },
          ),
        ),
        SizedBox(width: 30),
        isPlaying
            ? FlatButton(
                child: Text("Save"),
                onPressed: () {
                  handleSave();
                },
              )
            : SizedBox.shrink()
      ],
    );
  }
}
