import 'package:bloc_test/bloc_test.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/failures/failures.dart';
import 'package:todo_app/1_domain/use_cases/load_todo_collections.dart';
import 'package:todo_app/2_application/pages/overview/bloc/overview_cubit.dart';
import 'package:todo_app/core/use_case.dart';

class MockLoadToDoCollectionUseCases extends Mock
    implements LoadToDoCollections {}

void main() {
  final mockOverviewUseCases = MockLoadToDoCollectionUseCases();

  group('OverviewCubit', () {
    group('should emit', () {
      blocTest(
        'nothing when no method is called',
        build: () => OverviewCubit(loadToDoCollections: mockOverviewUseCases),
        expect: () => const <OverviewCubitState>[],
      );

      blocTest(
        '[OverviewLoading, OverviewLoaded] when ToDo collections correctly fetched',
        setUp: () => when(() => mockOverviewUseCases.call(NoParams()))
            .thenAnswer((invocation) =>
                Future.value(const Right<Failure, List<ToDoCollection>>([]))),
        build: () => OverviewCubit(loadToDoCollections: mockOverviewUseCases),
        act: (cubit) => cubit.readToDoCollections(),
        expect: () => <OverviewCubitState>[
          OverviewCubitLoadingState(),
          const OverviewCubitLoadedState(
            collections: [],
          )
        ],
      );

      blocTest(
        '[OverviewLoading, OverviewError] with a ServerFailure',
        setUp: () => when(() => mockOverviewUseCases.call(NoParams()))
            .thenAnswer((invocation) => Future.value(
                  Left<Failure, List<ToDoCollection>>(
                    ServerFailure(stackTrace: 'error trace'),
                  ),
                )),
        build: () => OverviewCubit(loadToDoCollections: mockOverviewUseCases),
        act: (cubit) => cubit.readToDoCollections(),
        expect: () => <OverviewCubitState>[
          OverviewCubitLoadingState(),
          OverviewCubitErrorState(),
        ],
      );
    });
  });
}
