import 'package:flutter/material.dart';

class ToDoColor {
  final int colorIndex;

  ToDoColor({required this.colorIndex});

  static const List<Color> predefinedColors = [
    Colors.red,
    Colors.blueGrey,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.teal,
    Colors.orange,
  ];

  Color get color => predefinedColors[colorIndex];
}
