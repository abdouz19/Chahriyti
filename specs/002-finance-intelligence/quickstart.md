# Phase 1 Quickstart: Setup & Integration

**Date**: 2026-06-26  
**Target**: Fast onboarding for developers implementing advanced financial features

---

## Overview

This feature adds Goals, Debts, Classification, Challenges, Leaks, and Insights to the existing Chahriyti app. All code follows the established Clean Architecture structure and integrates with existing Drift, BloC/Cubit, and GoRouter patterns.

**No breaking changes to existing features.** All additions are modular and can be implemented in phases (MVP first, then enhancements).

---

## Quick Start: 5 Steps

### 1. Add New Drift Tables

**Files to Create**:
```
lib/infrastructure/database/tables/
├── savings_goals_table.dart
├── debts_table.dart
├── debt_payments_table.dart
├── weekly_challenges_table.dart
└── financial_insights_table.dart
```

**Update AppDatabase**:
```dart
// lib/infrastructure/database/app_database.dart
import 'tables/savings_goals_table.dart';
import 'tables/debts_table.dart';
// ... import others

@DriftDatabase(tables: [
  Users,
  FinancialCycles,
  Expenses,
  Incomes,
  // ... existing tables
  SavingsGoals,      // NEW
  Debts,             // NEW
  DebtPayments,      // NEW
  WeeklyChallenges,  // NEW
  FinancialInsights, // NEW
])
class AppDatabase extends _$AppDatabase {
  // ... existing code
  // Drift auto-generates schema migration
}
```

**Drift Migration**:
- Drift auto-detects table changes
- Schema version auto-increments
- SQL migration generated automatically
- No manual migration script needed for MVP

### 2. Create DAOs

**Files to Create**:
```
lib/infrastructure/database/daos/
├── goals_dao.dart
├── debts_dao.dart
├── challenges_dao.dart
└── insights_dao.dart
```

**Pattern (copy from existing expenses_dao.dart)**:
```dart
@DriftAccessor(tables: [SavingsGoals])
class GoalsDao extends DatabaseAccessor<AppDatabase> with _$GoalsDaoMixin {
  GoalsDao(super.db);

  Future<GoalRow?> getGoalById(int id) =>
      (select(savingsGoals)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<GoalRow>> getUserGoals(int userId, {int limit = 20, int offset = 0}) =>
      (select(savingsGoals)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(limit)
            ..offset(offset))
          .get();

  Future<int> insertGoal(SavingsGoalsCompanion goal) =>
      into(savingsGoals).insert(goal);

  Future<bool> updateGoal(SavingsGoalsCompanion goal) =>
      update(savingsGoals).replace(goal);
}
```

### 3. Create Domain Entities & Repositories

**Files to Create**:
```
lib/domain/
├── entities/
│   ├── goal_entity.dart
│   ├── debt_entity.dart
│   ├── challenge_entity.dart
│   └── insight_entity.dart
└── repositories/
    ├── goal_repository.dart
    ├── debt_repository.dart
    ├── challenge_repository.dart
    └── insight_repository.dart
```

**Pattern (Freezed entity)**:
```dart
part 'goal_entity.freezed.dart';
part 'goal_entity.g.dart';

@freezed
class GoalEntity with _$GoalEntity {
  const GoalEntity._();
  const factory GoalEntity({
    required int id,
    required int userId,
    required String name,
    required int targetAmount,
    String? description,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _GoalEntity;
  
  bool get isCompleted => completedAt != null;
  factory GoalEntity.fromJson(Map<String, dynamic> json) =>
      _$GoalEntityFromJson(json);
}
```

**Repository Interface**:
```dart
abstract class GoalRepository {
  Future<GoalEntity?> getGoalById(int id);
  Future<List<GoalEntity>> getUserGoals(int userId, {int limit = 20, int offset = 0});
  Future<GoalEntity> createGoal(GoalEntity goal);
  Future<bool> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(int id);
}
```

### 4. Create Use Cases

**Files to Create**:
```
lib/application/use_cases/
├── goal/
│   ├── create_goal_use_case.dart
│   ├── update_goal_use_case.dart
│   └── get_goals_use_case.dart
├── debt/
│   ├── create_debt_use_case.dart
│   ├── add_debt_payment_use_case.dart
│   └── get_debts_use_case.dart
├── classification/
│   └── calculate_financial_classification_use_case.dart
└── insights/
    ├── detect_financial_leaks_use_case.dart
    └── generate_spending_trends_use_case.dart
```

**Pattern (use case)**:
```dart
class CreateGoalUseCase {
  final GoalRepository _repository;

  CreateGoalUseCase(this._repository);

  Future<GoalEntity> call(GoalCreateRequest request) async {
    if (request.targetAmount <= 0) {
      throw ArgumentError('Target amount must be positive');
    }
    
    final goal = GoalEntity(
      id: 0, // Drift auto-generates
      userId: request.userId,
      name: request.name,
      targetAmount: request.targetAmount,
      description: request.description,
      createdAt: DateTime.now(),
      completedAt: null,
    );

    return await _repository.createGoal(goal);
  }
}
```

