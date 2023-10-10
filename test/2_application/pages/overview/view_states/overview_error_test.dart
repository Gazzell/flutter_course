import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_error.dart';

void main() {
  Widget widgetUnderTest() {
    return const MaterialApp(
      home: OverviewError(),
    );
  }

  group('OverviewError', () {
    group('should render', () {
      testWidgets('error message', (widgetTester) async {
        await widgetTester.pumpWidget(widgetUnderTest());

        await widgetTester.pump();

        final errorFinder = find.text('ERROR, please try again');
        expect(errorFinder, findsOneWidget);
      });
    });
  });
}
