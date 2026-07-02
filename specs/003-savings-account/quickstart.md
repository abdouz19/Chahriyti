# Quickstart: Savings Account (المدخرات)

**Date**: 2026-06-26

## Implementation Order

Follow this order to build incrementally with testable checkpoints at each step.

### Step 1: Data Layer (Foundation)

1. Create `savings_history_table.dart` — Drift table definition
2. Add `fromSavings` column to `expenses_table.dart`
3. Create/modify `debt_payments_table.dart` to add `fromSavings` column
4. Register new table in `app_database.dart`, bump schema to v4, add migration
5. Create `savings_dao.dart` — CRUD + balance query
6. Run `dart run build_runner build` to generate Drift code

**Checkpoint**: Database compiles, migration runs, new table exists.

### Step 2: Domain Layer

1. Create `SavingsTransactionType` enum (deposit, withdrawal)
2. Create `savings_history_entity.dart` with Freezed
3. Create `savings_repository.dart` interface
4. Add `fromSavings` field to `expense_entity.dart`
5. Add `fromSavings` parameter to `expense_repository.dart` interface
6. Add `fromSavings` parameter to `debt_repository.dart` interface
7. Run `dart run build_runner build` to generate Freezed code

**Checkpoint**: All entities compile, interfaces defined.

### Step 3: Infrastructure Layer

1. Create `savings_repository_impl.dart`
2. Update `expense_repository_impl.dart` — pass `fromSavings` through
3. Update `debt_repository_impl.dart` — pass `fromSavings` through
4. Update `expenses_dao.dart` — filter `fromSavings=false` in `getTotalExpenses()`
5. Update `debts_dao.dart` — filter `fromSavings=false` in `getTotalPaymentsForCycle()`

**Checkpoint**: Repositories compile, savings balance query works.

### Step 4: Application Layer (Use Cases)

1. Create `get_savings_balance_use_case.dart`
2. Create `get_savings_history_use_case.dart`
3. Create `deposit_cycle_savings_use_case.dart`
4. Create `withdraw_savings_use_case.dart` (handles both expense + debt withdrawal creation)
5. Modify `reset_cycle_use_case.dart` — call deposit use case on cycle close
6. Modify `add_expense_use_case.dart` — handle fromSavings flag + create withdrawal
7. Modify `add_debt_payment_use_case.dart` — handle fromSavings flag + create withdrawal
8. Wire up in `injection.dart`

**Checkpoint**: All use cases compile, unit tests pass.

### Step 5: Presentation Layer — Savings Screen

1. Create `savings_state.dart` (Freezed states)
2. Create `savings_cubit.dart`
3. Create `savings_history_item.dart` widget
4. Create `savings_page.dart`
5. Add `/savings` route to `app_router.dart`
6. Add savings entry to `settings_page.dart`

**Checkpoint**: Navigate to Settings > المدخرات, see empty state.

### Step 6: Presentation Layer — Payment Source Toggle

1. Create shared `payment_source_toggle.dart` widget
2. Integrate into `add_expense_page.dart` + `expense_cubit.dart`
3. Integrate into `debt_detail_page.dart` + `debt_cubit.dart`

**Checkpoint**: Toggle appears when savings > 0, hidden when savings = 0.

### Step 7: Cycle-End Integration

1. Verify `reset_cycle_use_case.dart` creates deposit on cycle close
2. Test: close cycle with positive balance → savings deposit appears
3. Test: close cycle with zero/negative balance → no deposit

**Checkpoint**: Full savings deposit flow works end-to-end.

### Step 8: Edit/Delete Reversal

1. Modify expense edit/delete flow to reverse savings withdrawal
2. Modify debt payment delete flow to reverse savings withdrawal
3. Test reversal scenarios

**Checkpoint**: Deleting/editing savings-funded transactions restores savings.

### Step 9: Testing

1. Unit tests for all 4 new use cases
2. Unit tests for modified use cases (add expense, add payment, reset cycle)
3. Widget tests for savings page and payment source toggle
4. Integration test for full savings flow

**Checkpoint**: All tests pass.

## Key Decisions

- **No new dependencies** — uses existing Drift, BLoC, Freezed stack
- **Additive migration only** — no risk to existing data
- **Shared toggle widget** — reused in expense and debt payment forms
- **Balance computed on-demand** — no cached balance field to keep in sync
