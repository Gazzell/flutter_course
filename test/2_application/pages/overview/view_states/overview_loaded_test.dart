import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/1_domain/entities/todo_collection.dart';
import 'package:todo_app/1_domain/entities/todo_color.dart';
import 'package:todo_app/1_domain/entities/unique_id.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loaded.dart';

void main() {
  List<ToDoCollection> generateToDoCollection(int count) {
    return List<ToDoCollection>.generate(
      count,
      (index) => ToDoCollection(
        id: CollectionId.fromUniqueString(index.toString()),
        title: 'title $index',
        color: ToDoColor(value: index % ToDoColor.predefinedColors.length),
      ),
    );
  }

  Widget widgetUnderTest({required List<ToDoCollection> collections}) {
    return MaterialApp(
      home: Material(child: OverviewLoaded(collections: collections)),
    );
  }

  group('OverviewLoaded', () {
    group('should render', () {
      testWidgets(
        'ToDo collections',
        (widgetTester) async {
          final List<ToDoCollection> fakeCollections =
              generateToDoCollection(5);

          await widgetTester.pumpWidget(
            widgetUnderTest(collections: fakeCollections),
          );

          await widgetTester.pump();

          final listTileFinder = find.byType(ListTile);
          expect(listTileFinder, findsNWidgets(5));
        },
      );
    });
  });
}
