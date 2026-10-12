/// Date rules for salary cycles. A cycle starts on a salary day and ends the
/// day before the next one. Salary days past a month's end (29–31) fall on
/// that month's last day.
class CycleDates {
  const CycleDates._();

  static DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Salary date in [year]/[month]; [month] may overflow (13 = next January).
  static DateTime salaryDateIn(int salaryDay, int year, int month) {
    final first = DateTime(year, month, 1);
    final lastDay = DateTime(first.year, first.month + 1, 0).day;
    return DateTime(
        first.year, first.month, salaryDay > lastDay ? lastDay : salaryDay);
  }

  /// Start of the cycle that contains [today]: the latest salary date on or
  /// before it.
  static DateTime currentCycleStart(int salaryDay, DateTime today) {
    final t = _day(today);
    final thisMonth = salaryDateIn(salaryDay, t.year, t.month);
    return thisMonth.isAfter(t)
        ? salaryDateIn(salaryDay, t.year, t.month - 1)
        : thisMonth;
  }

  /// First salary date strictly after [date].
  static DateTime nextSalaryDateAfter(int salaryDay, DateTime date) {
    final d = _day(date);
    final thisMonth = salaryDateIn(salaryDay, d.year, d.month);
    return thisMonth.isAfter(d)
        ? thisMonth
        : salaryDateIn(salaryDay, d.year, d.month + 1);
  }

  /// Last day of a cycle starting on [start]: the day before the next salary.
  static DateTime cycleEnd(int salaryDay, DateTime start) =>
      dayBefore(nextSalaryDateAfter(salaryDay, start));

  // Calendar arithmetic, not Duration: stays at midnight across DST changes
  static DateTime dayBefore(DateTime d) => DateTime(d.year, d.month, d.day - 1);
  static DateTime dayAfter(DateTime d) => DateTime(d.year, d.month, d.day + 1);
}
