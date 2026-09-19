import '../../domain/entities/custom_category_entity.dart';
import '../../domain/repositories/custom_category_repository.dart';
import '../database/app_database.dart';
import '../database/daos/custom_categories_dao.dart';

class CustomCategoryRepositoryImpl implements CustomCategoryRepository {
  final CustomCategoriesDao _dao;

  CustomCategoryRepositoryImpl(this._dao);

  CustomCategoryEntity _toEntity(CustomCategoryRow row) => CustomCategoryEntity(
        id: row.id,
        name: row.name,
        iconCodePoint: row.iconCodePoint,
      );

  @override
  Future<List<CustomCategoryEntity>> getAll() async {
    final rows = await _dao.getAll();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<CustomCategoryEntity> create({
    required String name,
    required int iconCodePoint,
  }) async {
    final id = await _dao.insert(name: name, iconCodePoint: iconCodePoint);
    final rows = await _dao.getAll();
    final row = rows.firstWhere((r) => r.id == id);
    return _toEntity(row);
  }

  @override
  Future<void> delete(int id) => _dao.deleteById(id);
}
