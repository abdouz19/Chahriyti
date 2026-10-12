import '../entities/custom_category_entity.dart';

abstract class CustomCategoryRepository {
  Future<List<CustomCategoryEntity>> getAll();
  Future<CustomCategoryEntity> create({required String name, required int iconCodePoint});
  /// Archives the category: it leaves the picker, its expenses keep its name.
  Future<void> delete(int id);
}
