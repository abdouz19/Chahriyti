# Tasks: Full CRUD Operations for Financial Records

**Input**: Design documents from `specs/006-crud-operations/`
**Prerequisites**: plan.md ✓, spec.md ✓, research.md ✓, data-model.md ✓, quickstart.md ✓

**Tests**: Unit tests included per Constitution Principle II (testing is mandatory).

**Organization**: Tasks grouped by user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no shared dependencies)
- **[Story]**: Maps to user story from spec.md (US1–US10)

## Path Conventions

All paths relative to `chahriyti/` (Flutter project root).

---

## Phase 1: Setup

**Purpose**: No new packages or schema migrations needed. Verify DI injection.dart is ready for new registrations.

- [X] T001 Confirm `chahriyti/lib/core/di/injection.dart` has slots ready for lending and income use case registrations (read-only verification before Phase 2 adds them)

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Add update/delete infrastructure for Lending and Additional Income at all backend layers. These use cases are required before US7–US10 UI work can proceed. Expense and Debt/Goal backend is already complete.

**⚠️ CRITICAL**: T002–T014 must complete before Phase 6 and Phase 7 begin.

### Lending Update Stack (blocks US7)

- [X] T002 Add `updateLending({required int id, String? borrowerName, String? notes, int? totalAmount})` to `lib/domain/repositories/lending_repository.dart`
- [X] T003 Add `updateLending({required int id, String? borrowerName, String? notes, int? totalAmount})` DAO method to `lib/infrastructure/database/daos/lendings_dao.dart` — Drift update query; validate `totalAmount >= collectedAmount` when `totalAmount` is set
- [X] T004 Implement `updateLending` in `lib/infrastructure/repositories/lending_repository_impl.dart` — delegates to `LendingsDao.updateLending`
- [X] T005 Create `lib/application/use_cases/lending/update_lending_use_case.dart` — validates at least one field non-null, `totalAmount > 0` if provided, `totalAmount >= collectedAmount`

### Income CRUD Stack (blocks US9, US10)

- [X] T006 [P] Add `updateIncome({required int id, String? description})` and `deleteIncome(int id)` to `lib/domain/repositories/income_repository.dart` — see data-model.md for constraint: amount editing blocked when `toSavings=true`
- [X] T007 [P] Add `updateIncome({required int id, String? description})` and `deleteIncome(int id)` to `lib/infrastructure/database/daos/incomes_dao.dart` — `deleteIncome` reads `toSavings` column; if true, throws `ArgumentError` (cannot delete income linked to savings)
- [X] T008 Implement `updateIncome` and `deleteIncome` in `lib/infrastructure/repositories/income_repository_impl.dart`
- [X] T009 [P] Create `lib/application/use_cases/income/update_income_use_case.dart` — description-only edit; `description` must not be empty
- [X] T010 [P] Create `lib/application/use_cases/income/delete_income_use_case.dart` — delegates to repo; propagates `ArgumentError` when `toSavings=true` (UI will show snackbar)

### DI Registration

- [X] T011 Register `UpdateLendingUseCase`, `UpdateIncomeUseCase`, `DeleteIncomeUseCase` in `lib/core/di/injection.dart`

### Unit Tests

- [X] T012 [P] Create `test/unit/lending/update_lending_use_case_test.dart` — test: valid update passes; `totalAmount < collectedAmount` throws; no-op when all params null
- [X] T013 [P] Create `test/unit/income/update_income_use_case_test.dart` — test: empty description throws; valid description passes
- [X] T014 [P] Create `test/unit/income/delete_income_use_case_test.dart` — test: `toSavings=true` throws; `toSavings=false` deletes

**Checkpoint**: Lending and Income backend ready. All user story phases can now proceed.

---

## Phase 3: User Story 1+2 — Expense Edit & Delete (Priority: P1) 🎯 MVP

**Goal**: Users can edit and delete current-cycle expenses directly from the home page recent list.

**Independent Test**: Home page → long-press expense item → "تعديل" opens pre-filled EditExpensePage; "حذف" shows confirmation and removes expense + updates balance.

### US1: Edit Expense

- [X] T015 [US1] Add long-press `GestureDetector` wrapping each item in `lib/presentation/home/widgets/recent_expenses_list.dart` — shows `showModalBottomSheet` or `showMenu` with "تعديل" and "حذف" options
- [X] T016 [US1] Wire "تعديل" menu action in `recent_expenses_list.dart` to navigate to `EditExpensePage` with the selected `ExpenseEntity` (route already exists in `app_router.dart` — verify and use it)

