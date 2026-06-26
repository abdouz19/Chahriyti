extension MoneyFormatting on int {
  String toDZDString() {
    final formatted = _formatWithThousands(this);
    return '$formatted دج';
  }

  String toFormattedNumber() {
    return _formatWithThousands(this);
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
}

extension CentimesToDZD on int {
  int get toDZD => this ~/ 100;
  String toDZDFormatted() => toDZD.toDZDString();
}
