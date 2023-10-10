import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/2_application/pages/overview/view_states/overview_loading.dart';

void main() {
  group('OverviewLoading', () {
    group('ahould render', () {
      testWidgets('progress indicator', (widgetTester) async {
        await widgetTester.pumpWidget(const OverviewLoading());

        await widgetTester.pump();

        final loadingIndicatorFinder = find.byType(CircularProgressIndicator);

        expect(loadingIndicatorFinder, findsOneWidget);
      });
    });
  });
}
