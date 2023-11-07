import 'package:todo_app/0_data/data_sources/interfaces/todo_local_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';

class MemoryLocalDataSource implements ToDoLocalSourceInterface {
  final List<ToDoCollectionModel> toDoCollections = [];
  final Map<String, List<ToDoEntryModel>> toDoEntries = {};

  @override
  Future<bool> createToDoCollection({required ToDoCollectionModel collection}) {
    try {
      toDoCollections.add(collection);
      toDoEntries.putIfAbsent(collection.id, () => []);
      return Future.value(true);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<bool> createToDoEntry(
      {required String collectionId, required ToDoEntryModel entry}) {
    try {
      if (!toDoEntries.containsKey(collectionId)) {
        throw CollectionNotFoundException(collectionId: collectionId);
      }

      toDoEntries[collectionId]?.add(entry);
      return Future.value(true);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getCollectionIds() {
    try {
      return Future.value(
        toDoCollections.map((e) => e.id).toList(),
      );
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoCollectionModel> getToDoCollection(
      {required String collectionId}) {
    try {
      final collection = toDoCollections.firstWhere(
        (element) => element.id == collectionId,
        orElse: () =>
            throw CollectionNotFoundException(collectionId: collectionId),
      );

      return Future.value(collection);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoEntryModel> getToDoEntry(
      {required String collectionId, required String entryId}) {
    try {
      if (!toDoEntries.containsKey(collectionId)) {
        throw CollectionNotFoundException(collectionId: collectionId);
      }
      final entry = toDoEntries[collectionId]!.firstWhere(
        (element) => element.id == entryId,
        orElse: () => throw EntryNotFoundException(
          entryId: entryId,
          collectionId: collectionId,
        ),
      );

      return Future.value(entry);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) {
    try {
      if (!toDoEntries.containsKey(collectionId)) {
        throw CollectionNotFoundException(collectionId: collectionId);
      }
      return Future.value(
        toDoEntries[collectionId]?.map((collection) => collection.id).toList(),
      );
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry({
    required String collectionId,
    required String entryId,
    required bool isDone,
  }) {
    try {
      if (!toDoEntries.containsKey(collectionId)) {
        throw CollectionNotFoundException(collectionId: collectionId);
      }
      final entryIndex = toDoEntries[collectionId]!.indexWhere(
        (element) => element.id == entryId,
      );
      if (entryIndex == -1) {
        throw EntryNotFoundException(
          entryId: entryId,
          collectionId: collectionId,
        );
      }
      final toDoEntry = toDoEntries[collectionId]![entryIndex];
      final updatedEntry = ToDoEntryModel(
        id: entryId,
        description: toDoEntry.description,
        isDone: isDone,
      );

      toDoEntries[collectionId]![entryIndex] = updatedEntry;
      return Future.value(updatedEntry);
    } on Exception catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<bool> removeToDoEntry({
    required String collectionId,
    required String entryId,
  }) {
    try {
      if (!toDoEntries.containsKey(collectionId)) {
        throw CollectionNotFoundException(collectionId: collectionId);
      }

      final entryIndex = toDoEntries[collectionId]!
          .indexWhere((element) => element.id == entryId);
      if (entryIndex == -1) {
        throw EntryNotFoundException(
            entryId: entryId, collectionId: collectionId);
      }

      toDoEntries[collectionId]!.removeAt(entryIndex);

      return Future.value(true);
    } on Exception catch (_) {
      throw CacheException();
    }
  }
}
