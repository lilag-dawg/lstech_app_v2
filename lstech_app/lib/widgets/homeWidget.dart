import 'package:flutter/material.dart';
import 'package:lstech_app/models/item.dart';
import 'package:lstech_app/widgets/expandedViewWidget.dart';

class HomeWidget extends StatelessWidget {
  final Item item1 =
      Item(expandedValue: "this is the body", headerValue: "Header");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Put stuff here"),
          ExpandedViewWidget(
            data: item1,
          )
        ],
      ),
    );
  }
}
