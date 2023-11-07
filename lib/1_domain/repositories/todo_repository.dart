import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';

abstract class ToDoRepository {
  Future<Either<Failure, List<ToDoCollection>>> readTodoCollections();

  Future<Either<Failure, ToDoEntry>> readTodoEntry(
    CollectionId collectionId,
    EntryId entryId,
  );

  Future<Either<Failure, List<EntryId>>> readTodoEntriesCollection(
    CollectionId collectionId,
  );

  Future<Either<Failure, ToDoEntry>> updateTodoEntryIsDone(
    CollectionId collectionId,
    EntryId entryId,
    bool isDone,
  );

  Future<Either<Failure, bool>> createTodoCollection(ToDoCollection collection);

  Future<Either<Failure, bool>> createTodoEntryItem(
    CollectionId collectionId,
    ToDoEntry entry,
  );

  Future<Either<Failure, bool>> removeTodoEntry(
    CollectionId collectionId,
    EntryId entryId,
  );
}
