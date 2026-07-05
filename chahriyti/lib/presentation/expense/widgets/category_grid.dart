import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CategoryGrid extends StatelessWidget {
  final ValueChanged<ExpenseCategory> onCategorySelected;

  const CategoryGrid({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: ExpenseCategory.values
          .map(
            (cat) => _CategoryCard(
              category: cat,
              onTap: () => onCategorySelected(cat),
            ),
          )
          .toList(),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData get _icon => switch (category) {
        ExpenseCategory.essentials => Icons.shopping_basket_outlined,
        ExpenseCategory.homeFamily => Icons.home_outlined,
        ExpenseCategory.luxuries => Icons.local_cafe_outlined,
        ExpenseCategory.health => Icons.local_hospital_outlined,
        ExpenseCategory.transport => Icons.directions_car_outlined,
        ExpenseCategory.clothing => Icons.checkroom_outlined,
        ExpenseCategory.restaurants => Icons.restaurant_outlined,
        ExpenseCategory.education => Icons.school_outlined,
        ExpenseCategory.other => Icons.more_horiz,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icon, size: 40, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              category.arabicLabel,
              style: AppTypography.labelLarge,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}
