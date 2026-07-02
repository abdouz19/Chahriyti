# Data Model: Salary Split to Savings

**Feature**: 004-salary-split-savings  
**Date**: 2026-06-26

## Entity Changes

### FinancialCycleEntity (Modified)

**File**: `chahriyti/lib/domain/entities/financial_cycle_entity.dart`

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| id | int | yes | auto | Primary key |
| startDate | DateTime | yes | — | Cycle start date |
| endDate | DateTime | yes | — | Cycle end date |
| salaryAmount | int | yes | — | Full salary amount in DZD |
| **salarySplitAmount** | **int** | **yes** | **0** | **Amount allocated to savings at cycle start** |
| isActive | bool | yes | true | Whether this is the current active cycle |

**Validation Rules**:
- `salarySplitAmount >= 0`
- `salarySplitAmount <= salaryAmount`
- Once set (cycle created with split), the value is immutable for that cycle

**Computed**:
- `effectiveBalance = salaryAmount - salarySplitAmount` (starting balance for the cycle)

### SavingsHistoryEntity (Unchanged — Reused)

**File**: `chahriyti/lib/domain/entities/savings_history_entity.dart`

A salary split creates a new record with:
- `type`: `SavingsTransactionType.deposit`
- `amount`: the split amount
- `description`: `"تقسيم الراتب"`
- `relatedCycleId`: the new cycle's ID
- `relatedExpenseId`: null
- `relatedDebtPaymentId`: null

This reuses the existing entity without modification.

## Database Changes

### Table: financial_cycles (Modified)

**File**: `chahriyti/lib/infrastructure/database/tables/financial_cycles_table.dart`

Add column:
```dart
IntColumn get salarySplitAmount => integer().withDefault(const Constant(0))();
```

### Migration: v4 → v5

**File**: `chahriyti/lib/infrastructure/database/app_database.dart`

```dart
if (from < 5) {
  await m.addColumn(financialCycles, financialCycles.salarySplitAmount);
}
```

This is a non-destructive, additive migration. Existing cycles get `salarySplitAmount = 0`, preserving current balance calculations exactly.

## Repository Interface Changes

### CycleRepository (Modified)

**File**: `chahriyti/lib/domain/repositories/cycle_repository.dart`

Update `createCycle` signature:
```dart
Future<FinancialCycleEntity> createCycle({
  required DateTime startDate,
  required DateTime endDate,
  required int salaryAmount,
  int salarySplitAmount = 0,  // NEW — defaults to 0
});
```

## Balance Formula

**Before**:
```
currentBalance = salaryAmount + totalIncome - totalExpenses - totalDebtPayments
```

**After**:
```
currentBalance = salaryAmount - salarySplitAmount + totalIncome - totalExpenses - totalDebtPayments
```

**Affected locations**:
1. `GetDashboardDataUseCase` — main dashboard balance
2. `DepositCycleSavingsUseCase` — end-of-cycle savings calculation
3. `debt_detail_page.dart` — inline `_getCurrentBalance()`
4. `add_expense_page.dart` — inline `_getCurrentBalance()`

## Relationships

```
FinancialCycleEntity (1) ──creates──> (0..1) SavingsHistoryEntity [salary split deposit]
                                              ↑
                                     linked via relatedCycleId
```

A cycle may have zero or one salary split deposit. The deposit is created at cycle start, only if the user allocates a non-zero amount to savings.
