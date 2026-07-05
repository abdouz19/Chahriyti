enum ExpenseCategory {
  essentials('الضروريات'),
  homeFamily('المنزل والعائلة'),
  luxuries('الكماليات'),
  health('الصحة'),
  transport('المواصلات'),
  clothing('الملابس'),
  restaurants('المطاعم'),
  education('التعليم'),
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
  essentialsTransport(ExpenseCategory.essentials, 'نقل'),
  bills(ExpenseCategory.essentials, 'فواتير'),
  essentialsMedicine(ExpenseCategory.essentials, 'دواء'),

  // Home & Family
  household(ExpenseCategory.homeFamily, 'مصروف البيت'),
  children(ExpenseCategory.homeFamily, 'الأولاد'),
  gifts(ExpenseCategory.homeFamily, 'الهدايا'),
  homeFamilyOther(ExpenseCategory.homeFamily, 'أخرى'),

  // Luxuries
  luxuriesRestaurants(ExpenseCategory.luxuries, 'مطاعم'),
  coffee(ExpenseCategory.luxuries, 'قهوة'),
  luxuriesClothing(ExpenseCategory.luxuries, 'ملابس'),
  entertainment(ExpenseCategory.luxuries, 'ترفيه'),

  // Health
  doctor(ExpenseCategory.health, 'طبيب'),
  pharmacy(ExpenseCategory.health, 'صيدلية'),
  hospital(ExpenseCategory.health, 'مستشفى'),
  labTests(ExpenseCategory.health, 'تحاليل وأشعة'),
  healthOther(ExpenseCategory.health, 'أخرى'),

  // Transport
  fuel(ExpenseCategory.transport, 'وقود'),
  carMaintenance(ExpenseCategory.transport, 'صيانة السيارة'),
  taxi(ExpenseCategory.transport, 'تاكسي وأجرة'),
  transportTicket(ExpenseCategory.transport, 'تذكرة'),
  transportOther(ExpenseCategory.transport, 'أخرى'),

  // Clothing
  menClothing(ExpenseCategory.clothing, 'ملابس رجالية'),
  womenClothing(ExpenseCategory.clothing, 'ملابس نسائية'),
  kidsClothing(ExpenseCategory.clothing, 'ملابس أطفال'),
  shoes(ExpenseCategory.clothing, 'أحذية'),
  clothingOther(ExpenseCategory.clothing, 'أخرى'),

  // Restaurants
  restaurant(ExpenseCategory.restaurants, 'مطعم'),
  fastFood(ExpenseCategory.restaurants, 'وجبة سريعة'),
  cafe(ExpenseCategory.restaurants, 'مقهى'),
  delivery(ExpenseCategory.restaurants, 'توصيل'),
  restaurantsOther(ExpenseCategory.restaurants, 'أخرى'),

  // Education
  schoolUniversity(ExpenseCategory.education, 'مدرسة وجامعة'),
  tutoring(ExpenseCategory.education, 'دروس خصوصية'),
  booksStationery(ExpenseCategory.education, 'كتب وقرطاسية'),
  trainingCourses(ExpenseCategory.education, 'دورات تدريبية'),
  educationOther(ExpenseCategory.education, 'أخرى'),

  // Other
  otherExpense(ExpenseCategory.other, 'أخرى');

  final ExpenseCategory category;
  final String arabicLabel;
  const ExpenseSubcategory(this.category, this.arabicLabel);
}
