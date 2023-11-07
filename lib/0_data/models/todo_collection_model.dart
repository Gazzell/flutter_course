import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';

part 'todo_collection_model.g.dart';

@JsonSerializable()
class ToDoCollectionModel extends Equatable {
  final String id;
  final int value;
  final String title;
  const ToDoCollectionModel({
    required this.id,
    required this.value,
    required this.title,
  });

  factory ToDoCollectionModel.fronJson(Map<String, dynamic> json) =>
      _$ToDoCollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoCollectionModelToJson(this);

  factory ToDoCollectionModel.fromToDoCollection(ToDoCollection collection) =>
      ToDoCollectionModel(
        id: collection.id.value,
        value: collection.color.value,
        title: collection.title,
      );

  @override
  List<Object?> get props => [id, value, title];
}
