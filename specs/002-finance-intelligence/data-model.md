# Phase 1 Design: Data Model & Schema

**Date**: 2026-06-26  
**Status**: Complete  
**Focus**: Entity definitions, Drift table schemas, relationships, and validation rules

---

## Domain Entities

### 1. Goal

**Purpose**: Represents a user's financial target (e.g., "Buy Phone for 80000 DZD")

**Fields**:
```dart
- id: int (primary key, auto-increment)
- userId: int (foreign key → Users.id)
- name: String (e.g., "شراء هاتف جديد")
- targetAmount: int (in centimes, e.g., 8000000 for 80000 DZD)
- description: String? (optional context)
- createdAt: DateTime
- completedAt: DateTime? (null if incomplete)
- isCompleted: bool (derived from completedAt != null)
```

**Relationships**:
- Belongs to User (many goals per user)
- Progress calculated from FinancialCycle.savings in active cycle

**Validation**:
- targetAmount > 0
- name not empty, max 100 chars
- description max 500 chars

**State Transitions**:
- Created → Active (initial state)
- Active → Completed (when progress >= 100%)
- Completed → Active (can un-complete if user edits)

**Dart Entity** (Freezed):
```dart
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
}
```

---

### 2. Debt

**Purpose**: Represents money owed to a creditor (e.g., "Ahmed - 50000 DZD")

**Fields**:
```dart
- id: int (primary key, auto-increment)
- userId: int (foreign key → Users.id)
- creditorName: String (e.g., "أحمد", "البنك", "المتجر")
- totalAmount: int (in centimes, e.g., 5000000)
- createdAt: DateTime
- completedAt: DateTime? (when remaining balance = 0)
- isCompleted: bool (derived)
```

**Relationships**:
- Belongs to User (many debts per user)
- Has many DebtPayments (one-to-many)
- Remaining balance = totalAmount - sum(DebtPayments.amount)

**Validation**:
- totalAmount > 0
- creditorName not empty, max 100 chars
- Only one active debt per creditor per user (optional constraint)

**Derived Fields**:
- remainingBalance: int = totalAmount - totalPaid
- totalPaid: int = sum of all DebtPayment.amount
- progressPercentage: double = (totalPaid / totalAmount) × 100
- daysActive: int = now - createdAt

**Dart Entity** (Freezed):
```dart
@freezed
class DebtEntity with _$DebtEntity {
  const DebtEntity._();
  const factory DebtEntity({
    required int id,
    required int userId,
    required String creditorName,
    required int totalAmount,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _DebtEntity;
  
  bool get isCompleted => completedAt != null;
}
```

---

### 3. DebtPayment

**Purpose**: Records a single payment toward a debt (immutable history)

**Fields**:
```dart
- id: int (primary key, auto-increment)
- debtId: int (foreign key → Debts.id)
- amount: int (in centimes, e.g., 500000 for 5000 DZD)
- paymentDate: DateTime (when payment made)
- createdAt: DateTime (when record created)
```

**Relationships**:
- Belongs to Debt (many payments per debt)
- Immutable: no updates/deletes allowed

**Validation**:
- amount > 0
- amount <= debt.remainingBalance (enforced at application layer)
- paymentDate <= now

**Dart Entity** (Freezed):
```dart
@freezed
class DebtPaymentEntity with _$DebtPaymentEntity {
  const factory DebtPaymentEntity({
    required int id,
    required int debtId,
    required int amount,
    required DateTime paymentDate,
    required DateTime createdAt,
  }) = _DebtPaymentEntity;
}
```

---

### 4. Challenge

**Purpose**: Represents a weekly savings challenge (optional feature)

**Fields**:
```dart
- id: int (primary key, auto-increment)
- userId: int (foreign key → Users.id)
- weekStartDate: DateTime (Monday of the week)
- targetAmount: int (in centimes, amount to save)
- description: String (e.g., "شهذا الأسبوع قلل إنفاقك بـ 1000 دج")
- completedAt: DateTime? (when challenge met)
- isCompleted: bool (derived)
- createdAt: DateTime
```

