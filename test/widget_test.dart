import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reset_app/main.dart';

void main() {
  group('Delete Files App Widget Tests', () {
    testWidgets('App should have correct title', (WidgetTester tester) async {
      await tester.pumpWidget(const ResetApp());

      expect(find.text('Delete Files App'), findsOneWidget);
    });

    testWidgets('Main delete button should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(const ResetApp());

      expect(find.text('🗑️ DELETAR TODOS OS ARQUIVOS'), findsOneWidget);
    });

    testWidgets('Warning message should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(const ResetApp());

      expect(
        find.textContaining('ATENÇÃO: Esta ação é permanente'),
        findsOneWidget,
      );
    });

    testWidgets('Title and subtitle should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(const ResetApp());

      expect(find.text('Deletar Todos os Arquivos'), findsOneWidget);
      expect(
        find.text('Remove permanentemente TODOS os arquivos do dispositivo'),
        findsOneWidget,
      );
    });

    testWidgets('Delete icon should be visible', (WidgetTester tester) async {
      await tester.pumpWidget(const ResetApp());

      expect(find.byIcon(Icons.delete_forever), findsAtLeastNWidgets(1));
    });
  });
}
