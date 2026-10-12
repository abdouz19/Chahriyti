/// How the financial setup records money spent before the app was installed:
/// an expense, so the balance matches what the user entered. It counts in
/// the balance but is not spending the app saw, so statistics exclude it.
abstract final class SetupAdjustment {
  static const expenseCategory = 'أخرى';
  static const expenseItem = 'رصيد قبل التطبيق';
}
