import 'package:data_structures/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('opens a data structure and performs an insertion', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: DataStructuresApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Arrays'));
    await tester.pumpAndSettle();
    expect(find.text('Arrays'), findsWidgets);

    await tester.tap(find.widgetWithText(ActionChip, 'Insert'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '42');
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('42'), findsWidgets);
  });
}
