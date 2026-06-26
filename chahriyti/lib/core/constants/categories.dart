enum ExpenseCategory {
  essentials('الضروريات'),
  homeFamily('المنزل والعائلة'),
  luxuries('الكماليات'),
  other('أخرى');

  final String arabicLabel;
  const ExpenseCategory(this.arabicLabel);

  List<ExpenseSubcategory> get subcategories {
    return ExpenseSubcategory.values
        .where((s) => s.category == this)
        .toList();
  }
}

enum ExpenseSubcategory {
  // Essentials
  food(ExpenseCategory.essentials, 'أكل'),
  transport(ExpenseCategory.essentials, 'نقل'),
  bills(ExpenseCategory.essentials, 'فواتير'),
  medicine(ExpenseCategory.essentials, 'دواء'),

  // Home & Family
  household(ExpenseCategory.homeFamily, 'مصروف البيت'),
  children(ExpenseCategory.homeFamily, 'الأولاد'),
  gifts(ExpenseCategory.homeFamily, 'الهدايا'),
  homeFamilyOther(ExpenseCategory.homeFamily, 'أخرى'),

  // Luxuries
  restaurants(ExpenseCategory.luxuries, 'مطاعم'),
  coffee(ExpenseCategory.luxuries, 'قهوة'),
  clothing(ExpenseCategory.luxuries, 'ملابس'),
  entertainment(ExpenseCategory.luxuries, 'ترفيه'),

  // Other
  otherExpense(ExpenseCategory.other, 'أخرى');

  final ExpenseCategory category;
  final String arabicLabel;
  const ExpenseSubcategory(this.category, this.arabicLabel);
}
