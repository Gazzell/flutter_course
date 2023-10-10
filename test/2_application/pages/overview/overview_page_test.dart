import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/2_application/pages/overview/bloc/overview_cubit.dart';
import 'package:todo_app/2_application/pages/overview/overview_page.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_error.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loaded.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loading.dart';

class MockOverviewCubit extends MockCubit<OverviewCubitState>
    implements OverviewCubit {}

void main() {
  Widget widgetUnderTest({required OverviewCubit cubit}) {
    return MaterialApp(
      home: Material(
        child: BlocProvider<OverviewCubit>(
          create: (context) => cubit,
          child: const OverviewPage(),
        ),
      ),
    );
  }

  group(
    'OverviewPage',
    () {
      group(
        'should be displayed in ViewState',
        () {
          late OverviewCubit mockOverviewCubit;

          setUp(() => mockOverviewCubit = MockOverviewCubit());

          testWidgets('OverviewLoading when started', (widgetTester) async {
            whenListen(
              mockOverviewCubit,
              Stream.fromIterable([OverviewCubitLoadingState()]),
              initialState: OverviewCubitLoadingState(),
            );

            await widgetTester
                .pumpWidget(widgetUnderTest(cubit: mockOverviewCubit));

            await widgetTester.pump();

            final overviewLoadingFinder = find.byType(OverviewLoading);

            expect(overviewLoadingFinder, findsOneWidget);
          });

          testWidgets(
            'OverviewLoaded when cubit emits OverviewCubitStateLoaded()',
            (widgetTester) async {
              whenListen(
                mockOverviewCubit,
                Stream.fromIterable(
                  [const OverviewCubitLoadedState(collections: [])],
                ),
                initialState: OverviewCubitLoadingState(),
              );

              await widgetTester.pumpWidget(
                widgetUnderTest(cubit: mockOverviewCubit),
              );

              await widgetTester.pump();

              final overviewLoadedFinder = find.byType(OverviewLoaded);

              expect(overviewLoadedFinder, findsOneWidget);
            },
          );

          testWidgets(
            'OverviewError when cubit emits OverviewCubitStateError',
            (widgetTester) async {
              whenListen(
                  mockOverviewCubit,
                  Stream.fromIterable(
                    [OverviewCubitErrorState()],
                  ),
                  initialState: OverviewCubitLoadingState());

              await widgetTester.pumpWidget(
                widgetUnderTest(cubit: mockOverviewCubit),
              );

              await widgetTester.pump();

              final overviewErrorFinder = find.byType(OverviewError);

              expect(overviewErrorFinder, findsOneWidget);
            },
          );
        },
      );
    },
  );
}