### 5. Create Presentation Layer (Cubits + Pages)

**Files to Create**:
```
lib/presentation/
├── goal/
│   ├── pages/
│   │   ├── goals_list_page.dart
│   │   └── add_goal_page.dart
│   ├── cubits/
│   │   ├── goal_state.dart
│   │   └── goal_cubit.dart
│   └── widgets/
│       ├── goal_card.dart
│       └── progress_bar.dart
├── debt/
│   ├── pages/
│   │   ├── debts_list_page.dart
│   │   └── add_debt_page.dart
│   └── cubits/
│       └── debt_cubit.dart
└── insights/
    ├── pages/
    │   └── insights_page.dart
    └── cubits/
        └── insights_cubit.dart
```

**Pattern (Cubit state)**:
```dart
abstract class GoalState {}

class GoalLoading extends GoalState {}

class GoalsLoaded extends GoalState {
  final List<GoalEntity> goals;
  GoalsLoaded(this.goals);
}

class GoalError extends GoalState {
  final String message;
  GoalError(this.message);
}
```

**Pattern (Cubit)**:
```dart
class GoalCubit extends Cubit<GoalState> {
  final GetGoalsUseCase _getGoalsUseCase;
  final CreateGoalUseCase _createGoalUseCase;

  GoalCubit(this._getGoalsUseCase, this._createGoalUseCase)
      : super(GoalLoading());

  Future<void> loadGoals(int userId) async {
    emit(GoalLoading());
    try {
      final goals = await _getGoalsUseCase(userId);
      emit(GoalsLoaded(goals));
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
```

---

## Integration with Existing Features

### Dependency Injection (DI)

**Update lib/core/di/injection.dart**:
```dart
// Add to setupServiceLocator()
// Goals
sl.registerSingleton<GoalsDao>(GoalsDao(sl()));
sl.registerSingleton<GoalRepository>(GoalRepositoryImpl(sl()));
sl.registerSingleton<GetGoalsUseCase>(GetGoalsUseCase(sl()));

// Debts
sl.registerSingleton<DebtsDao>(DebtsDao(sl()));
sl.registerSingleton<DebtRepository>(DebtRepositoryImpl(sl()));
// ... etc for all new features
```

### Routing (GoRouter)

**Update lib/presentation/shared/routing/app_router.dart**:
```dart
routes: [
  // ... existing routes
  
  // Goals
  GoRoute(
    path: '/goals',
    builder: (context, state) => const GoalsListPage(),
  ),
  GoRoute(
    path: '/goal/add',
    builder: (context, state) => const AddGoalPage(),
  ),
  
  // Debts
  GoRoute(
    path: '/debts',
    builder: (context, state) => const DebtsListPage(),
  ),
  
  // Insights
  GoRoute(
    path: '/insights',
    builder: (context, state) => const InsightsPage(),
  ),
]
```

### Home Screen Integration

**Update lib/presentation/home/pages/home_page.dart**:
```dart
// Add sections
SliverToBoxAdapter(
  child: _buildGoalsSection(context),  // Shows next 3 goals
),
SliverToBoxAdapter(
  child: _buildDebtsSection(context),  // Shows total debt
),
SliverToBoxAdapter(
  child: _buildClassificationSection(context),  // Shows classification badge
),
```

### Settings Integration

**Update lib/presentation/settings/pages/settings_page.dart**:
```dart
// Add new settings sections
Section(
  title: 'Goals & Debts',
  children: [
    SettingTile(
      title: 'View Goals',
      onTap: () => context.push('/goals'),
    ),
    SettingTile(
      title: 'View Debts',
      onTap: () => context.push('/debts'),
    ),
  ],
),
Section(
  title: 'Weekly Challenges (Optional)',
  children: [
    ToggleSetting(
      title: 'Enable Challenges',
      value: state.challengesEnabled,
      onChanged: (value) => context.read<SettingsCubit>().toggleChallenges(value),
    ),
  ],
),
```

---

## Testing Strategy

### Unit Tests
```
test/application/use_cases/goal/
├── create_goal_use_case_test.dart
├── get_goals_use_case_test.dart
└── ... one per use case
```

**Example**:
```dart
void main() {
  group('CreateGoalUseCase', () {
    test('creates goal with valid input', () async {
      // Arrange
      final mockRepo = MockGoalRepository();
      final useCase = CreateGoalUseCase(mockRepo);

      // Act
      final result = await useCase(GoalCreateRequest(...));

      // Assert
      expect(result.name, 'Test Goal');
      verify(mockRepo.createGoal(any)).called(1);
    });
  });
}
```

