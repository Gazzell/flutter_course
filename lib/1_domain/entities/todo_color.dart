import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ToDoColor extends Equatable {
  final int colorIndex;

  const ToDoColor({required this.colorIndex});

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

  @override
  List<Object?> get props => [colorIndex];
}
