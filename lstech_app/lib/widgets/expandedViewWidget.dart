import 'package:flutter/material.dart';
import 'package:lstech_app/models/item.dart';

class ExpandedViewWidget extends StatefulWidget {
  final Item data;
  ExpandedViewWidget({this.data});
  @override
  _ExpandedViewWidgetState createState() => _ExpandedViewWidgetState();
}

class _ExpandedViewWidgetState extends State<ExpandedViewWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget.data.isExpanded = !isExpanded;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(widget.data.headerValue),
                );
              },
              body: Text(widget.data.expandedValue),
              isExpanded: widget.data.isExpanded,
            ),
          ],
        )
      ],
    );
  }
}
