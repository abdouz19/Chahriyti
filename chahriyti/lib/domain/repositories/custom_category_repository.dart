import '../entities/custom_category_entity.dart';

abstract class CustomCategoryRepository {
  Future<List<CustomCategoryEntity>> getAll();
  Future<CustomCategoryEntity> create({required String name, required int iconCodePoint});
  Future<void> delete(int id);
}