**Relationships**:
- Belongs to User (one challenge per week per user)
- Calculated from spending data (no FK to expenses directly)

**Validation**:
- targetAmount > 0
- weekStartDate is Monday
- Only one active challenge per user per week

**Derived Fields**:
- isActive: bool = weekStartDate <= now <= weekEndDate
- currentProgress: int = weekStartDate spending (calculated from Expenses)
- daysRemaining: int = 7 - (now - weekStartDate).inDays

**Dart Entity** (Freezed):
```dart
@freezed
class ChallengeEntity with _$ChallengeEntity {
  const ChallengeEntity._();
  const factory ChallengeEntity({
    required int id,
    required int userId,
    required DateTime weekStartDate,
    required int targetAmount,
    required String description,
    DateTime? completedAt,
    required DateTime createdAt,
  }) = _ChallengeEntity;
  
  bool get isCompleted => completedAt != null;
  bool get isActive {
    final now = DateTime.now();
    final weekEnd = weekStartDate.add(Duration(days: 6));
    return now.isAfter(weekStartDate) && now.isBefore(weekEnd);
  }
}
```

---

### 5. Insight

**Purpose**: Represents a calculated financial insight (trend, leak, or classification)

**Fields**:
```dart
- id: int (primary key, auto-increment)
- userId: int (foreign key → Users.id)
- insightType: String enum (trend, leak, classification, comparison)
- category: String? (expense category, e.g., "مطاعم", null for classification)
- metric: String (e.g., "percentageChange", "totalAmount", "frequency")
- value: double (e.g., 35.5 for +35.5%, 6200 for 6200 DZD)
- suggestion: String (e.g., "حاول تقليل مصاريف المطاعم")
- cycleId: int? (which cycle this insight applies to)
- createdAt: DateTime
- expiresAt: DateTime (for caching; refresh after cycle end)
```

**Relationships**:
- Belongs to User (many insights per user)
- References FinancialCycle (optional, for cycle-specific insights)

**Types**:
1. **Leak Insight**: High-frequency, low-cost category
   - category: "قهوة", metric: "frequency", value: 31, suggestion: "أنفقت 6200 دج على القهوة... لو خفضتها للنصف لادخرت 3100 دج"

2. **Trend Insight**: Category comparison (current vs previous)
   - category: "مطاعم", metric: "percentageChange", value: 35.5, suggestion: "مصروف المطاعم ارتفع بـ 35% ... حاول التخطيط للوجبات"

3. **Classification Insight**: Financial classification
   - category: null, metric: "savingsRate", value: 22.5, suggestion: "أنت مدخر ذكي! استمر على هذا الحال"

4. **Comparison Insight**: Before/after comparison
   - category: "مطاعم", metric: "comparison", value: 8500 (previous) to 11475 (current)

**Dart Entity** (Freezed):
```dart
@freezed
class InsightEntity with _$InsightEntity {
  const factory InsightEntity({
    required int id,
    required int userId,
    required InsightType type,
    String? category,
    required String metric,
    required double value,
    required String suggestion,
    int? cycleId,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _InsightEntity;
}

enum InsightType { leak, trend, classification, comparison }
```

---

## Drift Table Schemas

### Goal Table

```dart
@DataClassName('GoalRow')
class SavingsGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get name => text()();
  IntColumn get targetAmount => integer()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
```

### Debt Table

```dart
@DataClassName('DebtRow')
class Debts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get creditorName => text()();
  IntColumn get totalAmount => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}
```

### DebtPayment Table

```dart
@DataClassName('DebtPaymentRow')
class DebtPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtId => integer().references(Debts, #id)();
  IntColumn get amount => integer()();
  DateTimeColumn get paymentDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### Challenge Table

```dart
@DataClassName('ChallengeRow')
class WeeklyChallenges extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  DateTimeColumn get weekStartDate => dateTime()();
  IntColumn get targetAmount => integer()();
  TextColumn get description => text()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}
