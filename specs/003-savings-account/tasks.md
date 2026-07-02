# Tasks: Savings Account (المدخرات)

**Input**: Design documents from `specs/003-savings-account/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Included — user requested "test everything before finishing"

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Database & Code Generation)

**Purpose**: Create new table, modify existing tables, run code generation

- [X] T001 [P] Create savings history Drift table definition in `chahriyti/lib/infrastructure/database/tables/savings_history_table.dart` — columns: id (autoincrement PK), type (text), amount (int), description (text), relatedCycleId (int nullable), relatedExpenseId (int nullable), relatedDebtPaymentId (int nullable), createdAt (datetime default now)
- [X] T002 [P] Add `fromSavings` boolean column (default false) to expenses table in `chahriyti/lib/infrastructure/database/tables/expenses_table.dart`
- [X] T003 [P] Add `fromSavings` boolean column (default false) to debt payments table in `chahriyti/lib/infrastructure/database/tables/debt_payments_table.dart`
- [X] T004 Register `SavingsHistory` table in `chahriyti/lib/infrastructure/database/app_database.dart` — add to `@DriftDatabase(tables: [...])`, bump schemaVersion from 3 to 4, add migration in `onUpgrade` to create `savingsHistory` table and add `fromSavings` columns to `expenses` and `debtPayments`
- [X] T005 Run `dart run build_runner build --delete-conflicting-outputs` in `chahriyti/` to regenerate Drift database code

**Checkpoint**: Database compiles, migration v3→v4 defined, new table and columns exist.

---

## Phase 2: Foundational (Domain + Infrastructure)

**Purpose**: Create entity, repository interface, DAO, repository implementation, and DI wiring that ALL user stories depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T006 [P] Create `SavingsTransactionType` enum (deposit, withdrawal) and `SavingsHistoryEntity` Freezed entity in `chahriyti/lib/domain/entities/savings_history_entity.dart` — fields: id, type (SavingsTransactionType), amount, description, relatedCycleId?, relatedExpenseId?, relatedDebtPaymentId?, createdAt
- [X] T007 [P] Create `SavingsRepository` interface in `chahriyti/lib/domain/repositories/savings_repository.dart` — methods: getSavingsBalance() → int, getSavingsHistory() → List<SavingsHistoryEntity>, createDeposit(amount, description, cycleId) → SavingsHistoryEntity, createWithdrawal(amount, description, expenseId?, debtPaymentId?) → SavingsHistoryEntity, deleteWithdrawalByExpenseId(expenseId) → void, deleteWithdrawalByDebtPaymentId(debtPaymentId) → void, updateWithdrawalAmount(expenseId?, debtPaymentId?, newAmount) → void
- [X] T008 [P] Add `fromSavings` field (default false) to `ExpenseEntity` in `chahriyti/lib/domain/entities/expense_entity.dart`
- [X] T009 [P] Add `fromSavings` optional parameter to `addExpense()` method in `chahriyti/lib/domain/repositories/expense_repository.dart`
- [X] T010 [P] Add `fromSavings` optional parameter to `makePayment()` and `addPayment()` methods in `chahriyti/lib/domain/repositories/debt_repository.dart`
- [X] T011 Run `dart run build_runner build --delete-conflicting-outputs` in `chahriyti/` to regenerate Freezed entity code
- [X] T012 [P] Create `SavingsDao` in `chahriyti/lib/infrastructure/database/daos/savings_dao.dart` — methods: insertRecord(SavingsHistoryCompanion) → int, getAllRecords() → List<SavingsHistoryRow> (ordered by createdAt desc), getSavingsBalance() → int (SUM deposits - SUM withdrawals), deleteByRelatedExpenseId(id) → void, deleteByRelatedDebtPaymentId(id) → void, updateAmountByRelatedExpenseId(expenseId, newAmount) → void, updateAmountByRelatedDebtPaymentId(debtPaymentId, newAmount) → void
- [X] T013 [P] Update `ExpensesDao.getTotalExpenses(cycleId)` in `chahriyti/lib/infrastructure/database/daos/expenses_dao.dart` to add `WHERE fromSavings = false` filter so savings-funded expenses are excluded from cycle balance
- [X] T014 [P] Update `DebtsDao.getTotalPaymentsForCycle(cycleId)` in `chahriyti/lib/infrastructure/database/daos/debts_dao.dart` to add `WHERE fromSavings = false` filter so savings-funded payments are excluded from cycle balance
- [X] T015 [P] Create `SavingsRepositoryImpl` in `chahriyti/lib/infrastructure/repositories/savings_repository_impl.dart` — inject SavingsDao, implement all SavingsRepository methods, map SavingsHistoryRow → SavingsHistoryEntity
- [X] T016 [P] Update `ExpenseRepositoryImpl` in `chahriyti/lib/infrastructure/repositories/expense_repository_impl.dart` to pass `fromSavings` parameter through to DAO insert and include in entity mapping
- [X] T017 [P] Update `DebtRepositoryImpl` in `chahriyti/lib/infrastructure/repositories/debt_repository_impl.dart` to pass `fromSavings` parameter through to DAO insertPayment
- [X] T018 Create `GetSavingsBalanceUseCase` in `chahriyti/lib/application/use_cases/savings/get_savings_balance_use_case.dart` — calls savingsRepository.getSavingsBalance()
- [X] T019 Wire up all savings dependencies in `chahriyti/lib/core/di/injection.dart` — register SavingsDao, SavingsRepositoryImpl as SavingsRepository, GetSavingsBalanceUseCase. Add static late final fields following existing pattern.

**Checkpoint**: Foundation ready — savings balance query works, fromSavings filter applied to balance calculation, all dependencies wired.

---

## Phase 3: User Story 1 — Automatic Savings on Cycle End (Priority: P1) 🎯 MVP

**Goal**: When a salary cycle ends and a new one begins, unspent positive balance is automatically deposited into savings.

**Independent Test**: Close a cycle with positive balance → verify savings deposit record exists with correct amount. Close with zero/negative → verify no deposit.

### Tests for User Story 1

- [X] T020 [P] [US1] Unit test for `DepositCycleSavingsUseCase` in `chahriyti/test/unit/savings/deposit_cycle_savings_use_case_test.dart` — test cases: positive balance creates deposit, zero balance no deposit, negative balance no deposit, deposit description includes cycle info
- [X] T021 [P] [US1] Unit test for modified `ResetCycleUseCase` in `chahriyti/test/unit/savings/reset_cycle_with_savings_test.dart` — test: resetting cycle calls deposit logic with correct remaining balance

### Implementation for User Story 1

- [X] T022 [US1] Create `DepositCycleSavingsUseCase` in `chahriyti/lib/application/use_cases/savings/deposit_cycle_savings_use_case.dart` — accepts cycleId, calculates remaining balance (salary + income - expenses(not fromSavings) - debtPayments(not fromSavings)), if > 0 creates savings deposit record via savingsRepository.createDeposit(), inject: cycleRepository, expenseRepository, incomeRepository, debtRepository, savingsRepository
- [X] T023 [US1] Modify `ResetCycleUseCase` in `chahriyti/lib/application/use_cases/cycle/reset_cycle_use_case.dart` — inject DepositCycleSavingsUseCase, call it with currentCycle.id between closeCycle() and createCycle() calls
- [X] T024 [US1] Update `ResetCycleUseCase` constructor in `chahriyti/lib/core/di/injection.dart` to inject DepositCycleSavingsUseCase
- [X] T025 [US1] Verify unit tests pass for User Story 1

**Checkpoint**: Cycle reset creates savings deposit. US1 independently testable — reset cycle with positive balance, check savings_history table.

---

## Phase 4: User Story 2 — Pay Expense from Savings (Priority: P2)

**Goal**: Users can choose to pay an expense from savings via a toggle on the expense form. Toggle only appears when savings > 0.

**Independent Test**: Have savings > 0, add expense with "from savings" selected → savings decreases, cycle balance unchanged. Try with insufficient savings → blocked.

### Tests for User Story 2

- [X] T026 [P] [US2] Unit test for `WithdrawSavingsUseCase` in `chahriyti/test/unit/savings/withdraw_savings_use_case_test.dart` — test cases: successful withdrawal creates record, insufficient balance throws error, withdrawal description includes expense info
- [X] T027 [P] [US2] Unit test for modified `AddExpenseUseCase` in `chahriyti/test/unit/savings/add_expense_from_savings_test.dart` — test: fromSavings=true creates withdrawal + expense with flag, fromSavings=false works as before
- [X] T028 [P] [US2] Widget test for `PaymentSourceToggle` in `chahriyti/test/widget/savings/payment_source_toggle_test.dart` — test: renders two options with amounts, default is current balance, tap switches selection, hidden when savings is 0

### Implementation for User Story 2

- [X] T029 [US2] Create `WithdrawSavingsUseCase` in `chahriyti/lib/application/use_cases/savings/withdraw_savings_use_case.dart` — validates amount <= savings balance, creates withdrawal record via savingsRepository.createWithdrawal(), inject: savingsRepository
- [X] T030 [US2] Modify `AddExpenseUseCase` in `chahriyti/lib/application/use_cases/expense/add_expense_use_case.dart` — add optional `fromSavings` bool parameter, when true: call WithdrawSavingsUseCase after creating expense (pass expense.id as relatedExpenseId), pass fromSavings to repository
- [X] T031 [US2] Update `AddExpenseUseCase` constructor in `chahriyti/lib/core/di/injection.dart` to inject WithdrawSavingsUseCase and SavingsRepository
- [X] T032 [P] [US2] Create shared `PaymentSourceToggle` widget in `chahriyti/lib/presentation/shared/widgets/payment_source_toggle.dart` — RTL Arabic UI, two options: "الرصيد الحالي" (default) and "المدخرات", each shows available amount using MoneyText, uses SegmentedButton or custom toggle chips matching AppColors/AppTypography, onChanged callback returns bool (true = fromSavings), hidden (returns SizedBox.shrink) when savingsBalance <= 0
- [X] T033 [US2] Modify expense cubit in `chahriyti/lib/presentation/expense/cubits/expense_cubit.dart` — add fromSavings state tracking, pass fromSavings to AddExpenseUseCase.call(), load savings balance for toggle display
- [X] T034 [US2] Modify add expense page in `chahriyti/lib/presentation/expense/pages/add_expense_page.dart` — integrate PaymentSourceToggle in the form (in ExpenseFormInput state), pass savings balance and current balance to toggle, wire toggle's onChanged to cubit
- [X] T035 [US2] Verify unit and widget tests pass for User Story 2

**Checkpoint**: Expense form shows toggle when savings > 0, paying from savings creates withdrawal + excludes from balance. US2 independently testable.

---

## Phase 5: User Story 3 — Pay Debt from Savings (Priority: P3)

**Goal**: Users can choose to pay a debt from savings via the same toggle mechanism used for expenses.

**Independent Test**: Have savings > 0 and active debt, make payment from savings → savings decreases, debt balance decreases, cycle balance unchanged.

### Tests for User Story 3

- [X] T036 [P] [US3] Unit test for modified `AddDebtPaymentUseCase` in `chahriyti/test/unit/savings/add_debt_payment_from_savings_test.dart` — test: fromSavings=true creates withdrawal + payment with flag, fromSavings=false works as before, insufficient savings throws error

### Implementation for User Story 3

- [X] T037 [US3] Modify `AddDebtPaymentUseCase` in `chahriyti/lib/application/use_cases/debt/add_debt_payment_use_case.dart` — add optional `fromSavings` bool parameter, when true: validate savings balance >= amount via savingsRepository, call WithdrawSavingsUseCase after payment (pass debtPaymentId), pass fromSavings to repository
- [X] T038 [US3] Update `AddDebtPaymentUseCase` constructor in `chahriyti/lib/core/di/injection.dart` to inject WithdrawSavingsUseCase and SavingsRepository
- [X] T039 [US3] Modify debt cubit in `chahriyti/lib/presentation/debt/cubits/debt_cubit.dart` — add fromSavings parameter to addPayment method, load savings balance for toggle display
- [X] T040 [US3] Modify debt detail page payment dialog in `chahriyti/lib/presentation/debt/pages/debt_detail_page.dart` — integrate PaymentSourceToggle in the payment dialog/form, pass savings balance and current balance, wire toggle to cubit's addPayment fromSavings parameter
- [X] T041 [US3] Verify unit tests pass for User Story 3

**Checkpoint**: Debt payment dialog shows toggle when savings > 0, paying from savings works correctly. US3 independently testable.

---

## Phase 6: User Story 4 — View Savings History (Priority: P4)

**Goal**: Users can access Settings > المدخرات to see total savings and full transaction history (deposits in green, withdrawals in red).

**Independent Test**: Navigate to Settings > المدخرات, verify total displayed correctly, deposits green, withdrawals red, empty state when no history.

### Tests for User Story 4

- [X] T042 [P] [US4] Unit test for `GetSavingsHistoryUseCase` in `chahriyti/test/unit/savings/get_savings_history_use_case_test.dart` — test: returns records ordered by date desc, empty list when no history
- [X] T043 [P] [US4] Widget test for `SavingsPage` in `chahriyti/test/widget/savings/savings_page_test.dart` — test: shows total at top, deposits green with + sign, withdrawals red with - sign, empty state when no records

### Implementation for User Story 4

- [X] T044 [P] [US4] Create `GetSavingsHistoryUseCase` in `chahriyti/lib/application/use_cases/savings/get_savings_history_use_case.dart` — calls savingsRepository.getSavingsHistory(), returns List<SavingsHistoryEntity>
- [X] T045 [US4] Create savings state with Freezed in `chahriyti/lib/presentation/savings/cubits/savings_state.dart` — states: SavingsLoading, SavingsLoaded(balance: int, history: List<SavingsHistoryEntity>), SavingsError(message: String)
- [X] T046 [US4] Create savings cubit in `chahriyti/lib/presentation/savings/cubits/savings_cubit.dart` — inject GetSavingsBalanceUseCase and GetSavingsHistoryUseCase, loadSavings() fetches both and emits SavingsLoaded
- [X] T047 [P] [US4] Create `SavingsHistoryItem` widget in `chahriyti/lib/presentation/savings/widgets/savings_history_item.dart` — shows type icon, description, date, amount colored green (deposit) or red (withdrawal), uses AppColors.positive/negative, MoneyText for amount, consistent with existing list item styling
- [X] T048 [US4] Create `SavingsPage` in `chahriyti/lib/presentation/savings/pages/savings_page.dart` — AppBar with title "المدخرات", total balance card at top (similar to BalanceCard style), ListView.builder for history using SavingsHistoryItem, empty state with message "لا توجد عمليات ادخار بعد", BlocProvider creates SavingsCubit, loading shimmer state
- [X] T049 [US4] Add `/savings` route to `chahriyti/lib/presentation/shared/routing/app_router.dart` — GoRoute path '/savings' → SavingsPage
- [X] T050 [US4] Add savings entry to settings page in `chahriyti/lib/presentation/settings/pages/settings_page.dart` — add a "المدخرات" button/card in the Goals & Debts section (or new section), icon: Icons.savings_rounded, navigates to '/savings'
- [X] T051 [US4] Register GetSavingsHistoryUseCase in `chahriyti/lib/core/di/injection.dart`
- [X] T052 [US4] Run `dart run build_runner build --delete-conflicting-outputs` for savings state Freezed generation
- [X] T053 [US4] Verify unit and widget tests pass for User Story 4

**Checkpoint**: Full savings history screen accessible from Settings. US4 independently testable.

---

## Phase 7: Edit/Delete Reversal (Cross-Cutting)

**Purpose**: When a savings-funded expense or debt payment is deleted or edited, the corresponding savings withdrawal is automatically reversed or adjusted (FR-021, FR-022).

- [X] T054 [P] Unit test for expense delete reversal in `chahriyti/test/unit/savings/expense_delete_reversal_test.dart` — test: deleting fromSavings expense reverses withdrawal, deleting non-savings expense has no effect
- [X] T055 [P] Unit test for expense edit reversal in `chahriyti/test/unit/savings/expense_edit_reversal_test.dart` — test: editing fromSavings expense amount updates withdrawal amount
- [X] T056 Modify expense delete flow to reverse savings withdrawal — in the use case or repository layer that handles expense deletion, check if expense.fromSavings is true, if so call savingsRepository.deleteWithdrawalByExpenseId(expenseId). Update relevant file in `chahriyti/lib/application/use_cases/expense/` or `chahriyti/lib/infrastructure/repositories/expense_repository_impl.dart`
- [X] T057 Modify expense edit flow to adjust savings withdrawal — in the use case or repository layer that handles expense editing, check if expense.fromSavings is true, if so call savingsRepository.updateWithdrawalAmount(expenseId: expenseId, newAmount: newAmount). Update relevant file in `chahriyti/lib/application/use_cases/expense/` or `chahriyti/lib/infrastructure/repositories/expense_repository_impl.dart`
- [X] T058 Modify debt payment delete flow — if debt is deleted and had fromSavings payments, reverse those withdrawals via savingsRepository.deleteWithdrawalByDebtPaymentId(). Update `chahriyti/lib/infrastructure/repositories/debt_repository_impl.dart` or related use case
- [X] T059 Verify reversal tests pass

**Checkpoint**: Deleting/editing savings-funded transactions correctly restores savings balance.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Integration testing, cleanup, and final validation

- [X] T060 [P] Integration test for full savings flow in `chahriyti/test/integration/savings/savings_flow_test.dart` — end-to-end: create cycle → add expenses → reset cycle (deposit created) → verify savings balance → add expense from savings (withdrawal created) → verify balance updated → delete expense (withdrawal reversed) → verify savings restored
- [X] T061 [P] Unit test for `GetSavingsBalanceUseCase` in `chahriyti/test/unit/savings/get_savings_balance_use_case_test.dart` — test: correct sum of deposits minus withdrawals, zero when no history
- [X] T062 Verify all existing tests still pass after modifications (no regressions in expense/debt/cycle flows)
- [X] T063 Run full app manually — test cycle reset → savings deposit, add expense from savings, pay debt from savings, view savings history, delete savings-funded expense
- [X] T064 Run quickstart.md validation — verify all 9 checkpoints pass end-to-end

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 completion — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Phase 2 — foundational savings infrastructure
- **US2 (Phase 4)**: Depends on Phase 2 — can run in parallel with US1
- **US3 (Phase 5)**: Depends on Phase 2 + US2 (reuses WithdrawSavingsUseCase and PaymentSourceToggle from US2)
- **US4 (Phase 6)**: Depends on Phase 2 — can run in parallel with US1/US2
- **Edit/Delete Reversal (Phase 7)**: Depends on Phase 2 — can run in parallel with US stories, but best after US2/US3
- **Polish (Phase 8)**: Depends on all phases complete

### User Story Dependencies

```
Phase 1 (Setup)
    ↓
