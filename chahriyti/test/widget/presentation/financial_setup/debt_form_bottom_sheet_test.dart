import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/financial_setup/widgets/debt_form_bottom_sheet.dart';

void main() {
  group('DebtFormBottomSheet', () {
    testWidgets('renders add mode title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(),
          ),
        ),
      );
      expect(find.text('إضافة دَيْن'), findsOneWidget);
    });

    testWidgets('renders edit mode title with initial values', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(
              initialName: 'البنك',
              initialAmount: 50000,
            ),
          ),
        ),
      );
      expect(find.text('تعديل الدَّيْن'), findsOneWidget);
    });

    testWidgets('validates empty name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(),
          ),
        ),
      );

      // Enter amount but leave name empty
      await tester.enterText(
        find.byType(TextFormField).last,
        '5000',
      );
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.text('يجب إدخال الاسم'), findsOneWidget);
    });

    testWidgets('validates empty amount', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(),
          ),
        ),
      );

      // Enter name but leave amount empty
      await tester.enterText(
        find.byType(TextFormField).first,
        'البنك',
      );
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      expect(find.text('يجب إدخال المبلغ'), findsOneWidget);
    });

    testWidgets('shows delete button in edit mode', (tester) async {
      var deleteCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(
              initialName: 'Test',
              initialAmount: 1000,
              onDelete: () => deleteCalled = true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete_outline));
      expect(deleteCalled, isTrue);
    });

    testWidgets('no delete button in add mode', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DebtFormBottomSheet(),
          ),
        ),
      );

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
