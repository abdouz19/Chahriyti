# Implementation Plan: Full CRUD Operations for Financial Records

**Branch**: `006-crud-operations` | **Date**: 2026-06-29 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/006-crud-operations/spec.md`

## Summary

Add edit and delete capabilities across all financial record types (expenses, debts, lendings, goals, additional income) so users can correct mistakes and remove stale records. Most backend infrastructure exists for Debt and Goal — this feature closes the gaps for Lending (missing update path entirely) and Additional Income (missing all CRUD), then wires UI access points (edit buttons, delete confirmations) for all entities. Savings deposits are excluded from direct edit/delete to preserve financial data integrity.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: Drift (ORM), Freezed (immutable models), BLoC/Cubit (state), GoRouter (navigation), google_fonts (Cairo)
**Storage**: SQLite via Drift — **no schema migration** (no new tables/columns needed)
**Testing**: flutter_test (unit tests for new use cases)
**Target Platform**: Android / iOS mobile app
**Project Type**: Mobile app (offline-first personal finance tracker)
**Performance Goals**: 60 fps UI, form submit < 200ms, confirmation dialog < 100ms to appear
**Constraints**: Offline-capable, Arabic RTL UI, all amounts are int (centimes), no data loss on crash
**Scale/Scope**: Single user, ~50 screens total, modifying 15 existing files + 3 new use case files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | PASS | SQLite-only, no network calls, Drift transactions for cascaded deletes |
| II. Testing is Mandatory | PASS | Unit tests for 3 new use cases + 2 new cubit methods |
| III. Data Safety | PASS | Confirmation dialogs on all deletes; atomic DAO transactions for cascade |
| IV. Approved Technology Stack | PASS | No new dependencies — all existing (Drift, Freezed, Cubit, GoRouter) |
| V. Clean Architecture | PASS | New use cases in Application layer; DAO methods in Infrastructure; UI in Presentation |
| VI. Separation of Concerns | PASS | One use case per operation; cubits call use cases only |
| VII. Performance Engineering | PASS | const widgets, no heavy work in build(), dialogs are lightweight |
| VIII. Product Stability | PASS | No schema migration; additive changes only; backward compatible |
| IX. Definition of Done | PASS | Implemented + unit tested + confirmation dialogs + offline-capable |

## Project Structure

### Documentation (this feature)

```text
specs/006-crud-operations/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0: gap analysis and decisions
├── data-model.md        # Phase 1: entity/method definitions
├── quickstart.md        # Phase 1: integration test scenarios
├── checklists/
│   └── requirements.md  # Specification quality checklist
└── tasks.md             # Phase 2: task breakdown (via /speckit-tasks)
```

### Source Code Changes

```text
chahriyti/lib/
├── domain/
│   └── repositories/
│       ├── lending_repository.dart          # MODIFIED: add updateLending method
│       └── income_repository.dart           # MODIFIED: add updateIncome, deleteIncome methods
│
├── application/use_cases/
│   ├── lending/
│   │   └── update_lending_use_case.dart     # NEW: validate + call repo.updateLending
│   └── income/
│       ├── update_income_use_case.dart      # NEW: description-only edit (blocks toSavings income amount change)
│       └── delete_income_use_case.dart      # NEW: blocks if toSavings=true; else deletes
│
├── infrastructure/
│   ├── database/
│   │   └── daos/
│   │       ├── lendings_dao.dart            # MODIFIED: add updateLending() query method
│   │       └── incomes_dao.dart             # MODIFIED: add updateIncome(), deleteIncome() methods
│   └── repositories/
│       ├── lending_repository_impl.dart     # MODIFIED: implement updateLending
│       └── income_repository_impl.dart      # MODIFIED: implement updateIncome, deleteIncome
│
├── presentation/
│   ├── expense/
│   │   ├── cubits/expense_cubit.dart        # MODIFIED: add deleteExpense(expenseId, cycleId) method
│   │   └── widgets/
│   │       └── recent_expenses_list.dart    # MODIFIED: add long-press → edit/delete menu
│   ├── debt/
│   │   └── pages/
│   │       ├── debt_detail_page.dart        # MODIFIED: add edit AppBar action
│   │       └── add_debt_page.dart           # MODIFIED: optional DebtEntity param for edit mode
│   ├── lending/
│   │   ├── cubits/lending_cubit.dart        # MODIFIED: add updateLending method
│   │   └── pages/
│   │       ├── lending_detail_page.dart     # MODIFIED: add edit AppBar action
│   │       └── add_lending_page.dart        # MODIFIED: optional LendingEntity param for edit mode
│   ├── goal/
│   │   ├── cubits/goal_cubit.dart           # no change needed (already has updateGoal, deleteGoal)
│   │   └── pages/
│   │       ├── goal_detail_page.dart        # MODIFIED: add edit AppBar action
│   │       └── add_goal_page.dart           # MODIFIED: optional GoalEntity param for edit mode
│   └── income/
│       ├── cubits/income_cubit.dart         # MODIFIED: add updateIncome, deleteIncome methods
│       └── pages/
│           └── add_income_page.dart         # MODIFIED: income list items show edit/delete actions
│
└── core/di/
    └── injection.dart                       # MODIFIED: register UpdateLendingUseCase,
                                             #           UpdateIncomeUseCase, DeleteIncomeUseCase

