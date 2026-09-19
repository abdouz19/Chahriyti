import '../../../infrastructure/database/daos/incomes_dao.dart';

class GetIncomeSuggestionsUseCase {
  final IncomesDao _dao;
  const GetIncomeSuggestionsUseCase(this._dao);

  Future<List<String>> call() => _dao.getDistinctDescriptions();
}
