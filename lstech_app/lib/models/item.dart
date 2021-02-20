class Item {
  Item({
    this.body,
    this.headerValue,
    this.isExpanded = false,
  });

  List<ExpandedValue> body;
  String headerValue;
  bool isExpanded;
}

class ExpandedValue {
  ExpandedValue({
    this.text,
    this.imageUrl,
  });
  String text;
  String imageUrl;
}
