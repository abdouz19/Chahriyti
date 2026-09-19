import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/custom_categories_table.dart';

part 'custom_categories_dao.g.dart';

@DriftAccessor(tables: [CustomCategories])
class CustomCategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CustomCategoriesDaoMixin {
  CustomCategoriesDao(super.db);

  Future<List<CustomCategoryRow>> getAll() =>
      (select(customCategories)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

  Future<int> insert({required String name, required int iconCodePoint}) =>
      into(customCategories).insert(
        CustomCategoriesCompanion.insert(name: name, iconCodePoint: iconCodePoint),
      );

  Future<void> deleteById(int id) =>
      (delete(customCategories)..where((t) => t.id.equals(id))).go();

  Future<int> count() async {
    final countExp = customCategories.id.count();
    final query = selectOnly(customCategories)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
