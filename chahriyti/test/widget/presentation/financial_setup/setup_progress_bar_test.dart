import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/financial_setup/widgets/setup_progress_bar.dart';

void main() {
  Widget buildWidget({
    int currentStep = 2,
    int totalSteps = 6,
  }) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SetupProgressBar(
            currentStep: currentStep,
            totalSteps: totalSteps,
          ),
        ),
      ),
    );
  }

  testWidgets('renders progress bar with correct step text', (tester) async {
    await tester.pumpWidget(buildWidget(currentStep: 3, totalSteps: 6));
    await tester.pumpAndSettle();

    expect(find.text('3 / 6'), findsOneWidget);
  });

  testWidgets('progress indicator value matches currentStep/totalSteps',
      (tester) async {
    await tester.pumpWidget(buildWidget(currentStep: 2, totalSteps: 6));
    await tester.pumpAndSettle();

    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, closeTo(2 / 6, 0.001));
  });
}
