# Data Model: Savings Account (المدخرات)

**Date**: 2026-06-26  
**Schema Version**: 3 → 4

---

## New Table: `savings_history`

Stores all savings transactions — deposits (cycle-end) and withdrawals (pay from savings).

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `id` | INTEGER | NO | autoincrement | Primary key |
| `type` | TEXT | NO | — | `'deposit'` or `'withdrawal'` |
| `amount` | INTEGER | NO | — | Amount in DZD (always positive) |
| `description` | TEXT | NO | — | Human-readable description (Arabic) |
| `related_cycle_id` | INTEGER | YES | NULL | FK → `financial_cycles.id` (for deposits) |
| `related_expense_id` | INTEGER | YES | NULL | FK → `expenses.id` (for expense withdrawals) |
| `related_debt_payment_id` | INTEGER | YES | NULL | FK → `debt_payments.id` (for debt withdrawals) |
| `created_at` | DATETIME | NO | `CURRENT_TIMESTAMP` | When the transaction occurred |

**Constraints**:
- `type` must be one of `'deposit'`, `'withdrawal'`
- Exactly one of `related_cycle_id`, `related_expense_id`, `related_debt_payment_id` should be non-null per record
- `amount` must be > 0

**Indexes**:
- Primary key on `id`
- Index on `type` for filtered queries (deposits vs withdrawals)

---

## Modified Table: `expenses`

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `from_savings` | BOOL | NO | `false` | Whether this expense was paid from savings |

**Impact**: Existing expenses get `from_savings = false` via default. No data migration needed.

---

## Modified Table: `debt_payments`

| Column | Type | Nullable | Default | Description |
|--------|------|----------|---------|-------------|
| `from_savings` | BOOL | NO | `false` | Whether this payment was made from savings |

**Impact**: Existing debt payments get `from_savings = false` via default. No data migration needed.

---

## Entity Definitions

### SavingsHistoryEntity (NEW)

```
SavingsHistoryEntity (Freezed)
├── id: int
├── type: SavingsTransactionType (enum: deposit, withdrawal)
├── amount: int
├── description: String
├── relatedCycleId: int?
├── relatedExpenseId: int?
├── relatedDebtPaymentId: int?
└── createdAt: DateTime
```

### ExpenseEntity (MODIFIED)

```
ExpenseEntity (Freezed)
├── ... existing fields ...
└── fromSavings: bool (default: false)    # NEW
```

### DebtPayment (MODIFIED — via DAO/repository, no separate entity exists)

The `debt_payments` table is accessed directly via `DebtsDao`. The `fromSavings` field is passed through `insertPayment()` and stored.

---

## Relationships

```
financial_cycles ──1:N──> savings_history (deposits)
expenses ──1:1──> savings_history (withdrawals, via related_expense_id)
debt_payments ──1:1──> savings_history (withdrawals, via related_debt_payment_id)
```

---

## Balance Formulas

**Current Balance** (per cycle):
```
salary + SUM(additional_incomes WHERE cycleId)
       - SUM(expenses WHERE cycleId AND fromSavings = false)
       - SUM(debt_payments WHERE cycleId AND fromSavings = false)
```

**Savings Balance** (global):
```
SUM(amount WHERE type = 'deposit') - SUM(amount WHERE type = 'withdrawal')
```

---

## State Transitions

### Savings History Record Lifecycle

```
[Cycle Ends with positive balance]
  → CREATE savings_history(type='deposit', amount=remainingBalance, relatedCycleId=cycleId)

[Expense paid from savings]
  → CREATE savings_history(type='withdrawal', amount=expenseAmount, relatedExpenseId=expenseId)

[Debt payment from savings]
  → CREATE savings_history(type='withdrawal', amount=paymentAmount, relatedDebtPaymentId=paymentId)

[Savings-funded expense deleted]
  → DELETE savings_history WHERE relatedExpenseId = expenseId

[Savings-funded expense amount edited]
  → UPDATE savings_history SET amount = newAmount WHERE relatedExpenseId = expenseId

[Savings-funded debt payment deleted]
  → DELETE savings_history WHERE relatedDebtPaymentId = paymentId
```

---

## Migration Script (Drift)

```dart
// Schema version 3 → 4
if (from < 4) {
  await migrator.createTable(savingsHistory);
  await migrator.addColumn(expenses, expenses.fromSavings);
  // debt_payments needs column too — if table structure allows ALTER
  // Otherwise handled via Drift's addColumn for the DebtPayments table
}
```

**Backward Compatibility**: All new columns have defaults (`false` for booleans). New table is independent. Existing data is completely unaffected. App version with schema v3 data will migrate seamlessly to v4 on first launch.
