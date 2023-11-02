import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';

part 'todo_collection_model.g.dart';

@JsonSerializable()
class ToDoCollectionModel extends Equatable {
  final String id;
  final int colorIndex;
  final String title;
  const ToDoCollectionModel({
    required this.id,
    required this.colorIndex,
    required this.title,
  });

  factory ToDoCollectionModel.fronJson(Map<String, dynamic> json) =>
      _$ToDoCollectionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ToDoCollectionModelToJson(this);

  factory ToDoCollectionModel.fromToDoCollection(ToDoCollection collection) =>
      ToDoCollectionModel(
        id: collection.id.value,
        colorIndex: collection.color.colorIndex,
        title: collection.title,
      );

  @override
  List<Object?> get props => [id, colorIndex, title];
}
