import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/presentation/financial_setup/widgets/debts_step_widget.dart';

void main() {
  Widget buildWidget({
    List<DebtEntity> debts = const [],
    Future<void> Function(String, int, bool)? onAdd,
    Future<void> Function(int, String, int, bool)? onEdit,
    Future<void> Function(int)? onDelete,
    VoidCallback? onNext,
    VoidCallback? onSkip,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: DebtsStepWidget(
            debts: debts,
            onAdd: onAdd ?? (_, __, ___) async {},
            onEdit: onEdit ?? (_, __, ___, ____) async {},
            onDelete: onDelete ?? (_) async {},
            onNext: onNext ?? () {},
            onSkip: onSkip ?? () {},
            onBack: onBack ?? () {},
          ),
        ),
      ),
    );
  }

  group('DebtsStepWidget', () {
    testWidgets('shows empty state when no debts', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('لا توجد ديون'), findsOneWidget);
      expect(find.text('لمن أنت مدين؟'), findsOneWidget);
    });

    testWidgets('shows debt cards when debts exist', (tester) async {
      final debts = [
        DebtEntity(
          id: 1,
          creditorName: 'البنك',
          totalAmount: 50000,
          paidAmount: 0,
          isFullyPaid: false,
          createdAt: DateTime.now(),
        ),
        DebtEntity(
          id: 2,
          creditorName: 'صديق',
          totalAmount: 10000,
          paidAmount: 0,
          isFullyPaid: false,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(buildWidget(debts: debts));
      expect(find.text('البنك'), findsOneWidget);
      expect(find.text('صديق'), findsOneWidget);
      expect(find.text('50000 دج'), findsOneWidget);
      expect(find.text('10000 دج'), findsOneWidget);
    });

    testWidgets('Next button calls onNext', (tester) async {
      var nextCalled = false;
      await tester.pumpWidget(buildWidget(
        debts: [
          DebtEntity(
            id: 1,
            creditorName: 'Test',
            totalAmount: 1000,
            paidAmount: 0,
            isFullyPaid: false,
            createdAt: DateTime.now(),
          ),
        ],
        onNext: () => nextCalled = true,
      ));

      await tester.tap(find.text('التالي'));
      expect(nextCalled, isTrue);
    });

    testWidgets('Skip button calls onSkip when no debts', (tester) async {
      var skipCalled = false;
      await tester.pumpWidget(buildWidget(
        onSkip: () => skipCalled = true,
      ));

      await tester.tap(find.text('تخطي'));
      expect(skipCalled, isTrue);
    });

    testWidgets('shows add button with correct text', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('إضافة أول دَيْن'), findsOneWidget);

      await tester.pumpWidget(buildWidget(debts: [
        DebtEntity(
          id: 1,
          creditorName: 'Test',
          totalAmount: 1000,
          paidAmount: 0,
          isFullyPaid: false,
          createdAt: DateTime.now(),
        ),
      ]));
      expect(find.text('إضافة دَيْن آخر'), findsOneWidget);
    });
  });
}
