import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/financial_setup/widgets/balance_step_widget.dart';

void main() {
  Widget buildWidget({
    int? initialValue,
    ValueChanged<int>? onNext,
    VoidCallback? onBack,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BalanceStepWidget(
            initialValue: initialValue,
            onNext: onNext ?? (_) {},
            onBack: onBack ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders prompt text and help text', (tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();

    expect(find.text('كم من المال لديك الآن؟'), findsOneWidget);
    expect(
      find.text('تحقق من حسابك البنكي، محفظتك، والنقد المتوفر.'),
      findsOneWidget,
    );
  });

  testWidgets('Next button calls onNext with entered amount', (tester) async {
    int? result;
    await tester.pumpWidget(buildWidget(onNext: (v) => result = v));
    await tester.pumpAndSettle();

    // Enter an amount into the text field
    await tester.enterText(find.byType(TextFormField), '50000');
    await tester.pumpAndSettle();

    // Tap the Next button
    await tester.tap(find.text('التالي'));
    await tester.pumpAndSettle();

    expect(result, 50000);
  });
}
