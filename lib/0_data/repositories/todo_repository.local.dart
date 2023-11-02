import 'package:either_dart/src/either.dart';
import 'package:todo_app/0_data/data_sources/interfaces/todo_local_source_interface.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/repositories/todo_repository.dart';

class ToDoRepositoryLocal implements ToDoRepository {
  final ToDoLocalSourceInterface localDataSource;
  const ToDoRepositoryLocal({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> createTodoCollection(
      ToDoCollection collection) async {
    try {
      final result = await localDataSource.createToDoCollection(
        collection: toDoCollectionToModel(collection),
      );
      return Right(result);
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> createTodoEntryItem(
      CollectionId collectionId, ToDoEntry entry) async {
    try {
      final result = await localDataSource.createToDoEntry(
        collectionId: collectionId.value,
        entry: toDoEntryToModel(entry),
      );
      return Right(result);
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<ToDoCollection>>> readTodoCollections() async {
    try {
      final collectionIds = await localDataSource.getCollectionIds();
      final List<ToDoCollection> collections = [];

      Future.forEach(collectionIds, (collectionId) async {
        final collection = await localDataSource.getToDoCollection(
          collectionId: collectionId,
        );
        collections.add(toDoCollectionModelToEntity(collection));
      });

      return Right(collections);
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<EntryId>>> readTodoEntriesCollection(
      CollectionId collectionId) async {
    try {
      final result = await localDataSource.getToDoEntryIds(
        collectionId: collectionId.value,
      );
      return Right(
        result.map((entryId) => EntryId.fromUniqueString(entryId)).toList(),
      );
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> readTodoEntry(
    CollectionId collectionId,
    EntryId entryId,
  ) async {
    try {
      final result = await localDataSource.getToDoEntry(
        collectionId: collectionId.value,
        entryId: entryId.value,
      );
      return Right(toDoEntryModelToEntity(result));
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  @override
  Future<Either<Failure, ToDoEntry>> updateTodoEntryIsDone(
    CollectionId collectionId,
    EntryId entryId,
    bool isDone,
  ) async {
    try {
      final result = await localDataSource.updateToDoEntry(
        collectionId: collectionId.value,
        entryId: entryId.value,
      );
      return Right(toDoEntryModelToEntity(result));
    } on CacheException catch (e) {
      return Future.value(Left(CacheFailure(stackTrace: e.toString())));
    } on Exception catch (e) {
      return Future.value(Left(ServerFailure(stackTrace: e.toString())));
    }
  }

  ToDoEntryModel toDoEntryToModel(ToDoEntry entry) {
    return ToDoEntryModel(
      id: entry.id.value,
      description: entry.description,
      isDone: entry.isDone,
    );
  }

  ToDoCollectionModel toDoCollectionToModel(ToDoCollection collection) {
    return ToDoCollectionModel(
      id: collection.id.value,
      colorIndex: collection.color.colorIndex,
      title: collection.title,
    );
  }

  ToDoEntry toDoEntryModelToEntity(ToDoEntryModel entryModel) {
    return ToDoEntry(
      id: EntryId.fromUniqueString(entryModel.id),
      description: entryModel.description,
      isDone: entryModel.isDone,
    );
  }

  ToDoCollection toDoCollectionModelToEntity(
      ToDoCollectionModel collectionModel) {
    return ToDoCollection(
      id: CollectionId.fromUniqueString(collectionModel.id),
      title: collectionModel.title,
      color: ToDoColor(colorIndex: collectionModel.colorIndex),
    );
  }
}
