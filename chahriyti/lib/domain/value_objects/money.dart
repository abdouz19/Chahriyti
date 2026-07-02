import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final int amount;

  const Money(this.amount);
  const Money.zero() : amount = 0;

  bool get isZero => amount == 0;
  bool get isPositive => amount > 0;
  bool get isNegative => amount < 0;

  Money operator +(Money other) => Money(amount + other.amount);
  Money operator -(Money other) => Money(amount - other.amount);
  bool operator >(Money other) => amount > other.amount;
  bool operator <(Money other) => amount < other.amount;
  bool operator >=(Money other) => amount >= other.amount;
  bool operator <=(Money other) => amount <= other.amount;

  String formatDZD() {
    final formatted = _formatWithThousands(amount);
    return '$formatted دج';
  }

  static String _formatWithThousands(int value) {
    final str = value.abs().toString();
    final buffer = StringBuffer();
    final sign = value < 0 ? '-' : '';
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
    }
    return '$sign$buffer';
  }

  @override
  List<Object?> get props => [amount];

  @override
  String toString() => formatDZD();
}
