import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SubcategoryChips extends StatefulWidget {
  final ExpenseCategory category;
  final ValueChanged<ExpenseSubcategory> onSubcategorySelected;

  const SubcategoryChips({
    super.key,
    required this.category,
    required this.onSubcategorySelected,
  });

  @override
  State<SubcategoryChips> createState() => _SubcategoryChipsState();
}

class _SubcategoryChipsState extends State<SubcategoryChips> {
  ExpenseSubcategory? _selected;

  List<ExpenseSubcategory> get _subcategories =>
      widget.category.subcategories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: _subcategories.map((sub) {
          final isSelected = _selected == sub;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: ChoiceChip(
              label: Text(
                sub.arabicLabel,
                style: AppTypography.labelMedium.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              showCheckmark: false,
              onSelected: (_) {
                setState(() => _selected = sub);
                widget.onSubcategorySelected(sub);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
