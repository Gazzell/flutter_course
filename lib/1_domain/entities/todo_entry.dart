import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';

class ToDoEntry extends Equatable {
  final EntryId id;
  final CollectionId collectionId;
  final String description;
  final bool isDone;

  const ToDoEntry({
    required this.id,
    required this.description,
    required this.isDone,
    required this.collectionId,
  });

  factory ToDoEntry.empty() => ToDoEntry(
        id: EntryId(),
        description: '',
        isDone: false,
        collectionId: CollectionId(),
      );

  ToDoEntry copyWith({String? description, bool? isDone, CollectionId? collectionId}) {
    return ToDoEntry(
      id: id,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      collectionId: collectionId ?? this.collectionId,
    );
  }

  @override
  List<Object?> get props => [description, isDone, id, collectionId];
}
