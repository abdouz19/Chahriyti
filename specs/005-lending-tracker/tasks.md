# Tasks: Lending Tracker (السلف)

**Input**: Design documents from `specs/005-lending-tracker/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Database Schema)

**Purpose**: Create new Drift tables and schema migration for lending data

- [X] T001 [P] Create Lendings Drift table with columns (id, borrowerName, totalAmount, collectedAmount, isFullyCollected, fromSavings, cycleId, notes, createdAt) in chahriyti/lib/infrastructure/database/tables/lendings_table.dart
- [X] T002 [P] Create LendingCollections Drift table with columns (id, lendingId, amount, createdAt) in chahriyti/lib/infrastructure/database/tables/lending_collections_table.dart
- [X] T003 Add relatedLendingId nullable integer column to SavingsHistory Drift table in chahriyti/lib/infrastructure/database/tables/savings_history_table.dart
- [X] T004 Register Lendings and LendingCollections tables in @DriftDatabase annotation and add migration v5→v6 (create lendings, create lendingCollections, addColumn savingsHistory.relatedLendingId) in chahriyti/lib/infrastructure/database/app_database.dart

**Checkpoint**: Database schema ready for lending data

---

## Phase 2: Foundational (Domain + Infrastructure)

**Purpose**: Core domain entities, repository interfaces, DAO, and implementations that ALL user stories depend on

**CRITICAL**: No user story work can begin until this phase is complete

- [X] T005 [P] Create LendingEntity freezed class with fields (id, borrowerName, totalAmount, collectedAmount, isFullyCollected, fromSavings, cycleId, notes, createdAt) and computed getter remainingAmount in chahriyti/lib/domain/entities/lending_entity.dart
- [X] T006 [P] Create LendingCollectionEntity freezed class with fields (id, lendingId, amount, createdAt) in chahriyti/lib/domain/entities/lending_collection_entity.dart
- [X] T007 Add relatedLendingId nullable int field to SavingsHistoryEntity in chahriyti/lib/domain/entities/savings_history_entity.dart
- [X] T008 Run `dart run build_runner build --delete-conflicting-outputs` to generate freezed and json_serializable code for new and modified entities
- [X] T009 Create LendingRepository interface with methods (createLending, getLendingById, getActiveLendings, getCollectedLendings, deleteLending, addCollection, getCollectionsForLending, getTotalLendingsFromBalanceForCycle, getTotalOutstandingLendingAmount) in chahriyti/lib/domain/repositories/lending_repository.dart
- [X] T010 Modify SavingsRepository interface: add int? lendingId param to createWithdrawal, add deleteWithdrawalByLendingId(int lendingId) method in chahriyti/lib/domain/repositories/savings_repository.dart
- [X] T011 Create LendingsDao with @DriftAccessor for Lendings and LendingCollections tables, implementing all query methods (insert, getById, getActive, getCollected, delete, insertCollection, getCollections, getTotalFromBalanceForCycle, getTotalOutstanding) in chahriyti/lib/infrastructure/database/daos/lendings_dao.dart
- [X] T012 Create LendingRepositoryImpl implementing LendingRepository, taking LendingsDao as dependency, with _toEntity and _toCollectionEntity mapping methods in chahriyti/lib/infrastructure/repositories/lending_repository_impl.dart
- [X] T013 Modify SavingsRepositoryImpl: handle lendingId in createWithdrawal, implement deleteWithdrawalByLendingId in chahriyti/lib/infrastructure/repositories/savings_repository_impl.dart
- [X] T014 Modify WithdrawSavingsUseCase.call() to accept optional int? lendingId parameter, pass it to repository.createWithdrawal in chahriyti/lib/application/use_cases/savings/withdraw_savings_use_case.dart
- [X] T015 Register LendingsDao and LendingRepository (LendingRepositoryImpl) in Injection.init() in chahriyti/lib/core/di/injection.dart

**Checkpoint**: Foundation ready — domain entities, repository, DAO all wired up

---

## Phase 3: User Story 1 — Create a New Lending (Priority: P1) MVP

**Goal**: Users can create a lending by specifying borrower name, amount, funding source (balance/savings), and optional notes. The appropriate source is deducted.

**Independent Test**: Create a lending of 10,000 DZD from balance to "أحمد". The lending appears in the list and the balance is reduced.

### Implementation for User Story 1

- [X] T016 [US1] Create CreateLendingUseCase with validation (amount > 0, balance/savings sufficient), lending creation via LendingRepository, and optional savings withdrawal via WithdrawSavingsUseCase in chahriyti/lib/application/use_cases/lending/create_lending_use_case.dart
- [X] T017 [US1] Register CreateLendingUseCase in Injection.init() in chahriyti/lib/core/di/injection.dart
- [X] T018 [US1] Create LendingState freezed sealed class with states (initial, loading, lendingsLoaded, lendingLoaded, lendingCreated, lendingDeleted, collectionAdded, error) in chahriyti/lib/presentation/lending/cubits/lending_state.dart
- [X] T019 [US1] Create LendingCubit with createLending and getSavingsBalance methods, taking CreateLendingUseCase and GetSavingsBalanceUseCase as dependencies in chahriyti/lib/presentation/lending/cubits/lending_cubit.dart
- [X] T020 [US1] Run `dart run build_runner build --delete-conflicting-outputs` to generate lending_state.freezed.dart
- [X] T021 [US1] Create AddLendingPage with form fields (borrowerName TextField, amount TextField with digitsOnly filter, notes TextField, PaymentSourceToggle), BlocProvider for LendingCubit, and BlocListener for success/error handling in chahriyti/lib/presentation/lending/pages/add_lending_page.dart
- [X] T022 [US1] Add GoRoute for /lending/add in app_router.dart, accepting cycleId via state.extra in chahriyti/lib/presentation/shared/routing/app_router.dart
- [ ] T023 [US1] Write unit test for CreateLendingUseCase covering: valid lending from balance, valid lending from savings, zero amount rejected, insufficient balance rejected, insufficient savings rejected in chahriyti/test/unit/lending/create_lending_use_case_test.dart

**Checkpoint**: Users can create lendings from both balance and savings with full validation

---

## Phase 4: User Story 2 — View Lending List and Details (Priority: P2)

**Goal**: Users can see all active lendings in a list page with active/collected tabs, and tap to see full details with collection history.

**Independent Test**: User has 3 lendings. They navigate to the lending list, see all 3 with borrower names and amounts. Tapping one shows the detail page.

### Implementation for User Story 2

- [X] T024 [US2] Create GetLendingsUseCase with methods getActiveLendings(), getCollectedLendings(), getLendingById(id), getCollectionsForLending(lendingId) in chahriyti/lib/application/use_cases/lending/get_lendings_use_case.dart
- [X] T025 [US2] Register GetLendingsUseCase in Injection.init() in chahriyti/lib/core/di/injection.dart
- [X] T026 [US2] Update LendingCubit: add loadLendings(), loadCollectedLendings(), loadLendingById(id), loadCollections(lendingId) methods in chahriyti/lib/presentation/lending/cubits/lending_cubit.dart
- [X] T027 [P] [US2] Create LendingCard widget showing borrowerName, totalAmount, collectedAmount, remainingAmount, progress bar (collectedAmount/totalAmount), and notes snippet in chahriyti/lib/presentation/lending/widgets/lending_card.dart
- [X] T028 [US2] Create LendingsListPage with two tabs ("نشطة" active / "تم التحصيل" collected), CustomScrollView with SliverList of LendingCard widgets, empty state message "لا توجد سلف حالياً", and FAB to navigate to /lending/add in chahriyti/lib/presentation/lending/pages/lendings_list_page.dart
- [X] T029 [US2] Create LendingDetailPage showing borrowerName, totalAmount, collectedAmount, remainingAmount, progress bar, createdAt date, notes, and collection history list in chahriyti/lib/presentation/lending/pages/lending_detail_page.dart
- [X] T030 [US2] Add GoRoute for /lendings (LendingsListPage) and /lending/:id (LendingDetailPage extracting id from pathParameters) in chahriyti/lib/presentation/shared/routing/app_router.dart

**Checkpoint**: Users can view all lendings in a filtered list and see detailed information for each

---

## Phase 5: User Story 3 — Collect a Lending Payment (Priority: P3)

**Goal**: Users can record partial or full collections on a lending. When fully collected, the lending is marked as complete.

**Independent Test**: User has a lending of 20,000 DZD. They record 8,000, see 12,000 remaining. They record 12,000 more, lending is marked fully collected.

### Implementation for User Story 3

- [X] T031 [US3] Create AddLendingCollectionUseCase with validation (amount > 0, amount <= remainingAmount), collection creation via LendingRepository.addCollection, and auto-marking isFullyCollected when collectedAmount equals totalAmount in chahriyti/lib/application/use_cases/lending/add_lending_collection_use_case.dart
- [X] T032 [US3] Register AddLendingCollectionUseCase in Injection.init() in chahriyti/lib/core/di/injection.dart
- [X] T033 [US3] Update LendingCubit: add addCollection(lendingId, amount) method that calls AddLendingCollectionUseCase and reloads lending detail on success in chahriyti/lib/presentation/lending/cubits/lending_cubit.dart
- [X] T034 [US3] Add collection recording dialog in LendingDetailPage: "تسجيل تحصيل" button, amount input dialog with validation (max = remainingAmount), success/error snackbar feedback in chahriyti/lib/presentation/lending/pages/lending_detail_page.dart

**Checkpoint**: Users can record partial and full collections with proper validation and auto-completion

---

## Phase 6: User Story 4 — Dashboard Visibility (Priority: P4)

**Goal**: Dashboard spending card shows "سلف" breakdown line with total outstanding lending amounts. Dashboard has a lending summary section for quick access.

**Independent Test**: User has lendings totaling 30,000 DZD. Dashboard spending card shows "سلف" = 30,000 alongside expenses and debts.

### Implementation for User Story 4

- [X] T035 [US4] Modify GetDashboardDataUseCase: inject LendingRepository, add totalLendingsFromBalance to balance formula (currentBalance = totalIn - totalExpenses - totalDebtPayments - totalLendingsFromBalance), add totalOutstandingLendings to DashboardData in chahriyti/lib/application/use_cases/dashboard/get_dashboard_data_use_case.dart
- [X] T036 [US4] Modify DashboardCubit: fetch active lendings list alongside debts and goals, pass to DashboardLoaded state in chahriyti/lib/presentation/home/cubits/dashboard_cubit.dart
- [X] T037 [US4] Modify ExpensesCard: add lendingAmount int parameter, include in _total calculation, add "سلف" _BreakdownRow when lendingAmount > 0 in chahriyti/lib/presentation/home/widgets/expenses_card.dart
- [X] T038 [US4] Add lending summary section in HomePage (below debts section): show total outstanding amount, active lending count, tap navigates to /lendings in chahriyti/lib/presentation/home/pages/home_page.dart
- [X] T039 [US4] Modify AddExpensePage._getCurrentBalance() to subtract totalLendingsFromBalance from available balance in chahriyti/lib/presentation/expense/pages/add_expense_page.dart
- [X] T040 [US4] Modify DebtDetailPage._getCurrentBalance() to subtract totalLendingsFromBalance from available balance in chahriyti/lib/presentation/debt/pages/debt_detail_page.dart
- [X] T041 [US4] Modify DepositCycleSavingsUseCase balance formula to subtract totalLendingsFromBalance in chahriyti/lib/application/use_cases/savings/deposit_cycle_savings_use_case.dart
- [ ] T042 [US4] Write unit test for balance formula with lending: verify balance = totalIn - expenses - debts - lendings, zero lendings preserves original formula, lendings from savings don't affect balance in chahriyti/test/unit/lending/balance_formula_with_lending_test.dart

**Checkpoint**: Dashboard correctly reflects lending amounts in spending breakdown and balance formula is consistent across all calculation points

---

## Phase 7: User Story 5 — Delete a Lending (Priority: P5)

**Goal**: Users can delete a lending with confirmation. Deletion does NOT reverse balance/savings deductions.

**Independent Test**: User deletes a lending. It disappears from the list. Balance is not restored.

### Implementation for User Story 5

- [X] T043 [US5] Create DeleteLendingUseCase that deletes the lending record and its collections via LendingRepository.deleteLending in chahriyti/lib/application/use_cases/lending/delete_lending_use_case.dart
- [X] T044 [US5] Register DeleteLendingUseCase in Injection.init() in chahriyti/lib/core/di/injection.dart
- [X] T045 [US5] Update LendingCubit: add deleteLending(id) method that calls DeleteLendingUseCase and emits lendingDeleted state in chahriyti/lib/presentation/lending/cubits/lending_cubit.dart
- [X] T046 [US5] Add delete action in LendingDetailPage: delete icon button in AppBar, confirmation dialog ("هل تريد حذف هذه السلفة؟"), navigate back on success in chahriyti/lib/presentation/lending/pages/lending_detail_page.dart

**Checkpoint**: Users can delete lendings with confirmation, without reversing financial deductions

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final validation and cleanup

- [X] T047 Run `dart analyze` on the project and fix all warnings/errors
- [X] T048 Run `flutter test` and verify all tests pass (existing + new)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3-7)**: All depend on Foundational phase completion
  - US1 (Phase 3): No dependencies on other stories — **MVP**
  - US2 (Phase 4): No dependencies on other stories (but benefits from US1 for adding lendings)
  - US3 (Phase 5): Depends on US2 (collection recording lives in LendingDetailPage)
  - US4 (Phase 6): No dependencies on other stories (dashboard queries are independent)
  - US5 (Phase 7): Depends on US2 (delete action lives in LendingDetailPage)
- **Polish (Phase 8)**: Depends on all user stories being complete

### Within Each User Story

- Use cases before cubit methods
- Cubit before pages
- Pages before routes
- DI registration before cubit construction

### Parallel Opportunities

- T001 + T002: Both Drift tables can be created in parallel (different files)
- T005 + T006: Both entities can be created in parallel (different files)
- T027: LendingCard widget can be created in parallel with other US2 tasks
- US1 + US4: Can run in parallel (US1 = creation flow, US4 = dashboard integration)

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (database schema)
2. Complete Phase 2: Foundational (entities, repository, DAO, DI)
3. Complete Phase 3: User Story 1 (create lending)
4. **STOP and VALIDATE**: Test lending creation from both balance and savings
5. Continue to remaining stories

### Incremental Delivery

1. Setup + Foundational → Infrastructure ready
2. Add US1 → Create lendings (MVP!)
3. Add US2 → View and browse lendings
4. Add US3 → Record collections
5. Add US4 → Dashboard integration + balance formula
6. Add US5 → Delete lendings
7. Polish → Final validation

---

## Notes

- All amounts are int (centimes) — use .toDZDString() extension for display
- All UI text in Arabic RTL — use AppColors and AppTypography
- PaymentSourceToggle widget reused from existing expense/debt forms
- LendingCubit is created in US1 and incrementally updated in US2-US5
- injection.dart is modified in each story phase to register new use cases
- Existing balance calculation points (AddExpensePage, DebtDetailPage, DepositCycleSavingsUseCase) must be updated in US4
