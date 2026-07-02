# Research: Savings Account (المدخرات)

**Date**: 2026-06-26  
**Status**: Complete — No NEEDS CLARIFICATION items in Technical Context.

## Research Summary

All technical decisions derive from established codebase patterns. No external research required.

---

## R1: Database Migration Strategy (Schema v3 → v4)

**Decision**: Additive migration — new table + ALTER TABLE for new columns with defaults.

**Rationale**: Drift supports schema migrations via `MigrationStrategy`. The existing app is at schema version 3. Adding a new `savings_history` table and `fromSavings` boolean columns (defaulting to `false`) is purely additive and cannot break existing data.

**Alternatives considered**:
- Separate savings amount tracking via computed aggregate (rejected: slower queries, no history audit trail)
- Storing savings as a field on the user record (rejected: loses transaction history, no audit trail)

**Implementation**:
```dart
// In app_database.dart
@override
int get schemaVersion => 4;

MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (migrator, from, to) async {
    if (from < 4) {
      await migrator.createTable(savingsHistory);
      await migrator.addColumn(expenses, expenses.fromSavings);
      await migrator.addColumn(debtPayments, debtPayments.fromSavings);
    }
  },
);
```

---

## R2: Savings Balance Computation Strategy

**Decision**: Compute savings balance on-demand via SUM query on `savings_history` table.

**Rationale**: No cached balance field needed. The `savings_history` table is append-mostly (deposits on cycle end, withdrawals on savings-funded payments). A simple `SELECT SUM(CASE WHEN type='deposit' THEN amount ELSE -amount END) FROM savings_history` is fast for single-user local data.

**Alternatives considered**:
- Cached balance field on user record (rejected: introduces stale data risk, requires synchronization)
- Separate running balance column in savings_history (rejected: adds complexity, risk of desync)

---

## R3: fromSavings Flag Integration with Existing Balance Calculation

**Decision**: Add `WHERE fromSavings = false` filter to existing `getTotalExpenses(cycleId)` and `getTotalPaymentsForCycle(cycleId)` DAO methods.

**Rationale**: The dashboard balance formula is `salary + income - expenses - debtPayments`. By filtering out `fromSavings = true` records in the DAO queries, the balance calculation naturally excludes savings-funded transactions without changing any use case logic upstream.

**Alternatives considered**:
- Separate query methods for "cycle-only" vs "all" totals (rejected: more methods to maintain, existing callers all want cycle-only totals)
- Post-query filtering in repository layer (rejected: less efficient, pushes logic out of DB)

---

## R4: Savings Withdrawal Record Linking

**Decision**: `savings_history` records reference the source via nullable `relatedExpenseId` or `relatedDebtPaymentId` foreign keys.

**Rationale**: When a savings-funded expense or debt payment is deleted/edited, the system needs to find and reverse/adjust the corresponding withdrawal. Direct FK references enable this lookup efficiently. Only one of the two FK columns is populated per withdrawal record.

**Alternatives considered**:
- Generic `relatedType` + `relatedId` pattern (rejected: loses FK constraints, more error-prone)
- No linking, just description matching (rejected: fragile, can't handle edits reliably)

---

## R5: Cycle-End Savings Deposit Trigger

**Decision**: Hook into the existing `ResetCycleUseCase` to calculate and deposit savings when a cycle is closed.

**Rationale**: The app currently has manual cycle reset via Settings. The `ResetCycleUseCase` already closes the old cycle and creates a new one. Adding the savings deposit calculation between these two steps is the natural integration point.

**Alternatives considered**:
- Automatic time-based cycle detection (not in scope — the app already uses manual cycle reset)
- Separate "deposit savings" button (rejected by spec: FR-020 prohibits manual deposit)

---

## R6: Payment Source Toggle Widget Design

**Decision**: Create a shared `PaymentSourceToggle` widget using `SegmentedButton` or custom toggle chips, consistent with existing app styling (AppColors, AppTypography, 16px border radius).

**Rationale**: Both expense and debt payment flows need the identical toggle. A shared widget in `presentation/shared/widgets/` follows the existing pattern of shared widgets (e.g., `MoneyText`, `LoadingShimmer`).

**Alternatives considered**:
- Inline toggle in each form (rejected: code duplication, inconsistent behavior risk)
- Dropdown/select (rejected: toggle is faster for 2 options, matches bank-app metaphor)
