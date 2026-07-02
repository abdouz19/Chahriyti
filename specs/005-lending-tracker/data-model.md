# Data Model: Lending Tracker (السلف)

**Date**: 2026-06-28
**Feature**: 005-lending-tracker

## Entities

### LendingEntity

A record of money lent to someone. Mirrors `DebtEntity` structure.

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| id | int | yes | auto-increment | Primary key |
| borrowerName | String | yes | — | Name of the person who borrowed money |
| totalAmount | int | yes | — | Total amount lent (positive integer, in centimes) |
| collectedAmount | int | yes | 0 | Total amount collected back so far |
| isFullyCollected | bool | yes | false | Whether the full amount has been collected |
| fromSavings | bool | yes | false | Whether the lending was funded from savings |
| cycleId | int | yes | — | The cycle in which the lending was created |
| notes | String? | no | null | Optional notes about the lending |
| createdAt | DateTime | yes | now | Timestamp of creation |

**Computed properties:**
- `remainingAmount` = `totalAmount - collectedAmount`

**Freezed annotations:**
- `@freezed` with private constructor (`const LendingEntity._()`) for computed getters
- `@Default(0) int collectedAmount`
- `@Default(false) bool isFullyCollected`
- `@Default(false) bool fromSavings`
- `@JsonSerializable` for `fromJson`/`toJson`

### LendingCollectionEntity

A record of money returned by a borrower. Mirrors the concept of `DebtPayment`.

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| id | int | yes | auto-increment | Primary key |
| lendingId | int | yes | — | FK to the lending record |
| amount | int | yes | — | Amount collected (positive integer, in centimes) |
| createdAt | DateTime | yes | now | Timestamp of collection |

**Freezed annotations:**
- `@freezed` (no computed properties needed)
- `@JsonSerializable` for `fromJson`/`toJson`

### SavingsHistoryEntity (MODIFIED)

Add one new nullable field to link savings withdrawals to lendings.

| Field | Type | Change |
|-------|------|--------|
| relatedLendingId | int? | NEW — nullable FK linking withdrawal to the lending that triggered it |

## Drift Tables

### Lendings

```
@DataClassName('LendingRow')
class Lendings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get borrowerName => text()();
  IntColumn get totalAmount => integer()();
  IntColumn get collectedAmount => integer().withDefault(const Constant(0))();
  BoolColumn get isFullyCollected => boolean().withDefault(const Constant(false))();
  BoolColumn get fromSavings => boolean().withDefault(const Constant(false))();
  IntColumn get cycleId => integer()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### LendingCollections

```
@DataClassName('LendingCollectionRow')
class LendingCollections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get lendingId => integer()();
  IntColumn get amount => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### SavingsHistory (MODIFIED)

Add column:
```
IntColumn get relatedLendingId => integer().nullable()();
```

## Relationships

```
LendingEntity 1 ──── * LendingCollectionEntity
  (lending)              (collections)

LendingEntity 1 ──── 0..1 SavingsHistoryEntity
  (if fromSavings)        (withdrawal record)

LendingEntity * ──── 1 FinancialCycleEntity
  (lendings)              (cycle)
```

## Repository Interface

### LendingRepository

```dart
abstract class LendingRepository {
  Future<LendingEntity> createLending({
    required String borrowerName,
    required int totalAmount,
    required bool fromSavings,
    required int cycleId,
    String? notes,
  });
  Future<LendingEntity?> getLendingById(int id);
  Future<List<LendingEntity>> getActiveLendings();
  Future<List<LendingEntity>> getCollectedLendings();
  Future<void> deleteLending(int id);
  Future<void> addCollection({required int lendingId, required int amount});
  Future<List<LendingCollectionEntity>> getCollectionsForLending(int lendingId);
  Future<int> getTotalLendingsFromBalanceForCycle(int cycleId);
  Future<int> getTotalOutstandingLendingAmount();
}
```

## Validation Rules

| Rule | Entity | Constraint |
|------|--------|------------|
| Borrower name required | LendingEntity | Non-empty string |
| Amount positive | LendingEntity | totalAmount > 0 |
| Amount within balance | LendingEntity | totalAmount <= available balance (if from balance) |
| Amount within savings | LendingEntity | totalAmount <= savings balance (if from savings) |
| Collection positive | LendingCollectionEntity | amount > 0 |
| Collection within remaining | LendingCollectionEntity | amount <= lending.remainingAmount |
| Auto-mark collected | LendingEntity | isFullyCollected = true when collectedAmount == totalAmount |

## State Transitions

```
Lending Lifecycle:
  Created (active) → Partially Collected → Fully Collected
                   → Deleted (removed from tracking)

  - Created: collectedAmount = 0, isFullyCollected = false
  - Partially Collected: 0 < collectedAmount < totalAmount
  - Fully Collected: collectedAmount == totalAmount, isFullyCollected = true
  - Deleted: record removed (balance/savings NOT reversed)
```

## Migration

**Schema version**: 5 → 6

```dart
if (from < 6) {
  await m.create(lendings);
  await m.create(lendingCollections);
  await m.addColumn(savingsHistory, savingsHistory.relatedLendingId);
}
```
