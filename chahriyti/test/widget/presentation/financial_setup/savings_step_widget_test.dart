import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/financial_setup/widgets/savings_step_widget.dart';

void main() {
  Widget buildWidget({
    int? initialValue,
    ValueChanged<int>? onNext,
    VoidCallback? onSkip,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SavingsStepWidget(
            initialValue: initialValue,
            onNext: onNext ?? (_) {},
            onSkip: onSkip ?? () {},
            onBack: onBack ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders prompt and help text', (tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();

    expect(find.text('المال المُدّخر للمستقبل؟'), findsOneWidget);
    expect(
      find.text('صندوق الطوارئ، أهداف الادخار، أو أي مبلغ جانبي.'),
      findsOneWidget,
    );
  });

  testWidgets('Skip button calls onSkip', (tester) async {
    var skipped = false;
    await tester.pumpWidget(buildWidget(onSkip: () => skipped = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(skipped, isTrue);
  });

  testWidgets('Next button calls onNext with amount', (tester) async {
    int? result;
    await tester.pumpWidget(buildWidget(onNext: (v) => result = v));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '10000');
    await tester.pumpAndSettle();

    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(result, 10000);
  });
}
