# Quickstart: Salary Split to Savings

**Feature**: 004-salary-split-savings  
**Date**: 2026-06-26

## Implementation Checkpoints

### Checkpoint 1: Schema & Entity

**Goal**: FinancialCycleEntity has `salarySplitAmount` field, database migrates cleanly.

**Verify**:
- [ ] `financial_cycles_table.dart` has `salarySplitAmount` column with default 0
- [ ] `financial_cycle_entity.dart` has `salarySplitAmount` field (required, default 0 in factory)
- [ ] `app_database.dart` schema version bumped to 5 with migration for new column
- [ ] `CycleRepository.createCycle()` accepts optional `salarySplitAmount` parameter
- [ ] `CycleRepositoryImpl` passes `salarySplitAmount` through to DAO
- [ ] Generated files rebuilt: `*.freezed.dart`, `*.g.dart`
- [ ] App launches without crash, existing data preserved

### Checkpoint 2: Balance Formula

**Goal**: All balance calculations subtract `salarySplitAmount`.

**Verify**:
- [ ] `GetDashboardDataUseCase`: `totalIn = salaryAmount - cycle.salarySplitAmount + totalIncome`
- [ ] `DepositCycleSavingsUseCase`: remaining balance subtracts `salarySplitAmount`
- [ ] `debt_detail_page.dart` `_getCurrentBalance()`: subtracts `salarySplitAmount`
- [ ] `add_expense_page.dart` `_getCurrentBalance()`: subtracts `salarySplitAmount`
- [ ] Dashboard shows correct balance when `salarySplitAmount = 0` (backward compatible)

### Checkpoint 3: Deposit Use Case

**Goal**: `DepositSalarySplitUseCase` creates a savings deposit and updates the cycle.

**Verify**:
- [ ] Use case accepts `cycleId` and `amount`
- [ ] Validates `amount > 0` and `amount <= salaryAmount`
- [ ] Creates savings deposit with description "تقسيم الراتب"
- [ ] Updates cycle's `salarySplitAmount` field
- [ ] Unit tests pass: valid split, zero split (no-op), over-salary rejected

### Checkpoint 4: Split Screen UI

**Goal**: Salary split page renders correctly in Arabic RTL with real-time feedback.

**Verify**:
- [ ] Shows total salary (read-only)
- [ ] Numeric input for savings allocation, defaults to 0
- [ ] Remaining balance updates in real-time: `salary - input`
- [ ] Skip button visible, navigates without splitting
- [ ] Confirm button creates deposit and navigates forward
- [ ] Warning shown when allocation equals full salary (balance = 0)
- [ ] Input capped at salary amount, rejects negative values

### Checkpoint 5: Onboarding Integration

**Goal**: Split screen appears after salary setup during onboarding.

**Verify**:
- [ ] `OnboardingCubit` has `OnboardingSalarySplit` state
- [ ] After `setSalary()`, flow goes to split screen (not directly to income input)
- [ ] `applySalarySplit(amount)` deposits and transitions to `OnboardingIncomeInput`
- [ ] `skipSalarySplit()` transitions directly to `OnboardingIncomeInput`
- [ ] Onboarding page listens for `OnboardingSalarySplit` and shows split screen

### Checkpoint 6: Cycle Reset Integration

**Goal**: Split screen appears after cycle reset in settings.

**Verify**:
- [ ] `SettingsCubit` has `SettingsResetWithSplit` state with `newCycleId` and `salaryAmount`
- [ ] `resetCycle()` captures returned cycle entity and emits `SettingsResetWithSplit`
- [ ] Settings page navigates to salary split page on `SettingsResetWithSplit`
- [ ] After split completes (or skip), navigates back and refreshes settings

### Checkpoint 7: Tests

**Goal**: All tests pass, covering core business logic and UI.

**Verify**:
- [ ] Unit test: `DepositSalarySplitUseCase` — valid split, zero split, over-salary
- [ ] Unit test: Balance formula with non-zero `salarySplitAmount`
- [ ] Widget test: Split page renders, input updates balance, skip works, confirm works
- [ ] All existing tests still pass (no regressions)

## Quick Smoke Test

1. Fresh install → Onboarding → Enter salary 60,000 → Split screen appears → Allocate 40,000 → Dashboard shows balance 20,000, savings shows +40,000
2. Same app → Settings → Reset cycle → Split screen appears → Skip → Dashboard shows full salary
3. Same app → Settings → Reset cycle → Split screen → Allocate 30,000 → Confirm → Dashboard shows salary - 30,000, savings increases by 30,000
4. Allocate full salary → Warning appears → Confirm → Balance is 0
