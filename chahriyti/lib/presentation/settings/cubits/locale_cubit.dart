import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);
  @override
  List<Object?> get props => [locale];
}

class LocaleCubit extends Cubit<LocaleState> {
  static const _key = 'app_locale';
  final FlutterSecureStorage _storage;

  LocaleCubit(this._storage) : super(const LocaleState(Locale('ar')));

  Future<void> load() async {
    final stored = await _storage.read(key: _key);
    if (stored != null) emit(LocaleState(Locale(stored)));
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.write(key: _key, value: locale.languageCode);
    emit(LocaleState(locale));
  }
}
