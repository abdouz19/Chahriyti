# Data Model: Full CRUD Operations for Financial Records

**Feature**: `006-crud-operations` | **Date**: 2026-06-29

## Schema Changes

**No schema migration required.** All entities and tables exist. This feature adds use cases and DAO query methods only — no new columns or tables.

## New DAO Methods

### LendingsDao — NEW method

```dart
Future<void> updateLending({
  required int id,
  String? borrowerName,
  String? notes,
  int? totalAmount,   // constrained: must be >= collectedAmount
})
```

**Constraint**: If `totalAmount` is provided and `collectedAmount > 0`, the DAO must verify `totalAmount >= collectedAmount` before updating.

---

### IncomesDao — NEW methods

```dart
Future<void> updateIncome({
  required int id,
  String? description,
  int? newAmount,   // if toSavings=true, triggers savings deposit update
})

Future<void> deleteIncome(int id)
// Note: if deleted income had toSavings=true, savings deposit must be reversed
// This requires IncomesDao to read toSavings flag before deletion
```

## New Repository Methods

### LendingRepository — NEW method

```dart
Future<void> updateLending({
  required int id,
  String? borrowerName,
  String? notes,
  int? totalAmount,
})
```

### IncomeRepository — NEW methods

```dart
Future<void> updateIncome({
  required int id,
  String? description,
  int? newAmount,
})

Future<void> deleteIncome(int id)
```

## New Use Cases

### UpdateLendingUseCase

**File**: `application/use_cases/lending/update_lending_use_case.dart`

**Parameters**: `id`, optional `borrowerName`, `notes`, `totalAmount`

**Validation**:
- At least one field must be non-null
- `totalAmount` if provided must be > 0

**Side effects**: None (lending amount doesn't directly affect cycle balance until collected)

---

### UpdateIncomeUseCase

**File**: `application/use_cases/income/update_income_use_case.dart`

**Parameters**: `id`, optional `description`, `newAmount`

**Validation**:
- At least one field must be non-null
- `newAmount` if provided must be > 0

**Side effects**: If income `toSavings=true` and `newAmount` is provided, update the linked savings deposit amount via `SavingsRepository` (same pattern as `updateWithdrawalAmountByExpenseId`).

**Note**: `SavingsRepository` needs a new method `updateDepositAmountByIncomeId(int incomeId, int newAmount)` — currently only `updateWithdrawalAmount*` methods exist.

---

### DeleteIncomeUseCase

**File**: `application/use_cases/income/delete_income_use_case.dart`

**Parameters**: `incomeId`

**Side effects**: If income `toSavings=true`, delete the linked savings deposit (needs `SavingsRepository.deleteDepositByIncomeId(int incomeId)`).

**Note**: `SavingsRepository` needs a new method `deleteDepositByIncomeId(int incomeId)`. This also requires `SavingsHistoryTable` to have a nullable `incomeId` foreign key column — **this IS a schema change**. See Schema Note below.

## Schema Note: Savings-Income Link

### Option A (Selected): Don't track savings deposits linked to income

**Decision**: Income `toSavings=true` case is out of scope for delete. If a user wants to undo an income-to-savings operation, they must manually do a savings withdrawal. This avoids a schema migration.

**Rationale**: The `AdditionalIncomeEntity` has no `toSavings` field in the entity (only in the DB table, and the entity doesn't expose it). Adding an income-savings link requires schema v7 migration and Freezed regeneration. This is deferred to a separate feature.

**What this means for UpdateIncomeUseCase**: Amount edit for income entries is allowed only for description changes. Amount changes for `toSavings=true` incomes are blocked with a clear message ("لا يمكن تعديل مبلغ الدخل المحوّل للمدخرات").

**Simplified scope**:
- Additional Income: edit description only (not amount, to avoid the savings sync problem)
- Additional Income: delete blocked if `toSavings=true` with clear message
- This keeps implementation safe without schema changes

## Entity Edit Rules Summary

| Entity | Editable Fields | Delete Rules |
|--------|----------------|--------------|
| Expense | itemName, amount, notes, category, subcategory, fromSavings | Must be in current cycle |
| Debt | creditorName, totalAmount, notes | Cascade deletes payments; savings payments reversed |
| Lending | borrowerName, notes, totalAmount (if totalAmount ≥ collectedAmount) | Cascade deletes collections; savings-funded lending reversed |
| Goal | name, targetAmount, notes, deadline | Contributions stay in savings balance |
| Additional Income | description only | Blocked if toSavings=true (with clear message) |

## Cubit Changes Summary

| Cubit | New Methods |
|-------|-------------|
| ExpenseCubit | `deleteExpense(int expenseId, int cycleId)` |
| LendingCubit | `updateLending({required int id, String? borrowerName, String? notes, int? totalAmount})` |
| IncomeCubit | `updateIncome(int id, String description)`, `deleteIncome(int id)` |
| DebtCubit | already has `updateDebt`, `deleteDebt` ✓ |
| GoalCubit | already has `updateGoal`, `deleteGoal` ✓ |
