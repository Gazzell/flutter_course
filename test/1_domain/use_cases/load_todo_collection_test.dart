import 'package:either_dart/either.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:todo_app/0_data/repositories/todo_repository_mock.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/core/use_case.dart';

class ToDoCollectionRepositoryMock extends Mock implements ToDoRepositoryMock {}

void main() {
  group('LoadTodoCollection', () {
    group('should return Right', () {
      test('with a valid ToDoCollection', () async {
        final mockTodoCollectionRepository = ToDoCollectionRepositoryMock();
        final LoadToDoCollections loadToDoCollectionsUseCase =
            LoadToDoCollections(toDoRepository: mockTodoCollectionRepository);
        final collectionsList = List.generate(
          5,
          (index) => ToDoCollection(
            id: CollectionId.fromUniqueString('id $index'),
            title: 'title $index',
            color: ToDoColor(
              value: index % ToDoColor.predefinedColors.length,
            ),
          ),
        );

        when(() => mockTodoCollectionRepository.readTodoCollections())
            .thenAnswer((invocation) => Future.value(Right(collectionsList)));

        final obtainedCollection = await loadToDoCollectionsUseCase(NoParams());

        expect(obtainedCollection,
            Right<Failure, List<ToDoCollection>>(collectionsList));
        verify(() => mockTodoCollectionRepository.readTodoCollections())
            .called(1);
      });
    });

    group('should return Left', () {
      test('with a ServerFailure when exception in repository', () async {
        final mockTodoCollectionRepository = ToDoCollectionRepositoryMock();

        final loadToDoCollectionsUseCase =
            LoadToDoCollections(toDoRepository: mockTodoCollectionRepository);

        when(() => mockTodoCollectionRepository.readTodoCollections())
            .thenAnswer((invocation) =>
                Future.value(Left(ServerFailure(stackTrace: 'trace'))));

        final response = await loadToDoCollectionsUseCase(NoParams());

        expect(
            response,
            Left<Failure, List<ToDoCollection>>(
                ServerFailure(stackTrace: 'trace')));
        verify(() => mockTodoCollectionRepository.readTodoCollections())
            .called(1);
      });
    });
  });
}
