import '../../../infrastructure/database/daos/expenses_dao.dart';

class GetItemSuggestionsUseCase {
  final ExpensesDao _dao;
  const GetItemSuggestionsUseCase(this._dao);

  /// Returns distinct item names for [category], ordered by frequency desc.
  Future<List<String>> call(String category) =>
      _dao.getDistinctItemNames(category);
}
