# Tasks: Automatic Monthly Cycle Renewal

**Input**: Design documents from `specs/007-auto-cycle-renewal/`
**Branch**: `007-auto-cycle-renewal`
**Stack**: Flutter / Dart / Drift / BloC / GoRouter / Clean Architecture

## Format: `[ID] [P?] [Story?] Description — file path`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[US#]**: User story this task belongs to

---

## Phase 1: Setup

**Purpose**: No new dependencies or project structure needed — existing Flutter/Drift project. This phase establishes the `pendingCycleForSplit` bridge field needed by both US1 and US2.

- [X] T001 Add `static FinancialCycleEntity? pendingCycleForSplit` field to `Injection` class and import the entity — `chahriyti/lib/core/di/injection.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: `getCycleForMonth` DAO + repository additions that US1 (`CheckAndStartCycleUseCase`) depends on. Must complete before Phase 3.

**⚠️ CRITICAL**: US1 cannot be implemented until T002 and T003 are done.

- [X] T00Add `Future<FinancialCycleEntity?> getCycleForMonth(int year, int month)` to the `CycleRepository` abstract interface — `chahriyti/lib/domain/repositories/cycle_repository.dart`
- [X] T00Add `getCycleForMonth` DAO method to `CyclesDao`: query `financialCycles` where `startDate >= DateTime(year, month, 1)` AND `startDate < DateTime(year, month+1, 1)`, return `getSingleOrNull()` — `chahriyti/lib/infrastructure/database/daos/cycles_dao.dart`
- [X] T00Implement `getCycleForMonth` in `CycleRepositoryImpl`: call `_dao.getCycleForMonth(year, month)`, map result to entity — `chahriyti/lib/infrastructure/repositories/cycle_repository_impl.dart`

**Checkpoint**: `getCycleForMonth` fully wired through all layers. `CheckAndStartCycleUseCase` can now be built.

---

## Phase 3: User Story 1 — Auto Cycle Start on Salary Day (Priority: P1) 🎯 MVP

**Goal**: On every app launch, detect if today ≥ salary day and no cycle for this month exists. If so, auto-close the previous cycle (deposit savings), create a new one, and redirect to salary split.

**Independent Test**: Set salary day to today's date. Kill and reopen the app. Verify: salary split screen appears, spending list is empty in new cycle, debts/lendings/goals intact.

- [X] T00[US1] Create `CheckAndStartCycleUseCase` with constructor `(UserRepository, CycleRepository, DepositCycleSavingsUseCase)`. Implement `call()`: (1) get user, (2) compute effective salary day clamped to month's days using `DateTime(y, m+1, 0).day`, (3) if today < salary date return null, (4) call `getCycleForMonth(today.year, today.month)` — if non-null return null, (5) if active cycle exists deposit savings + close it, (6) compute new cycle startDate/endDate (end = next month's salary date - 1 day, also clamped), (7) return `createCycle(...)` — `chahriyti/lib/application/use_cases/cycle/check_and_start_cycle_use_case.dart`
- [X] T00[US1] Register `CheckAndStartCycleUseCase` in `Injection.init()`: `checkAndStartCycleUseCase = CheckAndStartCycleUseCase(userRepository, cycleRepository, depositCycleSavingsUseCase)` — `chahriyti/lib/core/di/injection.dart`
- [X] T00[US1] Add cycle gate to `AppRouter` redirect: after the activated-user pass-through, if `path != '/salary-split'` and not an onboarding path, call `await Injection.checkAndStartCycleUseCase()`. If result is non-null, set `Injection.pendingCycleForSplit = result` and return `'/salary-split'` — `chahriyti/lib/presentation/shared/routing/app_router.dart`

**Checkpoint**: US1 complete and independently testable.

---

## Phase 4: User Story 2 — Salary Split on Cycle Start (Priority: P2)

**Goal**: When redirected to `/salary-split` by the auto-cycle gate, the page reads from `Injection.pendingCycleForSplit`, disables back navigation, and routes to `/home` on completion.

**Independent Test**: Trigger auto-cycle (Phase 3 checkpoint), verify salary split screen appears with correct salary amount, back button is disabled, completing split navigates to home and balance reflects the allocation.

- [X] T00[US2] Update `/salary-split` route builder in `AppRouter`: read `Injection.pendingCycleForSplit` when `state.extra` is null; consume and clear the field (`Injection.pendingCycleForSplit = null`); derive `cycleId`, `salaryAmount`, and `onComplete = () => context.go('/home')` from either source; pass to `SalarySplitCubit` — `chahriyti/lib/presentation/shared/routing/app_router.dart`
- [X] T00[US2] Update `SalarySplitPage` to disable the back button (use `PopScope(canPop: false, ...)` or `WillPopScope`) when entered from auto-cycle (detect via absence of `state.extra`). A flag `isAutoEntry` can be passed as a route param or derived from `Injection.pendingCycleForSplit` having been non-null — `chahriyti/lib/presentation/salary_split/pages/salary_split_page.dart`

**Checkpoint**: US1 + US2 complete. App auto-detects cycle renewal, forces salary split, user reaches home with correct balance.

---

## Phase 5: User Story 3 — Salary Day Change Locking Rule (Priority: P3)

**Goal**: Salary day changes update only `user.salaryDay`. Active cycle dates are never touched. Manual reset button is removed. `ResetCycleUseCase` is deleted.

**Independent Test**: Change salary day in settings. Verify the active cycle's startDate/endDate are unchanged. Kill and reopen app on the new salary day → new cycle uses new salary day.

- [X] T0[US3] In `SettingsCubit.updateSalaryDay`: remove the `_cycleRepository.updateCycleSalaryDay(...)` call. Keep only `updatedUser.copyWith(salaryDay: newDay)` and `_userRepository.updateUser(updatedUser)`. Also add informational text in the success state: compute whether today >= this month's new salary day and include a `salaryDayChangeMessage` string in `SettingsLoaded` or emit a snackbar — `chahriyti/lib/presentation/settings/cubits/settings_cubit.dart`
- [X] T0[US3] Remove `resetCycle()` method, `SettingsResetWithSplit` state, `SettingsResetComplete` state, and `_resetCycle` dependency from `SettingsCubit`. Keep `SettingsDataResetComplete` (danger zone reset) — `chahriyti/lib/presentation/settings/cubits/settings_cubit.dart`
- [X] T0[US3] Remove the "إعادة تعيين الدورة" `OutlinedButton` and its surrounding card section from `_buildContent`. Keep "سجل الدورات" link and the danger zone card. Also remove the `SettingsResetWithSplit` and `SettingsResetComplete` branches from the `BlocConsumer` listener — `chahriyti/lib/presentation/settings/pages/settings_page.dart`
- [X] T0[US3] Replace `updateCycleSalaryDay` body in `CycleRepositoryImpl` with a no-op (or remove the method if the interface removes it, but keep the interface method as no-op for now since callers may still reference it) — `chahriyti/lib/infrastructure/repositories/cycle_repository_impl.dart`
- [X] T0[P] [US3] Remove `resetCycleUseCase` registration and `ResetCycleUseCase` import from `Injection.init()`. Remove `static late final ResetCycleUseCase resetCycleUseCase` declaration — `chahriyti/lib/core/di/injection.dart`
- [X] T0[P] [US3] Delete `reset_cycle_use_case.dart` — `chahriyti/lib/application/use_cases/cycle/reset_cycle_use_case.dart`

**Checkpoint**: All 3 user stories complete and independently functional.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Edge case hardening, cleanup, and end-to-end validation.

- [X] T0Extract the salary-day clamping logic `min(salaryDay, DateTime(y, m+1, 0).day)` into a private static helper inside `CheckAndStartCycleUseCase` or a top-level function in a new file `chahriyti/lib/domain/utils/salary_day_utils.dart` — `chahriyti/lib/application/use_cases/cycle/check_and_start_cycle_use_case.dart`
- [X] T0Add a guard in `GetDashboardDataUseCase` (or `HomeCubit`): if no active cycle is returned, emit a `HomeNoCycle` state so the home screen shows a friendly message ("دورتك تبدأ يوم [salary day]") instead of crashing — `chahriyti/lib/application/use_cases/dashboard/get_dashboard_data_use_case.dart`
- [X] T0[P] Update `reset_app_data_use_case.dart`: after `resetFinancialData()`, use the clamped salary day helper when computing the new cycle's startDate/endDate — `chahriyti/lib/application/use_cases/cycle/reset_app_data_use_case.dart`
- [X] T0[P] Update `setup_salary_use_case.dart` (onboarding): use the clamped salary day helper when computing initial cycle dates — `chahriyti/lib/application/use_cases/onboarding/setup_salary_use_case.dart`
- [X] T0Run `flutter analyze` and resolve any dead-code or unused-import diagnostics introduced by removing `ResetCycleUseCase` and related states — project root

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — BLOCKS Phase 3
- **Phase 3 (US1)**: Depends on Phase 2
- **Phase 4 (US2)**: Depends on Phase 3 (T007 must exist before T008)
- **Phase 5 (US3)**: Independent of Phase 3/4 — can run in parallel after Phase 2
- **Phase 6 (Polish)**: Depends on all story phases

### Story Dependencies

- **US1 (P1)**: Requires Phases 1 + 2 complete
- **US2 (P2)**: Requires US1 (T007 provides the route redirect that T008 must handle)
- **US3 (P3)**: Independent — can run in parallel with US1 after Phase 2 complete

### Parallel Opportunities

- T003 (DAO) and T004 (repo impl) can run in parallel after T002 (interface) is done
- T014 (injection cleanup) and T015 (delete file) run in parallel within US3
- T018 and T019 (polish) are fully independent of each other

---

## Implementation Strategy

### MVP (US1 only)

1. T001 → T002 → T003 → T004 → T005 → T006 → T007
2. **Validate**: Open app with no current-month cycle — salary split screen appears
3. Confirm expenses reset, debts/lendings/goals intact

### Full Feature

4. T008 → T009 (US2: salary split polish)
5. T010 → T011 → T012 → T013 → T014 → T015 (US3: settings cleanup)
6. T016 → T017 → T018 → T019 → T020 (polish)

---

## Notes

- Tasks T010 and T011 both edit `settings_cubit.dart` — run sequentially, not in parallel
- Tasks T007 and T008 both edit `app_router.dart` — complete T007 first, then T008
- When deleting `reset_cycle_use_case.dart` (T015), verify no other file imports it before deletion via `grep -r "reset_cycle_use_case" chahriyti/lib/`
- `DepositCycleSavingsUseCase` is already registered in injection — reuse in `CheckAndStartCycleUseCase` constructor