```

### Insight Table

```dart
@DataClassName('InsightRow')
class FinancialInsights extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get insightType => text()(); // 'leak', 'trend', 'classification', 'comparison'
  TextColumn get category => text().nullable()();
  TextColumn get metric => text()();
  RealColumn get value => real()();
  TextColumn get suggestion => text()();
  IntColumn get cycleId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();
}
```

---

## Data Constraints & Integrity

### At-Database Level (Drift)
- Foreign key constraints on userId, debtId, cycleId
- NOT NULL on required fields
- CHECK constraint: targetAmount > 0, totalAmount > 0, amount > 0

### At-Application Level (Use Cases)
- Goal can only be completed if progress >= 100%
- Debt payment validation: amount > 0 AND amount <= debt.remainingBalance
- Debt marked completed only when remainingBalance == 0
- DebtPayment records are immutable (no updates/deletes)
- Challenge only created if not already active for the week
- Insight expires after 7 days; re-calculated on demand

---

## Data Lifecycle & Cleanup

### Goals
- Created on user request, persists across cycles
- Can be archived/deleted by user
- Progress reset when new cycle starts (but goal persists)

### Debts & Payments
- Created on user request, persists indefinitely
- Payments immutable (no edits)
- Debt marked complete when balance = 0, moved to history view
- Can be manually archived/deleted

### Challenges
- Created weekly by system (if user enabled)
- Marked completed if target met by week end
- Auto-cleaned after 8 weeks (move to history)
- User can disable from settings

### Insights
- Calculated on-demand, cached for 1 hour
- Expire automatically (expiresAt field)
- Re-calculated at cycle end
- No manual cleanup needed (auto-expire)

---

## Migration Path from 001-chahriyti-salary-app

**Existing Entities Unaffected**:
- User, FinancialCycle, Expense, Income, AdditionalIncome
- No changes to existing tables
- New tables are additive only

**Schema Version Update**:
- Current: AppDatabase version = 4
- New: AppDatabase version = 5
- Drift auto-generates migration script

**Backward Compatibility**:
- Existing app can update to v2 without data loss
- New tables created empty
- Existing expense/income data remains unchanged

---

## Performance Considerations

### Indexing Strategy
- Index on userId for fast per-user queries (Goals, Debts, Insights)
- Index on cycleId for cycle-specific lookups
- Index on createdAt for sorting/pagination
- Compound index on (userId, isCompleted) for active goals/debts

### Query Optimization
- Use Drift queries with LIMIT/OFFSET for pagination
- Pre-aggregate totals in Application layer, not database
- Cache insight results for 1 hour to avoid repeated calculations
- Use VIEW for common aggregations (e.g., total debt per user)

### Storage Estimate
- Each Goal: ~100 bytes (name, amounts, dates)
- Each Debt: ~80 bytes
- Each Payment: ~40 bytes
- Each Challenge: ~120 bytes
- Each Insight: ~200 bytes
- Estimated growth: 50KB per 100 goals/debts (negligible)

---

## Summary

| Entity | Tables | Relationships | Constraints | Lifecycle |
|--------|--------|---------------|-------------|-----------|
| Goal | 1 (SavingsGoals) | FK(userId), FK(cycleId) | amount > 0 | Created, Active, Completed |
| Debt | 2 (Debts, DebtPayments) | FK(userId), 1:N | amount > 0, unique per user | Created, Active, Completed |
| Challenge | 1 (WeeklyChallenges) | FK(userId) | amount > 0, one per week | Weekly reset |
| Insight | 1 (FinancialInsights) | FK(userId), FK(cycleId) | Expiring cache | On-demand calculated |

All entities follow Clean Architecture principles, maintain offline-first compliance, and integrate seamlessly with existing Chahriyti data model.
