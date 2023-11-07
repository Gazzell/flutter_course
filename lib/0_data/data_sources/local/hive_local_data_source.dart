import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_local_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';

class HiveLocalDataSource implements ToDoLocalSourceInterface {
  late BoxCollection todoCollections;
  bool isInitialised = false;

  Future<void> init() async {
    if (isInitialised) {
      debugPrint('Hive already initialised!');
      return;
    }

    todoCollections = await BoxCollection.open(
      'todo',
      {'collection', 'entry'},
      path: './',
    );
    isInitialised = true;
  }

  Future<CollectionBox<Map>> _openCollectionBox() async {
    return todoCollections.openBox<Map>('collection');
  }

  Future<CollectionBox<Map>> _openEntryBox() async {
    return todoCollections.openBox<Map>('entry');
  }

  @override
  Future<bool> createToDoCollection({
    required ToDoCollectionModel collection,
  }) async {
    final collectionBox = await _openCollectionBox();
    final entryBox = await _openEntryBox();
    await collectionBox.put(collection.id, collection.toJson());
    await entryBox.put(collection.id, {});
    return true;
  }

  @override
  Future<bool> createToDoEntry({
    required String collectionId,
    required ToDoEntryModel entry,
  }) async {
    final entryBox = await _openEntryBox();
    final entryList = await entryBox.get(collectionId);
    if (entryList == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }
    entryList
        .cast<String, dynamic>()
        .putIfAbsent(entry.id, () => entry.toJson());
    await entryBox.put(collectionId, entryList);
    return true;
  }

  @override
  Future<List<String>> getCollectionIds() async {
    final collectionBox = await _openCollectionBox();
    return await collectionBox.getAllKeys();
  }

  @override
  Future<ToDoCollectionModel> getToDoCollection({
    required String collectionId,
  }) async {
    final collectionBox = await _openCollectionBox();
    final collection = await collectionBox.get(collectionId);
    if (collection == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }
    return ToDoCollectionModel.fronJson(collection.cast<String, dynamic>());
  }

  @override
  Future<ToDoEntryModel> getToDoEntry({
    required String collectionId,
    required String entryId,
  }) async {
    final entryBox = await _openEntryBox();
    final entryList = await entryBox.get(collectionId);
    if (entryList == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }
    if (!entryList.containsKey(entryId)) {
      throw EntryNotFoundException(
        entryId: entryId,
        collectionId: collectionId,
      );
    }

    final entry = entryList[entryId].cast<String, dynamic>();
    return ToDoEntryModel.fromJson(entry);
  }

  @override
  Future<List<String>> getToDoEntryIds({required String collectionId}) async {
    final entryBox = await _openEntryBox();
    final entryList = await entryBox.get(collectionId);
    if (entryList == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }
    final entryIdList = entryList.cast<String, dynamic>().keys;
    return entryIdList.toList();
  }

  @override
  Future<ToDoEntryModel> updateToDoEntry({
    required String collectionId,
    required String entryId,
    required bool isDone,
  }) async {
    final entryBox = await _openEntryBox();
    final entryList = await entryBox.get(collectionId);

    if (entryList == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }

    final entry = entryList[entryId]?.cast<String, dynamic>();

    if (entry == null) {
      throw EntryNotFoundException(
        entryId: entryId,
        collectionId: collectionId,
      );
    }

    entry['isDone'] = isDone;
    entryList[entryId] = entry;

    await entryBox.put(collectionId, entryList);

    return ToDoEntryModel.fromJson(entry);
  }

  @override
  Future<bool> removeToDoEntry({
    required String collectionId,
    required String entryId,
  }) async {
    final entryBox = await _openEntryBox();
    final entryList =
        (await entryBox.get(collectionId))?.cast<String, dynamic>();

    if (entryList == null) {
      throw CollectionNotFoundException(collectionId: collectionId);
    }

    if (entryList[entryId] == null) {
      throw EntryNotFoundException(
        entryId: entryId,
        collectionId: collectionId,
      );
    }
    entryList.remove(entryId);

    await entryBox.put(collectionId, entryList);
    return Future.value(true);
  }
}
