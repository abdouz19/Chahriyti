import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/users_table.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  Future<UserRow?> getUser() =>
      (select(users)..limit(1)).getSingleOrNull();

  Future<int> insertUser(UsersCompanion user) => into(users).insert(user);

  Future<bool> updateUser(UserRow user) => update(users).replace(user);

  Future<void> setActivated(bool activated) async {
    final user = await getUser();
    if (user != null) {
      await (update(users)..where((t) => t.id.equals(user.id)))
          .write(UsersCompanion(isActivated: Value(activated)));
    }
  }
}
