import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CustomCategoryEntity {
  final int id;
  final String name;
  final int iconCodePoint;

  /// Hidden from the picker; still names the expenses that use it.
  final bool isArchived;

  const CustomCategoryEntity({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.isArchived = false,
  });

  String get categoryKey => 'custom_$id';

  /// Every icon available in the custom-category picker declared as const so
  /// the tree-shaker can enumerate them. The map is built once at startup.
  static const List<IconData> pickerIcons = [
    IconsaxPlusLinear.tag,
    IconsaxPlusLinear.bag_2,
    IconsaxPlusLinear.reserve,
    IconsaxPlusLinear.coffee,
    IconsaxPlusLinear.home_2,
    IconsaxPlusLinear.car,
    IconsaxPlusLinear.hospital,
    IconsaxPlusLinear.teacher,
    IconsaxPlusLinear.bag_happy,
    IconsaxPlusLinear.weight_1,
    IconsaxPlusLinear.activity,
    IconsaxPlusLinear.music,
    IconsaxPlusLinear.airplane,
    IconsaxPlusLinear.gift,
    IconsaxPlusLinear.monitor,
    IconsaxPlusLinear.pet,
    IconsaxPlusLinear.setting_3,
    IconsaxPlusLinear.lovely,
    IconsaxPlusLinear.video_play,
    IconsaxPlusLinear.strongbox,
  ];

  /// Material code points saved before the switch to Iconsax, in the same
  /// order as [pickerIcons], so existing custom categories keep their icon.
  /// They don't overlap Iconsax's range (0xe9xx–0xecxx).
  static const List<int> _legacyMaterialCodePoints = [
    0xf83c, 0xf37e, 0xf316, 0xf175, 0xf107, 0xefc6, 0xf17e, 0xf33c, 0xef4c, 0xf07a,
    0xf3d5, 0xf1fb, 0xf085, 0xef2d, 0xef74, 0xf285, 0xef06, 0xf3bb, 0xf183, 0xf336,
  ];

  static final Map<int, IconData> _iconByCodePoint = {
    for (final icon in pickerIcons) icon.codePoint: icon,
    for (var i = 0; i < pickerIcons.length; i++) _legacyMaterialCodePoints[i]: pickerIcons[i],
  };

  IconData get icon =>
      _iconByCodePoint[iconCodePoint] ?? IconsaxPlusLinear.tag;
}
