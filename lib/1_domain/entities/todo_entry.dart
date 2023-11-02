import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';

class ToDoEntry extends Equatable {
  final EntryId id;
  final String description;
  final bool isDone;

  const ToDoEntry({
    required this.id,
    required this.description,
    required this.isDone,
  });

  factory ToDoEntry.empty() => ToDoEntry(
        id: EntryId(),
        description: '',
        isDone: false,
      );

  ToDoEntry copyWith({String? description, bool? isDone, CollectionId? collectionId}) {
    return ToDoEntry(
      id: id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [description, isDone, id];
}
