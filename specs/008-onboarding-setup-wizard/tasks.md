# Tasks: Onboarding Financial Setup Wizard

**Input**: Design documents from `specs/008-onboarding-setup-wizard/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Included — constitution mandates testing (Principle II).

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup

**Purpose**: Database migration and domain layer changes shared across all wizard steps

- [x] T001 Add `initialBalance` (double?), `hasCompletedFinancialSetup` (bool, default false), `financialSetupStep` (int?) columns to users table via Drift migration in `chahriyti/lib/infrastructure/database/app_database.dart`
- [x] T002 Update `UserEntity` freezed class with 3 new fields: `initialBalance`, `hasCompletedFinancialSetup`, `financialSetupStep` in `chahriyti/lib/domain/entities/user_entity.dart`
- [x] T003 Update users table Drift schema and mapper to include new columns in `chahriyti/lib/infrastructure/database/daos/users_dao.dart`
- [x] T004 Add `updateInitialBalance()`, `updateFinancialSetupStep()`, `completeFinancialSetup()` to `UserRepository` interface in `chahriyti/lib/domain/repositories/user_repository.dart`
- [x] T005 Implement new `UserRepository` methods in `chahriyti/lib/infrastructure/repositories/user_repository_impl.dart`
- [x] T006 Run `dart run build_runner build` to regenerate Freezed/Drift code and verify migration compiles

**Checkpoint**: Database and domain layer ready. All subsequent phases can build on this.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Use cases and cubit infrastructure that ALL wizard steps depend on

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T007 [P] Create `GetFinancialSetupStepUseCase` in `chahriyti/lib/application/use_cases/financial_setup/get_financial_setup_step_use_case.dart` — reads `financialSetupStep` from user to determine resume point
- [x] T008 [P] Create `CompleteFinancialSetupUseCase` in `chahriyti/lib/application/use_cases/financial_setup/complete_financial_setup_use_case.dart` — sets `hasCompletedFinancialSetup=true`, clears `financialSetupStep`
- [x] T009 [P] Create `GetSetupSummaryUseCase` in `chahriyti/lib/application/use_cases/financial_setup/get_setup_summary_use_case.dart` — aggregates balance, savings, debts, lendings for summary screen
- [x] T010 Create sealed state classes in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_state.dart` — FinancialSetupWelcome, FinancialSetupBalance, FinancialSetupSavings, FinancialSetupDebts, FinancialSetupLendings, FinancialSetupSummary, FinancialSetupCompleted, FinancialSetupError, FinancialSetupLoading
- [x] T011 Create `FinancialSetupCubit` skeleton in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart` — constructor with DI, `start()` method that reads step and emits correct initial state for resume
- [x] T012 Create `FinancialSetupPage` scaffold in `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart` — BlocProvider + BlocBuilder that switches on state type, renders placeholder per step
- [x] T013 Create `SetupProgressBar` widget in `chahriyti/lib/presentation/financial_setup/widgets/setup_progress_bar.dart` — takes currentStep/totalSteps, renders visual progress bar
- [x] T014 Create `AmountInputField` widget in `chahriyti/lib/presentation/financial_setup/widgets/amount_input_field.dart` — currency-formatted number input with validation, DZD symbol, thousand separators
- [x] T015 Register `/financial-setup` route in GoRouter and add redirect guard: if user exists + activated + `!hasCompletedFinancialSetup` → redirect to `/financial-setup` in `chahriyti/lib/presentation/shared/routing/app_router.dart`
- [x] T016 Register all new use cases and `FinancialSetupCubit` in DI container in `chahriyti/lib/core/di/injection_container.dart`

### Tests for Foundational Phase

- [x] T017 [P] Unit test `GetFinancialSetupStepUseCase` in `chahriyti/test/unit/application/financial_setup/get_financial_setup_step_use_case_test.dart`
- [x] T018 [P] Unit test `CompleteFinancialSetupUseCase` in `chahriyti/test/unit/application/financial_setup/complete_financial_setup_use_case_test.dart`
- [x] T019 [P] Unit test `GetSetupSummaryUseCase` in `chahriyti/test/unit/application/financial_setup/get_setup_summary_use_case_test.dart`
- [x] T020 [P] Widget test `SetupProgressBar` renders correctly for all step counts in `chahriyti/test/widget/presentation/financial_setup/setup_progress_bar_test.dart`

**Checkpoint**: Foundation ready — cubit, states, page scaffold, router guard, shared widgets all in place. User story implementation can begin.

---

## Phase 3: User Story 1 — Enter Current Balance (Priority: P1) 🎯 MVP

**Goal**: First-time user sees welcome screen, taps Start, enters balance amount, saves it.

**Independent Test**: Complete balance step alone → verify amount saved to UserEntity.initialBalance and financialSetupStep advances.

### Implementation for User Story 1

- [x] T021 [P] [US1] Create `SetInitialBalanceUseCase` in `chahriyti/lib/application/use_cases/financial_setup/set_initial_balance_use_case.dart` — saves balance to user, updates `financialSetupStep` to 2
- [x] T022 [P] [US1] Create `WelcomeStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/welcome_step_widget.dart` — title "Set Up Your Finances", subtitle "Takes 2 minutes. You can edit anytime.", Start button
- [x] T023 [P] [US1] Create `BalanceStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/balance_step_widget.dart` — progress bar (2/6), prompt "How much money do you have right now?", help text, AmountInputField, Next button
- [x] T024 [US1] Wire `start()` and `setBalance()` methods in `FinancialSetupCubit` — start emits Welcome→Balance, setBalance validates ≥0, saves via use case, emits Savings state in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T025 [US1] Connect WelcomeStepWidget and BalanceStepWidget in BlocBuilder inside `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart`

### Tests for User Story 1

- [x] T026 [P] [US1] Unit test `SetInitialBalanceUseCase` — saves balance, advances step in `chahriyti/test/unit/application/financial_setup/set_initial_balance_use_case_test.dart`
- [x] T027 [P] [US1] Widget test `WelcomeStepWidget` — renders title/subtitle, Start button triggers callback in `chahriyti/test/widget/presentation/financial_setup/welcome_step_widget_test.dart`
- [x] T028 [P] [US1] Widget test `BalanceStepWidget` — renders prompt/help, validates input ≥0, Next triggers callback in `chahriyti/test/widget/presentation/financial_setup/balance_step_widget_test.dart`

**Checkpoint**: User Story 1 complete — user can see welcome, enter balance, data persists. MVP functional.

---

## Phase 4: User Story 2 — Enter Savings (Priority: P2)

**Goal**: User enters savings amount or skips. Savings deposit created via existing infrastructure.

**Independent Test**: Enter savings amount → verify savings history entry created with correct amount.

### Implementation for User Story 2

- [x] T029 [P] [US2] Create `SetInitialSavingsUseCase` in `chahriyti/lib/application/use_cases/financial_setup/set_initial_savings_use_case.dart` — creates savings history deposit entry via existing `SavingsRepository`, updates `financialSetupStep` to 3
- [x] T030 [P] [US2] Create `SavingsStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/savings_step_widget.dart` — progress bar (3/6), prompt "Money saved for future?", help text, AmountInputField, Skip | Next buttons
- [x] T031 [US2] Wire `setSavings()` and `skipSavings()` methods in `FinancialSetupCubit` — setSavings validates ≥0, saves via use case; skipSavings records 0 and advances; both emit Debts state in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T032 [US2] Connect SavingsStepWidget in BlocBuilder inside `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart`

### Tests for User Story 2

- [x] T033 [P] [US2] Unit test `SetInitialSavingsUseCase` — creates deposit, advances step; skip path creates no entry in `chahriyti/test/unit/application/financial_setup/set_initial_savings_use_case_test.dart`
- [x] T034 [P] [US2] Widget test `SavingsStepWidget` — renders prompt, Skip works, Next validates in `chahriyti/test/widget/presentation/financial_setup/savings_step_widget_test.dart`

**Checkpoint**: User Stories 1 + 2 complete — balance and savings captured.

---

## Phase 5: User Story 3 — Add Debts (Priority: P2)

**Goal**: User adds multiple debts (creditor name + amount each), edits/deletes entries, or skips entirely.

**Independent Test**: Add 2 debts → verify both appear in debt list with correct creditor names and amounts.

### Implementation for User Story 3

- [x] T035 [P] [US3] Create `AddInitialDebtUseCase` in `chahriyti/lib/application/use_cases/financial_setup/add_initial_debt_use_case.dart` — creates DebtEntity via existing `DebtRepository` with paidAmount=0
- [x] T036 [P] [US3] Create `EditInitialDebtUseCase` in `chahriyti/lib/application/use_cases/financial_setup/edit_initial_debt_use_case.dart` — updates debt name/amount
- [x] T037 [P] [US3] Create `DeleteInitialDebtUseCase` in `chahriyti/lib/application/use_cases/financial_setup/delete_initial_debt_use_case.dart` — removes debt entry
- [x] T038 [P] [US3] Create `DebtFormBottomSheet` in `chahriyti/lib/presentation/financial_setup/widgets/debt_form_bottom_sheet.dart` — modal with name (text) + amount (number) fields, Save button, validation (non-empty name, amount > 0)
- [x] T039 [US3] Create `DebtsStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/debts_step_widget.dart` — progress bar (4/6), prompt "Who do you owe money to?", empty state with "Add first debt", card list of debts (tap to edit via DebtFormBottomSheet), "Add another" button, Skip | Next buttons
- [x] T040 [US3] Wire `addDebt()`, `editDebt()`, `deleteDebt()`, `nextFromDebts()` methods in `FinancialSetupCubit` — manage debt list, update step, emit updated Debts state or Lendings state in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T041 [US3] Connect DebtsStepWidget in BlocBuilder inside `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart`

### Tests for User Story 3

- [x] T042 [P] [US3] Unit test `AddInitialDebtUseCase` — creates debt with correct fields in `chahriyti/test/unit/application/financial_setup/add_initial_debt_use_case_test.dart`
- [x] T043 [P] [US3] Widget test `DebtsStepWidget` — empty state, add debt, card list, edit tap, delete, skip in `chahriyti/test/widget/presentation/financial_setup/debts_step_widget_test.dart`
- [x] T044 [P] [US3] Widget test `DebtFormBottomSheet` — validates non-empty name, amount > 0, save callback in `chahriyti/test/widget/presentation/financial_setup/debt_form_bottom_sheet_test.dart`

**Checkpoint**: User Stories 1 + 2 + 3 complete — balance, savings, and debts captured.

---

## Phase 6: User Story 4 — Add Lendings (Priority: P3)

**Goal**: User adds money lent to others (borrower name + amount each), edits/deletes entries, or skips.

**Independent Test**: Add 1 lending → verify it appears in lending list with correct borrower name and amount.

### Implementation for User Story 4

- [x] T045 [P] [US4] Create `AddInitialLendingUseCase` in `chahriyti/lib/application/use_cases/financial_setup/add_initial_lending_use_case.dart` — creates LendingEntity via existing `LendingRepository` with collectedAmount=0
- [x] T046 [P] [US4] Create `EditInitialLendingUseCase` in `chahriyti/lib/application/use_cases/financial_setup/edit_initial_lending_use_case.dart` — updates lending name/amount
- [x] T047 [P] [US4] Create `DeleteInitialLendingUseCase` in `chahriyti/lib/application/use_cases/financial_setup/delete_initial_lending_use_case.dart` — removes lending entry
- [x] T048 [P] [US4] Create `LendingFormBottomSheet` in `chahriyti/lib/presentation/financial_setup/widgets/lending_form_bottom_sheet.dart` — modal with name (text) + amount (number) fields, Save button, validation (non-empty name, amount > 0)
- [x] T049 [US4] Create `LendingsStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/lendings_step_widget.dart` — progress bar (5/6), prompt "Who owes you money?", empty state with "Add" button, card list, "Add another" button, Skip | Done buttons
- [x] T050 [US4] Wire `addLending()`, `editLending()`, `deleteLending()`, `nextFromLendings()` methods in `FinancialSetupCubit` in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T051 [US4] Connect LendingsStepWidget in BlocBuilder inside `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart`

### Tests for User Story 4

- [x] T052 [P] [US4] Unit test `AddInitialLendingUseCase` in `chahriyti/test/unit/application/financial_setup/add_initial_lending_use_case_test.dart`
- [x] T053 [P] [US4] Widget test `LendingsStepWidget` — empty state, add, card list, edit, delete, skip in `chahriyti/test/widget/presentation/financial_setup/lendings_step_widget_test.dart`

**Checkpoint**: All data collection steps complete — balance, savings, debts, lendings.

---

## Phase 7: User Story 5 — Review and Confirm Summary (Priority: P2)

**Goal**: User sees summary of all entered data, can edit any section, confirms to finalize setup.

**Independent Test**: Complete all steps → summary shows all values → tap Confirm → user redirected to salary onboarding, `hasCompletedFinancialSetup` = true.

### Implementation for User Story 5

- [x] T054 [P] [US5] Create `SummaryStepWidget` in `chahriyti/lib/presentation/financial_setup/widgets/summary_step_widget.dart` — progress bar (6/6), balance card, savings card, debts list card, lendings list card, each with "Edit" button, "Confirm & Start" button
- [x] T055 [US5] Wire `editFromSummary(int step)` and `confirm()` methods in `FinancialSetupCubit` — editFromSummary jumps to specific step with current data; confirm calls CompleteFinancialSetupUseCase, emits Completed in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T056 [US5] Connect SummaryStepWidget in BlocBuilder and handle FinancialSetupCompleted state (redirect to salary onboarding) in `chahriyti/lib/presentation/financial_setup/pages/financial_setup_page.dart`

### Tests for User Story 5

- [x] T057 [P] [US5] Widget test `SummaryStepWidget` — displays all data categories, edit buttons trigger callbacks, confirm triggers callback in `chahriyti/test/widget/presentation/financial_setup/summary_step_widget_test.dart`

**Checkpoint**: Full wizard flow complete with confirmation.

---

## Phase 8: User Story 6 — Back Navigation (Priority: P3)

**Goal**: User can navigate back to any previous step with data preserved.

**Independent Test**: Enter data in step 3, go back to step 2, return to step 3 → data still there.

### Implementation for User Story 6

- [x] T058 [US6] Implement `goBack()` method in `FinancialSetupCubit` — maintains internal data cache, emits previous step's state with preserved values in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T059 [US6] Add back arrow button to all step widgets (BalanceStep through SummaryStep) that calls `cubit.goBack()` — update each widget in `chahriyti/lib/presentation/financial_setup/widgets/`

### Tests for User Story 6

- [x] T060 [US6] Integration test: full wizard back navigation — enter balance, advance, go back, verify balance preserved; enter debts, go back to savings, return, verify debts preserved in `chahriyti/test/integration/financial_setup_flow_test.dart`

**Checkpoint**: All 6 user stories complete. Full wizard functional with navigation.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Edge cases, performance, final validation

- [x] T061 [P] Handle app restart resume: verify `FinancialSetupCubit.start()` reads `financialSetupStep` and loads correct data for that step (debts/lendings from DB) — validate in `chahriyti/lib/presentation/financial_setup/cubits/financial_setup_cubit.dart`
- [x] T062 [P] Add thousand separator formatting to AmountInputField and all amount displays across wizard widgets in `chahriyti/lib/presentation/financial_setup/widgets/amount_input_field.dart`
- [x] T063 [P] Ensure all wizard widgets use `const` constructors where possible, verify no heavy computation in `build()` methods — review all files in `chahriyti/lib/presentation/financial_setup/widgets/`
- [x] T064 Integration test: full wizard end-to-end flow — welcome → balance → savings → add 2 debts → add 1 lending → summary → edit balance → re-confirm → verify all data persisted correctly in `chahriyti/test/integration/financial_setup_flow_test.dart`
- [x] T065 Integration test: wizard resume after app kill — complete through debts step, simulate restart, verify wizard resumes at lendings step with previous data intact in `chahriyti/test/integration/financial_setup_flow_test.dart`
- [x] T066 Verify router guard: completed wizard user goes to home, not wizard; new user goes to wizard, not home — test redirect logic in `chahriyti/test/widget/presentation/shared/routing/app_router_test.dart`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — BLOCKS all user stories
- **Phases 3-8 (User Stories)**: All depend on Phase 2 completion
  - US1 (Balance): Independent — can start after Phase 2
  - US2 (Savings): Independent — can start after Phase 2
  - US3 (Debts): Independent — can start after Phase 2
  - US4 (Lendings): Independent — can start after Phase 2
  - US5 (Summary): Depends on US1-US4 (needs all step widgets to exist)
  - US6 (Back Nav): Depends on US1-US4 (needs all steps for navigation)
- **Phase 9 (Polish)**: Depends on all user stories complete

### User Story Dependencies

```
Phase 1 (Setup) → Phase 2 (Foundational)
                        ↓
        ┌───────┬───────┼───────┐
        ↓       ↓       ↓       ↓
      US1     US2     US3     US4     ← Can run in parallel
    (Balance)(Savings)(Debts)(Lendings)
        └───────┴───────┼───────┘
                        ↓
                ┌───────┼───────┐
                ↓               ↓
              US5             US6
           (Summary)       (Back Nav)
                └───────┼───────┘
                        ↓
                   Phase 9 (Polish)