### US2: Delete Expense

- [X] T017 [US2] Add `deleteExpense(int expenseId, int cycleId)` method to `lib/presentation/expense/cubits/expense_cubit.dart` — calls `DeleteExpenseUseCase`, emits `ExpenseSaved` on success or `ExpenseError` on failure
- [X] T018 [US2] Wire "حذف" menu action in `recent_expenses_list.dart` to show `ConfirmationDialog.show(context, title: 'حذف المصروف', message: 'هل تريد حذف هذا المصروف؟', confirmColor: AppColors.error)` then call `ExpenseCubit.deleteExpense`
- [X] T019 [US2] After successful delete, trigger dashboard refresh — call `DashboardCubit.loadDashboard()` or pop and push home to force reload
- [X] T020 [US2] Unit test: add `deleteExpense` test to `test/unit/expense/` (or existing expense test file) — mock `DeleteExpenseUseCase`, verify emits correct states on success and failure

**Checkpoint**: Expense edit and delete both work from home page recent list. Dashboard balance updates on delete.

---

## Phase 4: User Story 5+6 — Debt Edit & Delete (Priority: P2)

**Goal**: Users can edit debt details and delete debts (with payment cascade) from the debt detail page.

**Independent Test**: Debt detail page → edit button → AddDebtPage pre-filled with existing debt; save updates debt. Delete button → confirmation → debt + payments removed.

**Note**: `UpdateDebtUseCase`, `DeleteDebtUseCase`, `DebtCubit.updateDebt/deleteDebt` already exist. This phase is UI-only.

### US5: Edit Debt

- [X] T021 [US5] Add trailing edit `IconButton` (pencil icon) to AppBar in `lib/presentation/debt/pages/debt_detail_page.dart` — navigates to `AddDebtPage` passing `initialDebt: debt`
- [X] T022 [US5] Modify `lib/presentation/debt/pages/add_debt_page.dart` to accept optional `DebtEntity? initialDebt` parameter — in `initState`, pre-fill `TextEditingController`s with `initialDebt` values when non-null
- [X] T023 [US5] In `add_debt_page.dart` submit handler: if `initialDebt != null`, call `DebtCubit.updateDebt(id: initialDebt.id, ...)` instead of `createDebt`; update page title to "تعديل الدين" when in edit mode

### US6: Delete Debt (already in debt_detail_page via cubit — verify and expose if missing)

- [X] T024 [US6] Verify delete button exists in `lib/presentation/debt/pages/debt_detail_page.dart` — if missing, add a "حذف الدين" `ElevatedButton` (red/error color) at bottom of page calling `ConfirmationDialog.show` then `DebtCubit.deleteDebt(id)`; on success navigate back to debts list
- [X] T025 [US6] Verify confirmation dialog message mentions cascade: "سيتم حذف الدين وجميع المدفوعات المرتبطة به"

**Checkpoint**: Debt edit (pre-filled form) and delete (with confirmation) work from debt detail page.

---

## Phase 5: User Story 3+4 — Goal Edit & Delete (Priority: P2)

**Goal**: Users can edit goal name/target/notes and delete goals from the goal detail page.

**Independent Test**: Goal detail page → edit button → AddGoalPage pre-filled; save updates goal and recalculates progress. Delete button → confirmation → goal removed (contributions retained in savings).

**Note**: `UpdateGoalUseCase`, `DeleteGoalUseCase`, `GoalCubit.updateGoal/deleteGoal` already exist. This phase is UI-only.

### US3: Edit Goal

- [X] T026 [US3] Add trailing edit `IconButton` to AppBar in `lib/presentation/goal/pages/goal_detail_page.dart` — navigates to `AddGoalPage` passing `initialGoal: goal`
- [X] T027 [US3] Modify `lib/presentation/goal/pages/add_goal_page.dart` to accept optional `GoalEntity? initialGoal` — pre-fill name, targetAmount, notes in `initState`
- [X] T028 [US3] In `add_goal_page.dart` submit handler: if `initialGoal != null`, call `GoalCubit.updateGoal(id: initialGoal.id, ...)` instead of `createGoal`; update page title to "تعديل الهدف"

### US4: Delete Goal

- [X] T029 [US4] Add "حذف الهدف" delete button to `lib/presentation/goal/pages/goal_detail_page.dart` — show `ConfirmationDialog` with message "سيتم حذف الهدف. ستبقى مساهماتك محفوظة في المدخرات." then call `GoalCubit.deleteGoal(id)` and navigate back
- [X] T030 [US4] Verify goal progress bar and stats recalculate correctly after edit (spot-check via manual test in quickstart.md Scenario 6)