Phase 2 (Foundational)
    ↓
    ├── Phase 3 (US1) ─── independent
    ├── Phase 4 (US2) ─── independent
    │       ↓
    │   Phase 5 (US3) ─── depends on US2 (reuses toggle + withdraw use case)
    └── Phase 6 (US4) ─── independent
    ↓
Phase 7 (Edit/Delete) ─── after US2/US3
    ↓
Phase 8 (Polish)
```

### Within Each User Story

- Tests written first (TDD)
- Use cases before presentation
- Cubit before page
- Core implementation before integration
- Story verified before moving to next

### Parallel Opportunities

- **Phase 1**: T001, T002, T003 all in parallel (different table files)
- **Phase 2**: T006-T010 in parallel (different domain files), T012-T017 in parallel (different infra files)
- **Phase 3-6**: US1, US2, and US4 can run in parallel after Phase 2 (US3 waits for US2)
- **Within each story**: Test tasks marked [P] can run in parallel, implementation tasks marked [P] can run in parallel

---

## Parallel Example: Phase 2 Foundational

```bash
# Launch all domain layer tasks together:
Task: T006 "Create SavingsHistoryEntity in domain/entities/"
Task: T007 "Create SavingsRepository interface in domain/repositories/"
Task: T008 "Add fromSavings to ExpenseEntity"
Task: T009 "Add fromSavings to expense_repository.dart"
Task: T010 "Add fromSavings to debt_repository.dart"

# After build_runner (T011), launch all infra tasks together:
Task: T012 "Create SavingsDao"
Task: T013 "Update ExpensesDao filter"
Task: T014 "Update DebtsDao filter"
Task: T015 "Create SavingsRepositoryImpl"
Task: T016 "Update ExpenseRepositoryImpl"
Task: T017 "Update DebtRepositoryImpl"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (database changes)
2. Complete Phase 2: Foundational (entity, repo, DAO, DI)
3. Complete Phase 3: US1 — Automatic savings on cycle end
4. **STOP and VALIDATE**: Reset a cycle → verify savings deposit created
5. This alone delivers value: users accumulate savings automatically

### Incremental Delivery

1. Setup + Foundational → Database and architecture ready
2. Add US1 → Savings deposits accumulate (MVP!)
3. Add US2 → Users can pay expenses from savings
4. Add US3 → Users can pay debts from savings
5. Add US4 → Users can view full savings history
6. Add Edit/Delete reversal → Data integrity for all edge cases
7. Polish → Integration tests, regression check

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- Tests are written first (TDD) per constitution requirement
- Commit after each task or logical group
- Stop at any checkpoint to validate independently
- Total: 64 tasks across 8 phases
