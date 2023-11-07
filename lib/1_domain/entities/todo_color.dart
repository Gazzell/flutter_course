import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ToDoColor extends Equatable {
  final int value;

  const ToDoColor({required this.value});

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

  Color get color => Color(value);

  @override
  List<Object?> get props => [value];
}
