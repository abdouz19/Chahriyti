import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/domain/entities/debt_entity.dart';
import 'package:chahriyti/domain/entities/lending_entity.dart';
import 'package:chahriyti/presentation/financial_setup/widgets/summary_step_widget.dart';

void main() {
  Widget buildWidget({
    int balance = 50000,
    int savings = 10000,
    List<DebtEntity>? debts,
    List<LendingEntity>? lendings,
    ValueChanged<int>? onEditStep,
    VoidCallback? onConfirm,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SummaryStepWidget(
            balance: balance,
            savings: savings,
            debts: debts ?? [],
            lendings: lendings ?? [],
            onEditStep: onEditStep ?? (_) {},
            onConfirm: onConfirm ?? () {},
            onBack: onBack ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('displays balance and savings amounts', (tester) async {
    await tester.pumpWidget(buildWidget(balance: 50000, savings: 10000));
    await tester.pumpAndSettle();

    expect(find.text('50000 دج'), findsOneWidget);
    expect(find.text('10000 دج'), findsOneWidget);
    expect(find.text('الرصيد'), findsOneWidget);
    expect(find.text('المدخرات'), findsOneWidget);
  });

  testWidgets('displays debt and lending entries', (tester) async {
    final debts = [
      DebtEntity(
        id: 1,
        creditorName: 'أحمد',
        totalAmount: 5000,
        paidAmount: 0,
        isFullyPaid: false,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];
    final lendings = [
      LendingEntity(
        id: 1,
        borrowerName: 'سعيد',
        totalAmount: 3000,
        createdAt: DateTime(2026, 1, 1),
      ),
    ];

    await tester.pumpWidget(buildWidget(debts: debts, lendings: lendings));
    await tester.pumpAndSettle();

    expect(find.text('أحمد: 5000 دج'), findsOneWidget);
    expect(find.text('سعيد: 3000 دج'), findsOneWidget);
    expect(find.text('الديون'), findsOneWidget);
    expect(find.text('السلفات'), findsOneWidget);
  });

  testWidgets('Confirm button calls onConfirm', (tester) async {
    var confirmed = false;
    await tester.pumpWidget(buildWidget(onConfirm: () => confirmed = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تأكيد وبدء الاستخدام'));
    await tester.pumpAndSettle();

    expect(confirmed, isTrue);
  });
}
