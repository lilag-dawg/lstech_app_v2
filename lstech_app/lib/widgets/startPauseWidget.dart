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
  bool isShowingResetAndSaveButton;

  @override
  void initState() {
    isPlaying = false;
    isShowingResetAndSaveButton = false;
    super.initState();
  }

  void handleStartStop() {
    setState(() {
      if (isPlaying) {
        isPlaying = false;
      } else {
        isPlaying = true;
      }
      isShowingResetAndSaveButton = true;
    });
    widget.onIconPressed();
  }

  void handleReset() {
    setState(() {
      isShowingResetAndSaveButton = false;
    });
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
        isShowingResetAndSaveButton
            ? FlatButton(
                child: Text("Reset"),
                onPressed: () {
                  handleReset();
                },
              )
            : SizedBox.shrink(),
        SizedBox(width: 30),
        Container(
          color: Colors.blue,
          child: IconButton(
            icon: isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            color: Colors.white,
            iconSize: 40,
            onPressed: () {
              handleStartStop();
            },
          ),
        ),
        SizedBox(width: 30),
        isShowingResetAndSaveButton
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
