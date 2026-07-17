import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/presentation/financial_setup/widgets/welcome_step_widget.dart';

void main() {
  Widget buildWidget({VoidCallback? onStart}) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: WelcomeStepWidget(
            onStart: onStart ?? () {},
          ),
        ),
      ),
    );
  }

  testWidgets('renders title and subtitle text', (tester) async {
    await tester.pumpWidget(buildWidget());
    await tester.pumpAndSettle();

    expect(find.text('إعداد وضعك المالي'), findsOneWidget);
    expect(
      find.text('سيستغرق دقيقتين فقط.\nيمكنك التعديل لاحقًا في أي وقت.'),
      findsOneWidget,
    );
  });

  testWidgets('Start button calls onStart callback', (tester) async {
    var called = false;
    await tester.pumpWidget(buildWidget(onStart: () => called = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ابدأ'));
    await tester.pumpAndSettle();

    expect(called, isTrue);
  });
}