```

### Within Each User Story

- Use cases before cubit wiring
- Cubit wiring before page connection
- Widgets can be built in parallel with use cases (different files)
- Tests can run in parallel with each other

### Parallel Opportunities

- T007, T008, T009 (foundational use cases) — all parallel
- T017, T018, T019, T020 (foundational tests) — all parallel
- T021, T022, T023 (US1 use case + widgets) — all parallel
- T026, T027, T028 (US1 tests) — all parallel
- T035, T036, T037, T038 (US3 use cases + form) — all parallel
- T045, T046, T047, T048 (US4 use cases + form) — all parallel
- US1, US2, US3, US4 as whole phases — all parallel

---

## Parallel Example: User Story 3 (Debts)

```bash
# Parallel batch 1 — use cases + form widget (different files):
Task: T035 "AddInitialDebtUseCase"
Task: T036 "EditInitialDebtUseCase"
Task: T037 "DeleteInitialDebtUseCase"
Task: T038 "DebtFormBottomSheet"

# Sequential — depends on above:
Task: T039 "DebtsStepWidget" (uses DebtFormBottomSheet)
Task: T040 "Wire cubit methods" (uses use cases)
Task: T041 "Connect in page"

# Parallel batch 2 — tests:
Task: T042 "Unit test AddInitialDebtUseCase"
Task: T043 "Widget test DebtsStepWidget"
Task: T044 "Widget test DebtFormBottomSheet"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (DB migration, entity changes)
2. Complete Phase 2: Foundational (cubit skeleton, router guard, shared widgets)
3. Complete Phase 3: User Story 1 (Welcome + Balance)
4. **STOP and VALIDATE**: User can enter balance, data persists, router guard works
5. Ship as minimal onboarding

### Incremental Delivery

1. Setup + Foundational → Foundation ready
2. Add US1 (Balance) → MVP! Test independently
3. Add US2 (Savings) → Balance + Savings working
4. Add US3 (Debts) → Balance + Savings + Debts working
5. Add US4 (Lendings) → All data collection working
6. Add US5 (Summary) → Full review before confirm
7. Add US6 (Back Nav) → Complete wizard UX
8. Polish → Edge cases, performance, integration tests

### Notes

- Each increment is independently testable and shippable
- Commit after each task
- Run `flutter test` after each phase checkpoint
- Run `dart run build_runner build` after entity/schema changes
