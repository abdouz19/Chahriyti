import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/shared/widgets/payment_source_toggle.dart';

void main() {
  Widget buildWidget({
    int currentBalance = 10000,
    int savingsBalance = 5000,
    bool fromSavings = false,
    ValueChanged<bool>? onChanged,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: PaymentSourceToggle(
          currentBalance: currentBalance,
          savingsBalance: savingsBalance,
          fromSavings: fromSavings,
          onChanged: onChanged ?? (_) {},
        ),
      ),
    );
  }

  testWidgets('renders two options with amounts', (tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();

    expect(find.text('الرصيد الحالي'), findsOneWidget);
    expect(find.text('المدخرات'), findsOneWidget);
  });

  testWidgets('default is current balance selected', (tester) async {
    await tester.pumpWidget(buildWidget(fromSavings: false));
    await tester.pumpAndSettle();

    // The current balance option should be selected (fromSavings = false)
    expect(find.text('الرصيد الحالي'), findsOneWidget);
    expect(find.text('المدخرات'), findsOneWidget);
  });

  testWidgets('tapping savings calls onChanged with true', (tester) async {
    bool? result;
    await tester.pumpWidget(buildWidget(
      onChanged: (value) => result = value,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('المدخرات'));
    await tester.pumpAndSettle();

    expect(result, true);
  });

  testWidgets('tapping current balance calls onChanged with false',
      (tester) async {
    bool? result;
    await tester.pumpWidget(buildWidget(
      fromSavings: true,
      onChanged: (value) => result = value,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('الرصيد الحالي'));
    await tester.pumpAndSettle();

    expect(result, false);
  });

  testWidgets('hidden when savings balance is 0', (tester) async {
    await tester.pumpWidget(buildWidget(savingsBalance: 0));
    await tester.pumpAndSettle();

    expect(find.text('الرصيد الحالي'), findsNothing);
    expect(find.text('المدخرات'), findsNothing);
  });

  testWidgets('hidden when savings balance is negative', (tester) async {
    await tester.pumpWidget(buildWidget(savingsBalance: -100));
    await tester.pumpAndSettle();

    expect(find.text('الرصيد الحالي'), findsNothing);
    expect(find.text('المدخرات'), findsNothing);
  });
}
