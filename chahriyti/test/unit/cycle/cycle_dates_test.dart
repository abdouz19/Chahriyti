import 'package:flutter_test/flutter_test.dart';

import 'package:chahriyti/domain/value_objects/cycle_dates.dart';

void main() {
  test('salary day past month end falls on last day', () {
    expect(CycleDates.salaryDateIn(31, 2026, 2), DateTime(2026, 2, 28));
    expect(CycleDates.salaryDateIn(31, 2026, 13), DateTime(2027, 1, 31));
  });

  test('current cycle start before salary day of a short previous month', () {
    // Salary day 31, mid-March: cycle started Feb 28, not "Feb 31" = Mar 3
    final start = CycleDates.currentCycleStart(31, DateTime(2026, 3, 15));
    expect(start, DateTime(2026, 2, 28));
    expect(CycleDates.cycleEnd(31, start), DateTime(2026, 3, 30));
  });

  test('current cycle start on salary day is that day', () {
    expect(CycleDates.currentCycleStart(5, DateTime(2026, 10, 5)),
        DateTime(2026, 10, 5));
  });

  test('cycle end across year boundary', () {
    expect(CycleDates.cycleEnd(5, DateTime(2026, 12, 5)), DateTime(2027, 1, 4));
  });
}
