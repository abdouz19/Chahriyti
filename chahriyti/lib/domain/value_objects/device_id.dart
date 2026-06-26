import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';

class DeviceId extends Equatable {
  final String value;

  const DeviceId(this.value);

  factory DeviceId.fromRawId(String rawId) {
    final bytes = utf8.encode(rawId);
    final hash = sha256.convert(bytes);
    return DeviceId(hash.toString());
  }

  String get displayFormat {
    if (value.length < 32) return value;
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-${value.substring(12, 16)}-${value.substring(16, 20)}-${value.substring(20, 32)}'
        .toUpperCase();
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