chahriyti/test/unit/
├── lending/
│   └── update_lending_use_case_test.dart    # NEW
└── income/
    ├── update_income_use_case_test.dart     # NEW
    └── delete_income_use_case_test.dart     # NEW
```

**Structure Decision**: Clean Architecture layout maintained. All modifications are additive — new optional parameters on existing pages, new methods on existing cubits, no file renames or removals.

## Implementation Notes

### Expense Delete (no new use case needed)

`DeleteExpenseUseCase` and `ExpenseRepository.deleteExpense` already exist. Only missing:
1. `ExpenseCubit.deleteExpense(int expenseId, int cycleId)` method
2. Long-press menu on `RecentExpensesList` items surfacing edit/delete actions

### Debt Edit (no new use case needed)

`UpdateDebtUseCase`, `DeleteDebtUseCase`, `DebtCubit.updateDebt/deleteDebt` all exist. Only missing:
1. Edit button (AppBar trailing icon) in `debt_detail_page.dart`
2. `AddDebtPage` accepting optional `DebtEntity? initialDebt` — when non-null, pre-fills form and calls `updateDebt` on submit

### Goal Edit (no new use case needed)

`UpdateGoalUseCase`, `DeleteGoalUseCase`, `GoalCubit.updateGoal/deleteGoal` all exist. Only missing:
1. Edit button in `goal_detail_page.dart`
2. `AddGoalPage` accepting optional `GoalEntity? initialGoal`

### Lending Edit (full stack needed)

Nothing exists for lending update. Full stack:
- `LendingsDao.updateLending()` → Drift update query
- `LendingRepository.updateLending()` → interface method
- `LendingRepositoryImpl.updateLending()` → calls DAO
- `UpdateLendingUseCase` → validates totalAmount ≥ collectedAmount
- `LendingCubit.updateLending()` → calls use case, emits state
- Edit button in `lending_detail_page.dart`
- `AddLendingPage` edit mode with `LendingEntity? initialLending`

### Additional Income Edit/Delete

No existing CRUD. Add:
- `IncomesDao.updateIncome()` → Drift update (description only)
- `IncomesDao.deleteIncome(int id)` → reads `toSavings` flag; if true, throws; else deletes
- `IncomeRepository.updateIncome()`, `deleteIncome()` → interface
- `IncomeRepositoryImpl` → implements both
- `UpdateIncomeUseCase` → description-only edit
- `DeleteIncomeUseCase` → blocks `toSavings=true`; else calls repo
- `IncomeCubit.updateIncome()`, `deleteIncome()` → UI state
- `AddIncomePage` — existing income list items rendered with edit/delete actions (long-press or trailing icon)

### UX Pattern for Edit Mode Pages

All add pages modified for edit mode follow this pattern:

```dart
class AddDebtPage extends StatefulWidget {
  final DebtEntity? initialDebt;  // null = create, non-null = edit
  const AddDebtPage({this.initialDebt, super.key});
  ...
}
```

- Title changes: "إضافة دين" → "تعديل الدين"
- Submit button: "حفظ" (both modes)
- Pre-fill: `TextEditingController.text = initialDebt.creditorName` in `initState`
- Submit calls: `createDebt(...)` OR `updateDebt(id: initialDebt.id, ...)`

### Confirmation Dialog Usage

All delete actions use the existing static method:

```dart
final confirmed = await ConfirmationDialog.show(
  context,
  title: 'حذف الدين',
  message: 'سيتم حذف الدين وجميع المدفوعات. هل تريد المتابعة؟',
  confirmColor: AppColors.error,
);
if (confirmed) cubit.deleteDebt(id);
```

## Complexity Tracking

No constitution violations. All new patterns are strict extensions of the existing Debt CRUD pattern.
