import 'package:flutter/material.dart';

class Components {
  static Padding genericPadding(double padding) {
    return new Padding(padding: new EdgeInsets.only(right: padding));
  }

  static List<Widget> genericRow(List<Widget> buttons, double padding) {
    List<Widget> list = new List();
    for (var button in buttons) {
      list.add(button);
      list.add(genericPadding(padding));
    }
    return list;
  }
}
