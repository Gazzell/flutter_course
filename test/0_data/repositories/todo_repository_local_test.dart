import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_app/0_data/data_sources/local/hive_local_data_source.dart';
import 'package:todo_app/0_data/exceptions/exceptions.dart';
import 'package:todo_app/0_data/models/todo_collection_model.dart';
import 'package:todo_app/0_data/models/todo_entry_model.dart';
import 'package:todo_app/0_data/repositories/todo_repository_local.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/todo_entry.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';

class HiveLocalDataSourceMock extends Mock implements HiveLocalDataSource {}

void main() {
  group('ToDoRepositoryLocal', () {
    group('createTodoCollection', () {
      setUpAll(() {
        registerFallbackValue(
          const ToDoCollectionModel(
            id: '1',
            colorIndex: 1,
            title: '',
          ),
        );
      });

      group('should return Right', () {
        test('when successfully created collection', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(() => hiveLocalDataSourceMock.createToDoCollection(
                collection: any(named: 'collection'),
              )).thenAnswer((invocation) => Future.value(true));

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal
              .createTodoCollection(ToDoCollection.empty());

          expect(result, const Right<Failure, bool>(true));
          verify(() => hiveLocalDataSourceMock.createToDoCollection(
              collection: any(named: 'collection'))).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(() => hiveLocalDataSourceMock.createToDoCollection(
                collection: any(named: 'collection'),
              )).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal
              .createTodoCollection(ToDoCollection.empty());

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(() => hiveLocalDataSourceMock.createToDoCollection(
                collection: any(named: 'collection'),
              )).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal
              .createTodoCollection(ToDoCollection.empty());

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });

    group('createTodoEntryItem', () {
      setUpAll(() {
        registerFallbackValue(
          const ToDoEntryModel(
            id: '1',
            description: '',
            isDone: false,
          ),
        );
      });

      group('should return Right', () {
        test('when successfully created entry item', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.createToDoEntry(
              collectionId: any(named: 'collectionId'),
              entry: any(named: 'entry'),
            ),
          ).thenAnswer((invocation) => Future.value(true));

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.createTodoEntryItem(
            CollectionId.fromUniqueString('0'),
            ToDoEntry.empty(),
          );

          expect(result, const Right<Failure, bool>(true));
          verify(
            () => hiveLocalDataSourceMock.createToDoEntry(
              collectionId: any(named: 'collectionId'),
              entry: any(named: 'entry'),
            ),
          ).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.createToDoEntry(
              collectionId: any(named: 'collectionId'),
              entry: any(named: 'entry'),
            ),
          ).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.createTodoEntryItem(
            CollectionId.fromUniqueString('0'),
            ToDoEntry.empty(),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.createToDoEntry(
              collectionId: any(named: 'collectionId'),
              entry: any(named: 'entry'),
            ),
          ).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.createTodoEntryItem(
            CollectionId.fromUniqueString('0'),
            ToDoEntry.empty(),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });

    group('readTodoCollections', () {
      group('should return Right', () {
        test('when successfully read ToDo collections', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getCollectionIds(),
          ).thenAnswer((invocation) => Future.value(['0']));

          when(() =>
                  hiveLocalDataSourceMock.getToDoCollection(collectionId: '0'))
              .thenAnswer(
            (invocation) => Future.value(
              const ToDoCollectionModel(
                id: '0',
                colorIndex: 1,
                title: '',
              ),
            ),
          );

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoCollections();

          expect(result.isRight, true);
          expect(
            result.right,
            [
              ToDoCollection(
                  id: CollectionId.fromUniqueString('0'),
                  color: const ToDoColor(colorIndex: 1),
                  title: ''),
            ],
          );

          verify(() => hiveLocalDataSourceMock.getCollectionIds()).called(1);
          verify(
            () => hiveLocalDataSourceMock.getToDoCollection(collectionId: '0'),
          ).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getCollectionIds(),
          ).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoCollections();

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getCollectionIds(),
          ).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoCollections();

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });

    group('readTodoEntriesCollection', () {
      group('should return Right', () {
        test('when successfully read entries collection', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntryIds(
              collectionId: any(named: 'collectionId'),
            ),
          ).thenAnswer((invocation) => Future.value(['0']));

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntriesCollection(
            CollectionId.fromUniqueString('collId'),
          );

          expect(result.isRight, true);
          expect(
            result.right,
            [EntryId.fromUniqueString('0')],
          );

          verify(
            () =>
                hiveLocalDataSourceMock.getToDoEntryIds(collectionId: 'collId'),
          ).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntryIds(
              collectionId: any(named: 'collectionId'),
            ),
          ).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntriesCollection(
            CollectionId.fromUniqueString('collId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntryIds(
              collectionId: any(named: 'collectionId'),
            ),
          ).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntriesCollection(
            CollectionId.fromUniqueString('collId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });

    group('readTodoEntry', () {
      group('should return Right', () {
        test('when successfully read entry item', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
            ),
          ).thenAnswer(
            (invocation) => Future.value(
              const ToDoEntryModel(
                id: '0',
                description: 'desc',
                isDone: false,
              ),
            ),
          );

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntry(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
          );

          expect(result.isRight, true);
          expect(
            result.right,
            ToDoEntry(
              id: EntryId.fromUniqueString('0'),
              description: 'desc',
              isDone: false,
            ),
          );

          verify(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: 'collId',
              entryId: 'eId',
            ),
          ).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
            ),
          ).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntry(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
            ),
          ).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntry(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });

    group('updateTodoEntryIsDone', () {
      group('should return Right', () {
        test('with true when sucessfully updated entry', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.updateToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
              isDone: any(named: 'isDone'),
            ),
          ).thenAnswer(
            (invocation) => Future.value(
              const ToDoEntryModel(
                id: 'eId',
                description: 'desc',
                isDone: true,
              ),
            ),
          );

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.updateTodoEntryIsDone(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
            true,
          );

          expect(result.isRight, true);
          expect(
            result,
            Right<Failure, ToDoEntry>(
              ToDoEntry(
                id: EntryId.fromUniqueString('eId'),
                description: 'desc',
                isDone: true,
              ),
            ),
          );

          verify(
            () => hiveLocalDataSourceMock.updateToDoEntry(
              collectionId: 'collId',
              entryId: 'eId',
              isDone: true,
            ),
          ).called(1);
        });
      });

      group('should return Left', () {
        test('with a CacheFailure when CacheException thrown', () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
            ),
          ).thenThrow(CacheException());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntry(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<CacheFailure>(),
          );
        });

        test('with a ServerFailure if any other expception is thrown',
            () async {
          final hiveLocalDataSourceMock = HiveLocalDataSourceMock();
          when(
            () => hiveLocalDataSourceMock.getToDoEntry(
              collectionId: any(named: 'collectionId'),
              entryId: any(named: 'entryId'),
            ),
          ).thenThrow(Exception());

          final toDoRepositoryLocal = ToDoRepositoryLocal(
            localDataSource: hiveLocalDataSourceMock,
          );

          final result = await toDoRepositoryLocal.readTodoEntry(
            CollectionId.fromUniqueString('collId'),
            EntryId.fromUniqueString('eId'),
          );

          expect(result.isLeft, true);
          expect(
            result.left,
            isA<ServerFailure>(),
          );
        });
      });
    });
  });
}
