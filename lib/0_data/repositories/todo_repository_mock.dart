import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryMock implements ToDoRepository {
  final toDoCollections = List<ToDoCollection>.generate(
    10,
    (index) => ToDoCollection(
      id: CollectionId.fromUniqueString(index.toString()),
      title: 'title $index',
      color: ToDoColor(
        value: index % ToDoColor.predefinedColors.length,
      ),
    ),
  );

  final Map<String, List<ToDoEntry>> toDoEntries = {};

  ToDoRepositoryMock() {
    for (final (index, _) in toDoCollections.indexed) {
      final mapIndex = index.toString();
      toDoEntries[mapIndex] = List<ToDoEntry>.generate(
        10,
        (entryIndex) => ToDoEntry(
          id: EntryId.fromUniqueString((entryIndex + 10 * index).toString()),
          description: 'entry ${entryIndex + 10 * index}',
          isDone: false,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<ToDoCollection>>> readTodoCollections() {
    try {
      return Future.delayed(
        const Duration(milliseconds: 200),
        () => Right(toDoCollections),
      );
    } on Exception catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> readTodoEntry(
    CollectionId collectionId,
    EntryId entryId,
  ) {
    try {
      final toDoEntry = toDoEntries[collectionId.value]
          ?.firstWhere((element) => element.id == entryId);
      if (toDoEntry == null) {
        throw EntryNotFoundException(
          entryId: entryId.value,
          collectionId: collectionId.value,
        );
      }
      return Future.delayed(
        const Duration(milliseconds: 100),
        () => Right(toDoEntry),
      );
    } on Exception catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<EntryId>>> readTodoEntriesCollection(
      CollectionId collectionId) {
    try {
      if (!toDoEntries.containsKey(collectionId.value)) {
        throw CollectionNotFoundException(collectionId: collectionId.value);
      }
      final entryIds =
          toDoEntries[collectionId.value]!.map((entry) => entry.id).toList();

      return Future.delayed(
        const Duration(milliseconds: 300),
        () => Right(entryIds),
      );
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateTodoEntryIsDone(
    CollectionId collectionId,
    EntryId entryId,
    bool isDone,
  ) {
    try {
      if (!toDoEntries.containsKey(collectionId.value)) {
        throw CollectionNotFoundException(collectionId: collectionId.value);
      }
      final index = toDoEntries[collectionId.value]!
          .indexWhere((element) => element.id == entryId);
      final entryToUpdate = toDoEntries[collectionId.value]![index];
      final updatedEntry = entryToUpdate.copyWith(isDone: isDone);
      toDoEntries[collectionId.value]![index] = updatedEntry;

      return Future.delayed(
        const Duration(milliseconds: 200),
        () => Right(updatedEntry),
      );
    } on Exception catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> createTodoCollection(
      ToDoCollection collection) {
    try {
      toDoCollections.add(collection);
      toDoEntries[collection.id.value] = [];
      return Future.delayed(
        const Duration(milliseconds: 200),
        () => const Right(true),
      );
    } catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> createTodoEntryItem(
      CollectionId collectionId, ToDoEntry entry) {
    try {
      if (!toDoEntries.containsKey(collectionId.value)) {
        toDoEntries[collectionId.value] = [];
      }
      toDoEntries[collectionId.value]!.add(entry);
      return Future.delayed(
        const Duration(milliseconds: 100),
        () => const Right(true),
      );
    } catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }
}
