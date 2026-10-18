import 'package:flutter/widgets.dart';

/// Iconsax arrows that flip with the text direction, like Material's
/// back/forward arrows did: in Arabic (RTL) "back" points right.
abstract final class AppIcons {
  static const _family = 'IconsaxPlusLinear';
  static const _package = 'iconsax_plus';

  /// arrow_left
  static const IconData back = IconData(0xe92f, fontFamily: _family, fontPackage: _package, matchTextDirection: true);

  /// arrow_right
  static const IconData forward = IconData(0xe933, fontFamily: _family, fontPackage: _package, matchTextDirection: true);

  /// arrow_left_2 (chevron)
  static const IconData backChevron =
      IconData(0xe931, fontFamily: _family, fontPackage: _package, matchTextDirection: true);

  /// arrow_right_3 (chevron)
  static const IconData forwardChevron =
      IconData(0xe936, fontFamily: _family, fontPackage: _package, matchTextDirection: true);
}
