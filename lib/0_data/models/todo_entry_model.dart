import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';

part 'todo_entry_model.g.dart';

@JsonSerializable()
class ToDoEntryModel extends Equatable {
  final String description;
  final bool isDone;
  final String id;

  const ToDoEntryModel({
    required this.id,
    required this.description,
    required this.isDone,
  });

  factory ToDoEntryModel.fromJson(Map<String, dynamic> json) =>
      _$ToDoEntryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoEntryModelToJson(this);

  factory ToDoEntryModel.fromToDoEntry(ToDoEntry entry) => ToDoEntryModel(
        id: entry.id.value,
        description: entry.description,
        isDone: entry.isDone,
      );

  @override
  List<Object?> get props => [id, description, isDone];
}
