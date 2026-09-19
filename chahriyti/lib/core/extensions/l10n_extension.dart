import 'package:flutter/material.dart';
import 'package:chahriyti/l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
