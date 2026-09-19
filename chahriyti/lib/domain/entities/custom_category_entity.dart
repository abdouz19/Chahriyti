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

  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
}
