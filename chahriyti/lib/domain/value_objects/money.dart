import 'package:equatable/equatable.dart';

class Money extends Equatable {
  final int centimes;

  const Money(this.centimes);
  const Money.zero() : centimes = 0;
  const Money.fromDZD(int dzd) : centimes = dzd * 100;

  double get toDZD => centimes / 100;
  bool get isZero => centimes == 0;
  bool get isPositive => centimes > 0;
  bool get isNegative => centimes < 0;

  Money operator +(Money other) => Money(centimes + other.centimes);
  Money operator -(Money other) => Money(centimes - other.centimes);
  bool operator >(Money other) => centimes > other.centimes;
  bool operator <(Money other) => centimes < other.centimes;
  bool operator >=(Money other) => centimes >= other.centimes;
  bool operator <=(Money other) => centimes <= other.centimes;

  String formatDZD() {
    final dzd = centimes ~/ 100;
    final formatted = _formatWithThousands(dzd);
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
  List<Object?> get props => [centimes];

  @override
  String toString() => formatDZD();
}
