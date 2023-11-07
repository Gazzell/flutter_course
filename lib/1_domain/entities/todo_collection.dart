import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';

class ToDoCollection extends Equatable {
  final CollectionId id;
  final String title;
  final ToDoColor color;

  const ToDoCollection(
      {required this.id, required this.title, required this.color});

  factory ToDoCollection.empty() {
    return ToDoCollection(
      id: CollectionId(),
      title: '',
      color: const ToDoColor(value: 0),
    );
  }

  ToDoCollection copyWith({String? title, ToDoColor? color}) {
    return ToDoCollection(
      id: id,
      title: title ?? this.title,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, title, color];
}
