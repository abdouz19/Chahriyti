# Tasks: Salary Split to Savings

**Input**: Design documents from `/specs/004-salary-split-savings/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Included per Constitution Principle II (Testing is NON-NEGOTIABLE).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Database schema changes and entity updates that all user stories depend on

- [X] T001 Add `salarySplitAmount` column to `FinancialCycles` table in `chahriyti/lib/infrastructure/database/tables/financial_cycles_table.dart` — `IntColumn get salarySplitAmount => integer().withDefault(const Constant(0))();`
- [X] T002 Add `salarySplitAmount` field to `FinancialCycleEntity` in `chahriyti/lib/domain/entities/financial_cycle_entity.dart` — add `@Default(0) int salarySplitAmount` to the Freezed factory constructor
- [X] T003 Run Freezed/json_serializable code generation: `dart run build_runner build --delete-conflicting-outputs` from `chahriyti/` directory to regenerate `financial_cycle_entity.freezed.dart` and `financial_cycle_entity.g.dart`
- [X] T004 Add schema v4→v5 migration in `chahriyti/lib/infrastructure/database/app_database.dart` — bump `schemaVersion` to 5, add `if (from < 5) { await m.addColumn(financialCycles, financialCycles.salarySplitAmount); }` in `onUpgrade`
- [X] T005 Update `CyclesDao.insertCycle` in `chahriyti/lib/infrastructure/database/daos/cycles_dao.dart` — ensure `FinancialCyclesCompanion` passes `salarySplitAmount` through (Drift handles this automatically via the companion, but verify existing insert calls are compatible)
- [X] T006 Add `salarySplitAmount` parameter to `CycleRepository.createCycle()` in `chahriyti/lib/domain/repositories/cycle_repository.dart` — add `int salarySplitAmount = 0` optional named parameter
- [X] T007 Update `CycleRepositoryImpl.createCycle()` in `chahriyti/lib/infrastructure/repositories/cycle_repository_impl.dart` — pass `salarySplitAmount` into the `FinancialCyclesCompanion` and include `salarySplitAmount` when mapping the returned row to `FinancialCycleEntity`

**Checkpoint**: App launches without crash, existing data preserved with `salarySplitAmount = 0` for all existing cycles.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Balance formula updates and core use case that MUST be complete before any user story UI work

**CRITICAL**: No user story work can begin until this phase is complete

- [X] T008 [P] Update balance formula in `GetDashboardDataUseCase` in `chahriyti/lib/application/use_cases/dashboard/get_dashboard_data_use_case.dart` — change `totalIn = salaryAmount + totalIncome` to `totalIn = salaryAmount - cycle.salarySplitAmount + totalIncome` (around line 79)
- [X] T009 [P] Update balance formula in `DepositCycleSavingsUseCase` in `chahriyti/lib/application/use_cases/savings/deposit_cycle_savings_use_case.dart` — change `remainingBalance = cycle.salaryAmount + totalIncome - totalExpenses - totalDebtPayments` to subtract `cycle.salarySplitAmount` (around line 36-37)
- [X] T010 [P] Update `_getCurrentBalance()` in `chahriyti/lib/presentation/expense/pages/add_expense_page.dart` — subtract `cycle.salarySplitAmount` from the balance calculation
- [X] T011 [P] Update `_getCurrentBalance()` in `chahriyti/lib/presentation/debt/pages/debt_detail_page.dart` — subtract `cycle.salarySplitAmount` from the balance calculation
- [X] T012 Create `DepositSalarySplitUseCase` in `chahriyti/lib/application/use_cases/savings/deposit_salary_split_use_case.dart` — accepts `cycleId` and `amount`, validates `amount > 0` and `amount <= salaryAmount`, calls `SavingsRepository.createDeposit(amount: amount, description: 'تقسيم الراتب', cycleId: cycleId)`, then updates the cycle's `salarySplitAmount` field via the repository
- [X] T013 Add `updateCycleSalarySplit(int cycleId, int salarySplitAmount)` method to `CycleRepository` in `chahriyti/lib/domain/repositories/cycle_repository.dart` and implement in `CycleRepositoryImpl` in `chahriyti/lib/infrastructure/repositories/cycle_repository_impl.dart` and `CyclesDao` in `chahriyti/lib/infrastructure/database/daos/cycles_dao.dart`
- [X] T014 Register `DepositSalarySplitUseCase` in `chahriyti/lib/core/di/injection.dart` — add static field and initialize in `init()` with `cycleRepository` and `savingsRepository` dependencies

**Checkpoint**: Balance formulas correct with `salarySplitAmount`. `DepositSalarySplitUseCase` ready to be called from UI. Dashboard shows correct balance when `salarySplitAmount = 0` (backward compatible).

---

## Phase 3: User Story 1 — Split Salary into Balance and Savings (Priority: P1) MVP

**Goal**: Create the salary split screen with numeric input, real-time balance preview, skip/confirm actions, and full-salary warning. This is the core UI component reused by US2 and US3.

**Independent Test**: Navigate directly to `/salary-split` route with test salary amount. Verify input defaults to 0, remaining balance updates in real-time, skip navigates away without changes, confirm creates savings deposit and updates cycle.

### Tests for User Story 1

- [X] T015 [P] [US1] Unit test for `DepositSalarySplitUseCase` in `chahriyti/test/unit/savings/deposit_salary_split_use_case_test.dart` — test valid split (amount within salary), zero split (no-op), over-salary rejected, negative amount rejected
- [X] T016 [P] [US1] Unit test for balance formula with split in `chahriyti/test/unit/savings/balance_formula_with_split_test.dart` — verify `currentBalance = salary - salarySplitAmount + income - expenses - debtPayments` for dashboard and deposit use cases
- [X] T017 [P] [US1] Widget test for salary split page in `chahriyti/test/widget/salary_split/salary_split_page_test.dart` — verify: renders with salary, input defaults to 0, remaining balance updates on input change, skip button works, confirm button creates deposit, full-salary warning appears when allocation = salary

### Implementation for User Story 1

- [X] T018 [P] [US1] Create `SalarySplitState` sealed class in `chahriyti/lib/presentation/salary_split/cubits/salary_split_state.dart` — states: `SalarySplitInitial(int salaryAmount)`, `SalarySplitUpdating(int salaryAmount, int allocationAmount, int remainingBalance)`, `SalarySplitConfirming`, `SalarySplitComplete`, `SalarySplitError(String message)`
- [X] T019 [US1] Create `SalarySplitCubit` in `chahriyti/lib/presentation/salary_split/cubits/salary_split_cubit.dart` — constructor takes `DepositSalarySplitUseCase`, `int cycleId`, `int salaryAmount`. Methods: `updateAllocation(int amount)` (validates 0..salary, emits `SalarySplitUpdating` with computed remaining), `confirmSplit()` (calls use case, emits `SalarySplitComplete`), `skip()` (emits `SalarySplitComplete` without deposit)
- [X] T020 [P] [US1] Create `BalancePreviewCard` widget in `chahriyti/lib/presentation/salary_split/widgets/balance_preview_card.dart` — displays total salary (read-only), savings allocation amount, and remaining balance in a card layout. Arabic RTL, uses `AppColors` and `AppTypography`. Shows warning text "رصيدك الحالي سيكون 0 دج" when remaining balance is 0
- [X] T021 [US1] Create `SalarySplitPage` in `chahriyti/lib/presentation/salary_split/pages/salary_split_page.dart` — full-page screen with: header text explaining the split, `BalancePreviewCard`, numeric input field (default 0, validated 0..salary), skip button ("تخطي"), confirm button ("تأكيد"). Uses `BlocProvider` with `SalarySplitCubit`. Accepts `cycleId`, `salaryAmount`, and `onComplete` callback via constructor/route extras
- [X] T022 [US1] Add `/salary-split` route to `chahriyti/lib/presentation/shared/routing/app_router.dart` — `GoRoute(path: '/salary-split', builder: ...)` that extracts `cycleId`, `salaryAmount`, and `onComplete` from `state.extra` map
- [X] T023 [US1] Register `SalarySplitCubit` factory in `chahriyti/lib/core/di/injection.dart` — no static singleton needed since it's per-screen; document how it's created with `BlocProvider` in the page

**Checkpoint**: Salary split screen renders, input works, skip and confirm function correctly. Can be tested by navigating to `/salary-split` directly. Core UI complete for US2 and US3 to reuse.

---

## Phase 4: User Story 2 — Split Salary on Cycle Reset (Priority: P2)

**Goal**: After cycle reset in settings, navigate to the salary split screen before returning to dashboard. The most common entry point for salary splits.

**Independent Test**: Go to Settings → Reset Cycle → Confirm. After reset completes, salary split screen appears. Allocate an amount → confirm → navigate back to settings/dashboard with updated balance. Or skip → navigate back with full salary.

### Implementation for User Story 2

- [X] T024 [US2] Add `SettingsResetWithSplit` state to `SettingsCubit` in `chahriyti/lib/presentation/settings/cubits/settings_cubit.dart` — new state class: `SettingsResetWithSplit({required int cycleId, required int salaryAmount})`. Modify `resetCycle()` method: capture the returned `FinancialCycleEntity` from `_resetCycle()`, emit `SettingsResetWithSplit(cycleId: newCycle.id, salaryAmount: newCycle.salaryAmount)` instead of `SettingsResetComplete`
- [X] T025 [US2] Add `completeSalarySplit()` method to `SettingsCubit` in `chahriyti/lib/presentation/settings/cubits/settings_cubit.dart` — emits `SettingsResetComplete` and calls `loadSettings()`. Called after split screen completes (either confirm or skip)
- [X] T026 [US2] Update `SettingsPage` in `chahriyti/lib/presentation/settings/pages/settings_page.dart` — add `BlocListener` for `SettingsResetWithSplit` state: when emitted, navigate to `/salary-split` with `cycleId` and `salaryAmount` from the state. Pass an `onComplete` callback that calls `settingsCubit.completeSalarySplit()` and navigates back

**Checkpoint**: Full cycle reset → salary split → settings flow works end-to-end. Skip preserves full salary. Confirm creates deposit and reduces balance.

---

## Phase 5: User Story 3 — Split Salary During Onboarding (Priority: P3)

**Goal**: After salary setup during onboarding, show the salary split screen before proceeding to additional income input. New users discover savings from day one.

**Independent Test**: Fresh app → Onboarding → Enter salary 50,000 → Split screen appears → Allocate 15,000 → Confirm → Income input screen shows → Complete onboarding → Dashboard shows balance 35,000, savings shows +15,000.

### Implementation for User Story 3

- [X] T027 [US3] Add `OnboardingSalarySplit` state to `OnboardingCubit` in `chahriyti/lib/presentation/onboarding/cubits/onboarding_cubit.dart` — new state class: `OnboardingSalarySplit({required int cycleId, required int salaryAmount})`. Modify `setSalary()` method: after creating the cycle, emit `OnboardingSalarySplit(cycleId: cycle.id, salaryAmount: cycle.salaryAmount)` instead of `OnboardingIncomeInput`
- [X] T028 [US3] Add `applySalarySplit()` and `skipSalarySplit()` methods to `OnboardingCubit` in `chahriyti/lib/presentation/onboarding/cubits/onboarding_cubit.dart` — `applySalarySplit(int amount)` calls `DepositSalarySplitUseCase` then emits `OnboardingIncomeInput`. `skipSalarySplit()` emits `OnboardingIncomeInput` directly. Both transition to the next onboarding step
- [X] T029 [US3] Update `OnboardingCubit` constructor in `chahriyti/lib/presentation/onboarding/cubits/onboarding_cubit.dart` — add `DepositSalarySplitUseCase` as a dependency parameter
- [X] T030 [US3] Update `OnboardingCubit` creation in `chahriyti/lib/core/di/injection.dart` or wherever it's instantiated — pass the `depositSalarySplitUseCase` dependency
- [X] T031 [US3] Update onboarding UI flow to handle `OnboardingSalarySplit` state — in the onboarding page/router that listens to `OnboardingCubit` states, add a case for `OnboardingSalarySplit`: show the `SalarySplitPage` (reuse from US1) with `cycleId` and `salaryAmount` from the state, with `onComplete` calling cubit's `applySalarySplit()` or `skipSalarySplit()`

**Checkpoint**: Full onboarding → salary split → income input flow works. Skip goes straight to income. Confirm deposits to savings. All three user stories independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation, edge cases, and test coverage

- [X] T032 [P] Verify backward compatibility — ensure existing cycles with `salarySplitAmount = 0` produce identical balance calculations to pre-feature behavior across dashboard, deposit cycle savings, expense page, and debt page
- [X] T033 [P] Verify savings history display — confirm salary split deposits show with description "تقسيم الراتب" and are visually distinct from end-of-cycle deposits ("ادخار نهاية الدورة") in `chahriyti/lib/presentation/savings/pages/savings_page.dart`
- [X] T034 Run all existing tests to verify no regressions — `flutter test` from `chahriyti/` directory
- [X] T035 Run quickstart.md smoke test scenarios: (1) Fresh install → onboarding → split 40k from 60k → dashboard shows 20k, (2) Reset cycle → skip → full salary, (3) Reset cycle → split 30k → balance reduced, (4) Full salary allocation → warning appears → confirm → balance 0

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately. T001→T002→T003 must be sequential (table before entity before codegen). T004-T007 depend on T003 but can run in parallel with each other.
- **Foundational (Phase 2)**: Depends on Phase 1 completion. T008-T011 are parallel (different files). T013 before T012 (repo method needed by use case). T14 depends on T012.
- **User Story 1 (Phase 3)**: Depends on Phase 2. T015-T017 (tests) parallel. T018-T020 parallel. T021 depends on T018-T020. T022-T023 depend on T021.
- **User Story 2 (Phase 4)**: Depends on Phase 3 (reuses SalarySplitPage). T024→T025→T026 sequential.
- **User Story 3 (Phase 5)**: Depends on Phase 3 (reuses SalarySplitPage). Independent from US2. T027→T028→T029→T030→T031 sequential.
- **Polish (Phase 6)**: Depends on all user stories being complete.

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Foundational (Phase 2) — creates the core split screen
- **User Story 2 (P2)**: Depends on US1 (reuses SalarySplitPage) — can start after Phase 3
- **User Story 3 (P3)**: Depends on US1 (reuses SalarySplitPage) — can start after Phase 3, parallel with US2

### Parallel Opportunities

- Phase 1: T004, T005, T006, T007 can run in parallel after T003
- Phase 2: T008, T009, T010, T011 are fully parallel (different files)
- Phase 3: T015, T016, T017 (tests) are parallel. T018, T020 are parallel
- Phase 4 & 5: US2 and US3 can run in parallel (independent integration points)

---

## Parallel Example: Phase 2 (Foundational)

```bash
# Launch all balance formula updates together:
Task: "T008 Update balance formula in GetDashboardDataUseCase"
Task: "T009 Update balance formula in DepositCycleSavingsUseCase"
Task: "T010 Update _getCurrentBalance() in add_expense_page.dart"
Task: "T011 Update _getCurrentBalance() in debt_detail_page.dart"
```

## Parallel Example: User Story 1

```bash
# Launch tests together:
Task: "T015 Unit test for DepositSalarySplitUseCase"
Task: "T016 Unit test for balance formula with split"
Task: "T017 Widget test for salary split page"

# Launch independent UI components together:
Task: "T018 Create SalarySplitState"
Task: "T020 Create BalancePreviewCard widget"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (schema + entity changes)
2. Complete Phase 2: Foundational (balance formulas + core use case)
3. Complete Phase 3: User Story 1 (split screen UI)
4. **STOP and VALIDATE**: Test split screen by navigating directly to `/salary-split`
5. App is functional — split screen exists but isn't wired into any flow yet

### Incremental Delivery

1. Phase 1 + Phase 2 → Schema ready, balance formulas correct
2. Add User Story 1 → Split screen works standalone (MVP)
3. Add User Story 2 → Cycle reset triggers split (most common path)
4. Add User Story 3 → Onboarding includes split (discovery path)
5. Each story adds a new entry point without breaking previous ones

### Parallel Team Strategy

With multiple developers after Phase 3:
- Developer A: User Story 2 (settings integration)
- Developer B: User Story 3 (onboarding integration)
- Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- States are defined inline in cubit files (no separate state files exist in this project)
- `ResetCycleUseCase.call()` already returns `Future<FinancialCycleEntity>` — no modification needed
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