**Checkpoint**: Goal edit and delete work from goal detail page. Progress recalculates on target change.

---

## Phase 6: User Story 7+8 — Lending Edit & Delete (Priority: P3)

**Goal**: Users can edit lending details and delete lendings from the lending detail page.

**Independent Test**: Lending detail page → edit button → AddLendingPage pre-filled; save updates lending. Delete button → confirmation → lending + collections removed.

**Note**: Requires T002–T005 (Foundational lending update stack) to be complete first.

### US7: Edit Lending

- [X] T031 [US7] Add `updateLending({required int id, String? borrowerName, String? notes, int? totalAmount})` method to `lib/presentation/lending/cubits/lending_cubit.dart` — calls `UpdateLendingUseCase`, emits `LendingLoaded` on success or `LendingError` on failure
- [X] T032 [US7] Add trailing edit `IconButton` to AppBar in `lib/presentation/lending/pages/lending_detail_page.dart` — navigates to `AddLendingPage` passing `initialLending: lending`
- [X] T033 [US7] Modify `lib/presentation/lending/pages/add_lending_page.dart` to accept optional `LendingEntity? initialLending` — pre-fill `borrowerName`, `totalAmount`, `notes` in `initState`
- [X] T034 [US7] In `add_lending_page.dart` submit handler: if `initialLending != null`, call `LendingCubit.updateLending(id: initialLending.id, ...)` instead of `createLending`; update page title to "تعديل السلفة"; hide `PaymentSourceToggle` (source cannot change after creation)

### US8: Delete Lending

- [X] T035 [US8] Verify delete button in `lib/presentation/lending/pages/lending_detail_page.dart` is wired correctly — if existing delete button exists, verify it shows `ConfirmationDialog` with message "سيتم حذف السلفة وجميع الاسترجاعات المرتبطة بها" before calling `LendingCubit.deleteLending(id)`

**Checkpoint**: Lending edit and delete work from lending detail page. Total-amount validation prevents setting below already-collected amount.

---

## Phase 7: User Story 9+10 — Additional Income Edit & Delete (Priority: P3)

**Goal**: Users can edit income description and delete (non-savings) income entries from the income list.

**Independent Test**: Income list → long-press income item → "تعديل" opens edit dialog/form with pre-filled description; save updates. "حذف" shows confirmation and removes income (blocked if toSavings=true with error snackbar).

**Note**: Requires T006–T011 (Foundational income stack) to be complete first.

### US9: Edit Additional Income

- [X] T036 [US9] Add `updateIncome(int id, String description)` method to `lib/presentation/income/cubits/income_cubit.dart` — calls `UpdateIncomeUseCase`, emits success/error state
- [X] T037 [US9] Add edit/delete action UI to income list items in `lib/presentation/income/pages/add_income_page.dart` — long-press or trailing `IconButton` showing options "تعديل" and "حذف"
- [X] T038 [US9] Wire "تعديل" to show an inline edit dialog or bottom sheet with description `TextField` pre-filled; on save call `IncomeCubit.updateIncome(id, newDescription)`

### US10: Delete Additional Income

- [X] T039 [US10] Add `deleteIncome(int id)` method to `lib/presentation/income/cubits/income_cubit.dart` — calls `DeleteIncomeUseCase`; on `ArgumentError` emits error state with "لا يمكن حذف دخل محوّل للمدخرات. قم بسحب المبلغ يدوياً."
- [X] T040 [US10] Wire "حذف" action to show `ConfirmationDialog` then call `IncomeCubit.deleteIncome(id)`; show snackbar on error (toSavings=true block); refresh income list on success

**Checkpoint**: Income description edit and delete (with savings-block guard) work from income list.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Consistency, error message quality, regression verification.

