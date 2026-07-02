# Phase 0 Research: Full CRUD Operations for Financial Records

**Feature**: `006-crud-operations` | **Date**: 2026-06-29

## Gap Analysis: What Exists vs. What's Needed

| Entity | Edit UC | Delete UC | Repo Update | Repo Delete | Cubit Edit | Cubit Delete | Edit Page |
|--------|---------|-----------|-------------|-------------|------------|--------------|-----------|
| Expense | ✓ | ✓ | ✓ | ✓ | ✗ | ✗ | ✓ |
| Debt | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Lending | ✗ | ✓ | ✗ | ✓ | ✗ | ✓ | ✗ |
| Goal | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| Additional Income | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| Savings Deposit | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |

## Decisions

### Decision 1: Savings deposits are out of scope for edit/delete

**Chosen**: Exclude direct savings deposit deletion/editing.

**Rationale**: Savings deposits fall into two categories:
- **Auto-generated**: Salary-split deposits and cycle-end deposits — these are system-generated financial facts tied to cycle state. Deleting them would corrupt the financial history.
- **Withdrawal reversals**: Savings withdrawals linked to expenses, debt payments, and lendings are already cascade-deleted when their parent transaction is deleted. The user gets the "undo" of a savings-funded transaction by deleting the expense/lending/debt.

There is no safe "edit amount" operation for deposits without full re-validation of the cycle state. This is excluded from scope to maintain data integrity.

**Alternative rejected**: Allow deleting cycle deposits → rejected because it decouples savings balance from cycle history, creating phantom balance inconsistencies.

---

### Decision 2: Edit mode via optional `entity` parameter on existing add pages

**Chosen**: Reuse existing add pages (`add_debt_page`, `add_lending_page`, `add_goal_page`) with an optional entity parameter that pre-fills the form. No separate `edit_*_page` files.

**Rationale**: 
- Debt, Lending, and Goal add pages already have all the required form fields
- Passing `DebtEntity?`, `LendingEntity?`, `GoalEntity?` pre-fills the form
- When entity is non-null, the form submit button calls update instead of create
- A single page handles both flows → half the maintenance surface
- Mirrors the pattern already used in `edit_expense_page` (separate page) and is simpler for the other entities where the add pages are already clean

**Alternative rejected**: Separate `edit_debt_page` files → rejected because they would duplicate form widgets with near-identical code.

---

### Decision 3: Delete access point — via detail page (not swipe-to-delete)

**Chosen**: Edit and delete buttons placed in each entity's detail page (AppBar action + body button). List pages show a long-press context menu for quick delete.

**Rationale**:
- Detail pages already exist for Debt, Lending, Goal, and expense history
- Swipe-to-delete on list items risks accidental deletions — too dangerous for financial data
- Confirmation dialog always required before deletion
- The existing `ConfirmationDialog.show()` widget handles this consistently

**Alternative rejected**: Swipe-to-delete on list cards → rejected because financial records require explicit intent confirmation; a swipe is too easy to trigger accidentally.

---

### Decision 4: Additional Income — edit constrained to description + amount only

**Chosen**: Allow editing description and amount for additional income. `toSavings` cannot be changed after creation (it affects savings balance at creation time).

**Rationale**:
- Changing `toSavings` retroactively would require reversing and re-creating a savings deposit — equivalent to a delete + create operation, which is safer done explicitly
- Editing description + amount covers the common case (typo, wrong amount)
- If amount changes and `toSavings=true`, the savings deposit is updated to match (same pattern as `updateWithdrawalAmountByExpenseId`)

**Alternative rejected**: Full field editing including `toSavings` → rejected because toggling `toSavings` retroactively breaks savings balance atomicity.

---

### Decision 5: Lending edit — add `updateLending` to DAO + repository + use case

**Chosen**: New `updateLending` method added at all layers (DAO, repository interface, repository impl, use case, cubit).

**Rationale**: No update path exists for lendings at any layer. Must be built from scratch following the same pattern as debt update (which is complete).

**Fields editable**: `borrowerName`, `notes`, `totalAmount` (if not yet partially collected). If partially collected, `totalAmount` must be ≥ `collectedAmount`.

---

### Decision 6: Expense delete accessible from recent list + expense history

**Chosen**: Add a delete action (long-press menu or trailing icon) on expense items in the recent expenses list on the home page AND in the expense history page. The existing `EditExpensePage` already handles edit.

**Rationale**: ExpenseCubit currently only adds expenses. Needs `deleteExpense` method. The recent list and history page are the natural access points.

**Note**: Delete is cycle-guarded — only current-cycle expenses deletable (already enforced by `DeleteExpenseUseCase`).

## Key Existing Patterns to Reuse

- **ConfirmationDialog.show()**: `presentation/shared/widgets/confirmation_dialog.dart` — static method returning `Future<bool>`. All delete confirmations use this.
- **Debt cubit pattern**: `presentation/debt/cubits/debt_cubit.dart` — `updateDebt()` and `deleteDebt()` — exact pattern to replicate for Lending and Income cubits.
- **UpdateDebtUseCase**: `application/use_cases/debt/update_debt_use_case.dart` — pattern for UpdateLendingUseCase and UpdateIncomeUseCase.
- **DeleteDebtUseCase**: `application/use_cases/debt/delete_debt_use_case.dart` — pattern for DeleteIncomeUseCase.
- **edit_expense_page.dart**: Pre-populated form with `EditExpenseUseCase` — validates cycle is active before update.
