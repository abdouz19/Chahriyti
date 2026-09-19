import '../../../domain/entities/custom_category_entity.dart';
import '../../../domain/repositories/custom_category_repository.dart';

class GetCustomCategoriesUseCase {
  final CustomCategoryRepository _repo;
  const GetCustomCategoriesUseCase(this._repo);

  Future<List<CustomCategoryEntity>> call() => _repo.getAll();
}

class CreateCustomCategoryUseCase {
  final CustomCategoryRepository _repo;
  const CreateCustomCategoryUseCase(this._repo);

  static const _maxCustomCategories = 20;

  Future<CustomCategoryEntity> call({
    required String name,
    required int iconCodePoint,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw ArgumentError('اسم الفئة مطلوب');

    final existing = await _repo.getAll();
    if (existing.length >= _maxCustomCategories) {
      throw StateError('وصلت إلى الحد الأقصى للفئات المخصصة ($_maxCustomCategories)');
    }

    return _repo.create(name: trimmed, iconCodePoint: iconCodePoint);
  }
}

class DeleteCustomCategoryUseCase {
  final CustomCategoryRepository _repo;
  const DeleteCustomCategoryUseCase(this._repo);

  Future<void> call(int id) => _repo.delete(id);
}
