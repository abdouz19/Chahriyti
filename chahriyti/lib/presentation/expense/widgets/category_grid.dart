import 'package:flutter/material.dart';

import '../../../core/constants/categories.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/category_l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/custom_category_entity.dart';

class CategoryGrid extends StatefulWidget {
  /// Returns the category key: enum name for built-ins, `custom_<id>` for custom.
  final void Function(String categoryKey) onCategorySelected;

  const CategoryGrid({super.key, required this.onCategorySelected});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  List<CustomCategoryEntity> _customCategories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await Injection.getCustomCategoriesUseCase();
    if (mounted) setState(() { _customCategories = cats; _loading = false; });
  }

  Future<void> _addCustomCategory() async {
    final result = await showModalBottomSheet<({String name, int iconCodePoint})>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddCustomCategorySheet(),
    );
    if (result == null) return;
    try {
      await Injection.createCustomCategoryUseCase(
        name: result.name,
        iconCodePoint: result.iconCodePoint,
      );
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.negative),
        );
      }
    }
  }

  Future<void> _deleteCustomCategory(CustomCategoryEntity cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الفئة'),
        content: Text('هل تريد حذف فئة "${cat.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.negative),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await Injection.deleteCustomCategoryUseCase(cat.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final builtInCards = ExpenseCategory.values.map(
      (cat) => _BuiltInCategoryCard(
        category: cat,
        onTap: () => widget.onCategorySelected(cat.name),
      ),
    );

    final customCards = _customCategories.map(
      (cat) => _CustomCategoryCard(
        category: cat,
        onTap: () => widget.onCategorySelected(cat.categoryKey),
        onDelete: () => _deleteCustomCategory(cat),
      ),
    );

    final addCard = _AddCategoryCard(onTap: _addCustomCategory);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [...builtInCards, ...customCards, addCard],
    );
  }
}

// ─── Built-in card ──────────────────────────────────────────────────────────

class _BuiltInCategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  final VoidCallback onTap;

  const _BuiltInCategoryCard({required this.category, required this.onTap});

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
              category.localizedLabel(context),
              style: AppTypography.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom card ─────────────────────────────────────────────────────────────

class _CustomCategoryCard extends StatelessWidget {
  final CustomCategoryEntity category;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _CustomCategoryCard({
    required this.category,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onDelete,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(category.icon, size: 36, color: AppColors.primary),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      category.name,
                      style: AppTypography.labelLarge,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6,
              left: 6,
              child: Icon(Icons.delete_outline_rounded,
                  size: 16, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add card ────────────────────────────────────────────────────────────────

class _AddCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddCategoryCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline_rounded,
                size: 40, color: AppColors.primary.withValues(alpha: 0.6)),
            const SizedBox(height: 8),
            Text(
              'فئة جديدة',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.primary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Add custom category bottom sheet ────────────────────────────────────────

class _AddCustomCategorySheet extends StatefulWidget {
  const _AddCustomCategorySheet();

  @override
  State<_AddCustomCategorySheet> createState() => _AddCustomCategorySheetState();
}

class _AddCustomCategorySheetState extends State<_AddCustomCategorySheet> {
  final _nameController = TextEditingController();
  late int _selectedIconCodePoint;

  static final _icons = [
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

  @override
  void initState() {
    super.initState();
    _selectedIconCodePoint = _icons.first.codePoint;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(context, (name: name, iconCodePoint: _selectedIconCodePoint));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('إضافة فئة مخصصة', style: AppTypography.headlineSmall),
          const SizedBox(height: 20),
          Text('اسم الفئة', style: AppTypography.labelLarge),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            decoration: const InputDecoration(hintText: 'مثال: رياضة، حيوانات أليفة...'),
          ),
          const SizedBox(height: 20),
          Text('اختر أيقونة', style: AppTypography.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _icons.map((iconData) {
              final selected = iconData.codePoint == _selectedIconCodePoint;
              return GestureDetector(
                onTap: () => setState(() => _selectedIconCodePoint = iconData.codePoint),
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.border,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 22,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submit,
              child: const Text('إضافة'),
            ),
          ),
        ],
      ),
    );
  }
}
