import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/savings_contributions_table.dart';
import '../tables/savings_goals_table.dart';

part 'goals_dao.g.dart';

@DriftAccessor(tables: [SavingsGoals, SavingsContributions])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.db);

  Future<int> insertGoal(SavingsGoalsCompanion goal) =>
      into(savingsGoals).insert(goal);

  Future<List<SavingsGoalRow>> getGoals() => select(savingsGoals).get();

  Future<List<SavingsGoalRow>> getActiveGoals() =>
      (select(savingsGoals)..where((t) => t.isAchieved.equals(false))).get();

  Future<void> insertContribution({
    required int goalId,
    required int cycleId,
    required int amount,
  }) async {
    await transaction(() async {
      // Insert contribution record
      await into(savingsContributions).insert(
        SavingsContributionsCompanion(
          goalId: Value(goalId),
          cycleId: Value(cycleId),
          amount: Value(amount),
        ),
      );

      // Update the goal's savedAmount
      final goal = await (select(savingsGoals)
            ..where((t) => t.id.equals(goalId)))
          .getSingle();
      final newSavedAmount = goal.savedAmount + amount;
      final isAchieved = newSavedAmount >= goal.targetAmount;

      await (update(savingsGoals)..where((t) => t.id.equals(goalId))).write(
        SavingsGoalsCompanion(
          savedAmount: Value(newSavedAmount),
          isAchieved: Value(isAchieved),
        ),
      );
    });
  }

  Future<int> getTotalContributionsForCycle(int cycleId) async {
    final sum = savingsContributions.amount.sum();
    final query = selectOnly(savingsContributions)
      ..addColumns([sum])
      ..where(savingsContributions.cycleId.equals(cycleId));
    final result = await query.getSingle();
    return result.read(sum) ?? 0;
  }
}
