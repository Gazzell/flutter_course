import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class Params extends Equatable {}

class NoParams extends Params {
  @override
  List<Object?> get props => [];
}

class ToDoEntryIdsParams extends Params {
  final CollectionId collectionId;
  final EntryId entryId;

  ToDoEntryIdsParams({
    required this.collectionId,
    required this.entryId,
  }) : super();

  @override
  List<Object> get props => [collectionId, entryId];
}

class ToDoEntryIdsUdpateParams extends Params {
  final CollectionId collectionId;
  final EntryId entryId;
  final bool isDone;

  ToDoEntryIdsUdpateParams({
    required this.collectionId,
    required this.entryId,
    required this.isDone,
  }) : super();

  @override
  List<Object?> get props => [collectionId, entryId, isDone];
}

class ToDoEntriesCollectionParams extends Params {
  final CollectionId collectionId;

  ToDoEntriesCollectionParams({required this.collectionId});

  @override
  List<Object?> get props => [collectionId];
}

class ToDoCollectionParams extends Params {
  final ToDoCollection collection;

  ToDoCollectionParams({
    required this.collection,
  });

  @override
  List<Object?> get props => [collection];
}
