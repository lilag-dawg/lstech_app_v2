import 'package:flutter/material.dart';
import 'package:lstech_app/models/item.dart';

class ExpandedViewWidget extends StatefulWidget {
  final Item data;
  final Function onPress;
  ExpandedViewWidget({this.data, this.onPress});
  @override
  _ExpandedViewWidgetState createState() => _ExpandedViewWidgetState();
}

class _ExpandedViewWidgetState extends State<ExpandedViewWidget> {
  List<Widget> _body(List<ExpandedValue> content) {
    return content
        .map(
          (c) => Column(
            children: [
              ListTile(
                title: Text(c.text),
              ),
              (c.imageUrl != null)
                  ? Image.asset(
                      c.imageUrl,
                      fit: BoxFit.contain,
                    )
                  : SizedBox.shrink()
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget.onPress();
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
              body: Column(
                children: _body(widget.data.body),
              ),
              isExpanded: widget.data.isExpanded,
            ),
          ],
        )
      ],
    );
  }
}
