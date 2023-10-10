import 'dart:async';
import 'dart:math';

import 'package:either_dart/either.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryMock implements ToDoRepository {
  final List<ToDoEntry> toDoEntries = List.generate(
    100,
    (index) => ToDoEntry(
      id: EntryId.fromUniqueString(index.toString()),
      description: 'entry $index',
      isDone: false,
    ),
  );

  final toDoCollections = List<ToDoCollection>.generate(
    10,
    (index) => ToDoCollection(
      id: CollectionId.fromUniqueString(index.toString()),
      title: 'title $index',
      color: ToDoColor(
        colorIndex: index % ToDoColor.predefinedColors.length,
      ),
    ),
  );

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
      if (Random().nextInt(10) > 7) {
        throw (Exception('Loading error'));
      }
      final toDoEntry =
          toDoEntries.firstWhere((element) => element.id == entryId);
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
      final startIndex = int.parse(collectionId.value) * 10;
      final endIndex = startIndex + 10;
      final entryIds = toDoEntries
          .sublist(startIndex, endIndex)
          .map((entry) => entry.id)
          .toList();

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
      final index = toDoEntries.indexWhere((element) => element.id == entryId);
      final entryToUpdate = toDoEntries[index];
      final updatedEntry = entryToUpdate.copyWith(isDone: isDone);
      toDoEntries[index] = updatedEntry;

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
      
      return Future.delayed(
        const Duration(milliseconds: 200),
        () => const Right(true),
      );
    } catch (e) {
      return Future(() => Left(ServerFailure(stackTrace: e.toString())));
    }
  }
}