### Widget Tests
```
test/presentation/goal/
├── goal_card_test.dart
├── progress_bar_test.dart
└── ... one per widget
```

### Integration Tests
```
test/integration/
├── goal_workflow_test.dart  # Create → View → Update
├── debt_workflow_test.dart  # Create → Pay → Complete
└── ... one per feature workflow
```

---

## Performance Checklist

- [ ] Use `ListView.builder` for goal/debt lists (never `ListView(children: [...])`)
- [ ] Paginate lists with limit=20, offset
- [ ] Use `const` for all static widgets
- [ ] Use `BlocBuilder`/`BlocListener` instead of `BlocConsumer` when possible
- [ ] No database queries in `build()`
- [ ] Use `RepaintBoundary` for charts
- [ ] Cache insight calculations (1-hour TTL)
- [ ] Test UI renders 60 fps on target device

---

## API Reference: Key Classes

### Use Cases (Application Layer)
- `CreateGoalUseCase(GoalRepository)` → `Future<GoalEntity>`
- `GetGoalsUseCase(GoalRepository)` → `Future<List<GoalEntity>>`
- `CreateDebtUseCase(DebtRepository)` → `Future<DebtEntity>`
- `AddDebtPaymentUseCase(DebtRepository)` → `Future<void>`
- `CalculateFinancialClassificationUseCase(ExpenseRepository, IncomeRepository, UserRepository)` → `Future<Classification>`
- `DetectFinancialLeaksUseCase(ExpenseRepository)` → `Future<List<LeakInsight>>`
- `GenerateSpendingTrendsUseCase(ExpenseRepository, CycleRepository)` → `Future<List<TrendInsight>>`

### Repositories (Domain Layer)
- `GoalRepository` — CRUD for goals
- `DebtRepository` — CRUD for debts + payments
- `ChallengeRepository` — CRUD for challenges
- `InsightRepository` — Create/retrieve insights

### Data Mappers (Infrastructure Layer)
- `GoalRowToEntity` — GoalRow → GoalEntity
- `DebtRowToEntity` — DebtRow → DebtEntity
- etc.

---

## Common Tasks

### Add a New Goal
```dart
final goal = GoalEntity(
  id: 0,
  userId: user.id,
  name: 'Buy Phone',
  targetAmount: 8000000, // 80000 DZD in centimes
  createdAt: DateTime.now(),
);
final saved = await goalRepository.createGoal(goal);
```

### Track Goal Progress
```dart
final savings = (cycle.income - cycle.expenses); // in centimes
final percentage = (savings / goal.targetAmount * 100).clamp(0, 100);
// Display: progress_bar(percentage)
```

### Make a Debt Payment
```dart
await debtRepository.addPayment(
  debtId: debt.id,
  amount: 50000, // 500 DZD in centimes
  paymentDate: DateTime.now(),
);
// Remaining balance auto-calculated: totalAmount - sum(payments)
```

### Calculate Classification
```dart
final classification = await calculateClassificationUseCase(userId);
// Returns: LegendarySaver, SmartSaver, Balanced, Spendthrift, Danger, EarlyBankruptcy
```

---

## Troubleshooting

**Q: New tables not appearing in database**  
A: Run `flutter clean && flutter pub get && flutter run` to regenerate Drift code

**Q: Freezed code not generated**  
A: Run `flutter pub run build_runner build --delete-conflicting-outputs`

**Q: Goals not showing in UI**  
A: Check DI setup (Injection.dart), ensure Cubit is provided to widget, check BlocListener logs

**Q: Performance slow on goal list**  
A: Use `ListView.builder` with pagination (limit 20), add indexes on userId in Drift table

---

## Next Steps After MVP

1. Add fl_chart for goal/debt progress visualization
2. Implement weekly challenge notifications
3. Add financial insights caching layer
4. Implement goal/debt export (PDF, CSV)
5. Add goal/debt collaboration features (share with family)

---

## Files Checklist

- [x] plan.md (this file's parent directory)
- [x] research.md (design decisions documented)
- [x] data-model.md (entity definitions and schema)
- [ ] ui-contracts.md (screen layouts and navigation — next file)
- [ ] Code: Domain entities (5 files)
- [ ] Code: Domain repositories (4 files)
- [ ] Code: Application use cases (6 files)
- [ ] Code: Infrastructure DAOs (4 files)
- [ ] Code: Infrastructure repositories (4 files)
- [ ] Code: Presentation pages (8 files)
- [ ] Code: Presentation cubits (4 files)
- [ ] Code: Presentation widgets (6 files)
- [ ] Tests: Unit tests (6 files)
- [ ] Tests: Widget tests (4 files)
- [ ] Tests: Integration tests (2 files)

**Total Implementation Estimate**: ~50 files, ~5,000 lines of code (including tests)

---

## Version & Date

**Plan Version**: 1.0  
**Last Updated**: 2026-06-26  
**Next Review**: After MVP completion