- [X] T041 [P] Audit all confirmation dialog messages across entities (debts, lendings, goals, expenses, income) — ensure consistent Arabic phrasing and `confirmColor: AppColors.error`
- [X] T042 [P] Verify all edit AppBar buttons use consistent icon (`Icons.edit_outlined`) and all delete buttons use consistent icon (`Icons.delete_outline`) across all detail pages
- [ ] T043 Run quickstart.md Scenario 2 (expense delete with savings revert) and Scenario 4 (debt delete with payment cascade) — verify savings balance and cycle balance update correctly
- [ ] T044 Run quickstart.md Scenario 8 (income delete blocked when toSavings=true) — verify error snackbar appears and income unchanged
- [X] T045 [P] Verify edit mode pages show correct RTL layout — all pre-filled TextFields render correctly right-to-left in edit mode
- [X] T046 Verify `app_router.dart` has all required routes for pages used in edit mode navigation (add_debt_page, add_lending_page, add_goal_page in edit mode); add any missing route params

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — **blocks Phase 6 and Phase 7**
- **Phase 3 (Expense P1)**: Can start immediately after Phase 2 — no dependency on other stories
- **Phase 4 (Debt P2)**: Can start immediately (backend already exists) — independent of Phase 3
- **Phase 5 (Goal P2)**: Can start immediately (backend already exists) — independent of Phases 3, 4
- **Phase 6 (Lending P3)**: Depends on Phase 2 (T002–T005) completion
- **Phase 7 (Income P3)**: Depends on Phase 2 (T006–T011) completion
- **Phase 8 (Polish)**: Depends on all story phases complete

### Within Each Phase

- Foundational: DAO → Repo Interface → Repo Impl → Use Case → DI → Tests (sequential for lending stack; income stack T006–T010 can parallel with lending stack T002–T005)
- Story phases: Domain → Application → Infrastructure → Presentation (cubit → page)

### Parallel Opportunities

- T006, T007, T009, T010, T013, T014: parallel within Phase 2 (income stack + tests)
- T002–T005 (lending) run in parallel with T006–T010 (income) after T001
- Phase 3 (expenses) + Phase 4 (debts) + Phase 5 (goals) can all start in parallel after Phase 2
- Phase 6 (lending) + Phase 7 (income) can start in parallel once Phase 2 is done
- T041, T042, T045 in Phase 8 are independent and can run in parallel

---

## Parallel Example: Phase 2

```text
# Run in parallel once Phase 1 is done:
Task: T002 — Add updateLending to lending_repository.dart
Task: T006 — Add updateIncome/deleteIncome to income_repository.dart
Task: T007 — Add DAO methods to incomes_dao.dart

# After T002 complete:
Task: T003 — lendings_dao.dart update method
Task: T004 — lending_repository_impl.dart

# After T003+T004 complete:
Task: T005 — UpdateLendingUseCase

# After T006+T007 complete:
Task: T008 — income_repository_impl.dart

# After T008 complete:
Task: T009 — UpdateIncomeUseCase
Task: T010 — DeleteIncomeUseCase (parallel with T009)

# Tests can run in parallel once use cases exist:
Task: T012 — update_lending_use_case_test.dart
Task: T013 — update_income_use_case_test.dart
Task: T014 — delete_income_use_case_test.dart
```

---

## Implementation Strategy

### MVP First (Phase 3: Expense CRUD Only)

1. Complete Phase 2 (Foundational — needed for later, quick win now)
2. Complete Phase 3 (T015–T020: Expense Edit + Delete)
3. **STOP and VALIDATE**: Long-press expense on home → edit works → delete works → balance updates
4. Users immediately benefit from the most-used CRUD operation

### Incremental Delivery

1. Phase 2 → Foundation ready for all entities
2. Phase 3 (Expense P1) → MVP shipped ✓
3. Phase 4 (Debt P2) + Phase 5 (Goal P2) → UI-only, fast to complete
4. Phase 6 (Lending P3) → Needs full stack from Phase 2
5. Phase 7 (Income P3) → Needs full stack from Phase 2
6. Phase 8 (Polish) → Final quality pass

### Total Count

- **Total tasks**: 46 (T001–T046)
- **Phase 1**: 1 task
- **Phase 2 (Foundational)**: 13 tasks (T002–T014)
- **Phase 3 (Expense P1)**: 6 tasks (T015–T020)
- **Phase 4 (Debt P2)**: 5 tasks (T021–T025)
- **Phase 5 (Goal P2)**: 5 tasks (T026–T030)
- **Phase 6 (Lending P3)**: 5 tasks (T031–T035)
- **Phase 7 (Income P3)**: 5 tasks (T036–T040)
- **Phase 8 (Polish)**: 6 tasks (T041–T046)

---

## Notes

- **[P]** tasks = different files, no blocking dependencies between them
- No schema migration required (no new tables or columns)
- No new Flutter packages required
- `ConfirmationDialog.show()` is the single widget for all delete confirmations — do not create alternatives
- Edit mode pages use optional `initial*` constructor parameter pattern — null = create, non-null = edit
- Savings deposit delete is intentionally out of scope (see research.md Decision 1)
- After each Phase 3–7 checkpoint, run the corresponding quickstart.md scenario to validate independently
