import 'package:flutter/material.dart';

class CustomCategoryEntity {
  final int id;
  final String name;
  final int iconCodePoint;

  const CustomCategoryEntity({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });

  String get categoryKey => 'custom_$id';

  /// Every icon available in the custom-category picker declared as const so
  /// the tree-shaker can enumerate them. The map is built once at startup.
  static const List<IconData> pickerIcons = [
    Icons.label_outline_rounded,
    Icons.shopping_basket_outlined,
    Icons.restaurant_outlined,
    Icons.local_cafe_outlined,
    Icons.home_outlined,
    Icons.directions_car_outlined,
    Icons.local_hospital_outlined,
    Icons.school_outlined,
    Icons.checkroom_outlined,
    Icons.fitness_center_outlined,
    Icons.sports_soccer_outlined,
    Icons.music_note_outlined,
    Icons.flight_outlined,
    Icons.card_giftcard_outlined,
    Icons.computer_outlined,
    Icons.pets_outlined,
    Icons.build_outlined,
    Icons.spa_outlined,
    Icons.local_movies_outlined,
    Icons.savings_outlined,
  ];

  static final Map<int, IconData> _iconByCodePoint = {
    for (final icon in pickerIcons) icon.codePoint: icon,
  };

  IconData get icon =>
      _iconByCodePoint[iconCodePoint] ?? Icons.label_outline_rounded;
}
