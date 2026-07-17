import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/presentation/financial_setup/widgets/lendings_step_widget.dart';

void main() {
  Widget buildWidget({
    List<LendingEntity> lendings = const [],
    Future<void> Function(String, int)? onAdd,
    Future<void> Function(int, String, int)? onEdit,
    Future<void> Function(int)? onDelete,
    VoidCallback? onNext,
    VoidCallback? onSkip,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: LendingsStepWidget(
            lendings: lendings,
            onAdd: onAdd ?? (_, __) async {},
            onEdit: onEdit ?? (_, __, ___) async {},
            onDelete: onDelete ?? (_) async {},
            onNext: onNext ?? () {},
            onSkip: onSkip ?? () {},
            onBack: onBack ?? () {},
          ),
        ),
      ),
    );
  }

  group('LendingsStepWidget', () {
    testWidgets('shows empty state when no lendings', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('لا توجد سلفات'), findsOneWidget);
      expect(find.text('من يدين لك بالمال؟'), findsOneWidget);
    });

    testWidgets('shows lending cards when lendings exist', (tester) async {
      final lendings = [
        LendingEntity(
          id: 1,
          borrowerName: 'أحمد',
          totalAmount: 30000,
          collectedAmount: 0,
          fromSavings: false,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(buildWidget(lendings: lendings));
      expect(find.text('أحمد'), findsOneWidget);
      expect(find.text('30000 دج'), findsOneWidget);
    });

    testWidgets('Next button calls onNext', (tester) async {
      var nextCalled = false;
      await tester.pumpWidget(buildWidget(
        lendings: [
          LendingEntity(
            id: 1,
            borrowerName: 'Test',
            totalAmount: 1000,
            collectedAmount: 0,
            fromSavings: false,
            createdAt: DateTime.now(),
          ),
        ],
        onNext: () => nextCalled = true,
      ));

      await tester.tap(find.text('التالي'));
      expect(nextCalled, isTrue);
    });

    testWidgets('Skip button calls onSkip when no lendings', (tester) async {
      var skipCalled = false;
      await tester.pumpWidget(buildWidget(
        onSkip: () => skipCalled = true,
      ));

      await tester.tap(find.text('تخطي'));
      expect(skipCalled, isTrue);
    });

    testWidgets('add button shows correct text', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('إضافة أول سلفة'), findsOneWidget);

      await tester.pumpWidget(buildWidget(lendings: [
        LendingEntity(
          id: 1,
          borrowerName: 'Test',
          totalAmount: 1000,
          collectedAmount: 0,
          fromSavings: false,
          createdAt: DateTime.now(),
        ),
      ]));
      expect(find.text('إضافة سلفة أخرى'), findsOneWidget);
    });
  });
}
