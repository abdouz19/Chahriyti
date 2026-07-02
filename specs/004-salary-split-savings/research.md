# Research: Salary Split to Savings

**Feature**: 004-salary-split-savings  
**Date**: 2026-06-26

## Research Question 1: How to store the salary split amount?

### Decision: Add `salarySplitAmount` field to FinancialCycleEntity

### Rationale

Adding a `salarySplitAmount` integer field (default 0) to the existing `FinancialCycleEntity` and its backing `financial_cycles` table is the simplest approach that correctly handles all edge cases.

The balance formula becomes:
```
currentBalance = salaryAmount - salarySplitAmount + totalIncome - totalExpenses - totalDebtPayments
```

This is superior to reducing `salaryAmount` directly because if the user later changes their salary in settings, the split amount stays fixed and the balance adjusts correctly. For example: user earns 60,000, splits 40,000 to savings. If they later change salary to 70,000, balance goes from 20,000 to 30,000 — the 40,000 savings split is preserved.

### Alternatives Considered

1. **Reduce salaryAmount on cycle creation** — Rejected because salary edits mid-cycle would be ambiguous. The original salary is lost.
2. **Separate salary_splits table** — Rejected as over-engineered. The split is a one-time decision per cycle, tightly coupled to the cycle entity. A separate table adds unnecessary complexity.

## Research Question 2: Where to insert the split screen in the app flow?

### Decision: Two insertion points — onboarding and cycle reset

### Rationale

**Onboarding flow** (`OnboardingCubit`):
- Current state flow: `OnboardingSalaryInput` → `OnboardingLoading` → `OnboardingIncomeInput`
- New state flow: `OnboardingSalaryInput` → `OnboardingLoading` → `OnboardingSalarySplit` → `OnboardingIncomeInput`
- After `setSalary()` succeeds, emit `OnboardingSalarySplit` instead of `OnboardingIncomeInput`
- New method `applySalarySplit(int amount)` deposits to savings and transitions to `OnboardingIncomeInput`
- New method `skipSalarySplit()` transitions directly to `OnboardingIncomeInput`

**Cycle reset flow** (`SettingsCubit`):
- Current: `resetCycle()` calls `_resetCycle()`, emits `SettingsResetComplete`, then `loadSettings()`
- New: `resetCycle()` captures the returned `FinancialCycleEntity`, emits `SettingsResetWithSplit(newCycleId, salaryAmount)` instead of `SettingsResetComplete`
- The settings page listens for this state and navigates to the salary split page
- After split completes (or is skipped), navigates back and emits `SettingsResetComplete`

### Alternatives Considered

- **Dialog overlay** — Rejected. A full-page experience is clearer for an important financial decision.
- **Bottom sheet** — Rejected. Too constrained for showing salary, split amount, and remaining balance simultaneously.

## Research Question 3: How to record the salary split deposit?

### Decision: Reuse existing SavingsRepository.createDeposit

### Rationale

The existing `SavingsRepository.createDeposit()` method accepts `amount`, `description`, and `cycleId` — exactly what we need. The salary split deposit uses:
- `type`: `deposit`
- `description`: `"تقسيم الراتب"` (Salary Split)
- `cycleId`: the new cycle's ID
- No `expenseId` or `debtPaymentId` (null)

This distinguishes it from end-of-cycle deposits (which use description "ادخار نهاية الدورة") in savings history display.

### Alternatives Considered

- **New transaction type** — Rejected. Adding a new enum value to `SavingsTransactionType` would require schema changes for no functional benefit. The description field already distinguishes deposit sources.

## Research Question 4: Split screen UX approach

### Decision: Numeric input field with real-time balance preview

### Rationale

Per the spec requirements (FR-002, FR-003), the split screen shows:
1. Total salary amount (read-only)
2. Savings allocation input (numeric field, default 0)
3. Remaining balance = salary - allocation (computed, read-only)

The user types the amount they want to save. The remaining balance updates in real-time. Validation ensures 0 ≤ allocation ≤ salary (FR-005, FR-006). A warning appears when allocation equals full salary (FR-013).

Skip button always visible (FR-012). Confirm button applies the split and is final (FR-016).

### Alternatives Considered

- **Slider** — Considered but rejected as primary input. Slider precision with large DZD amounts (e.g., 60,000) is poor. A numeric input is more precise and faster.
- **Dual input (balance + savings)** — Rejected. One input with computed complement is simpler and prevents inconsistency.

## Research Question 5: Balance formula update locations

### Decision: Update all balance computation points

### Rationale

The following locations compute or use the cycle balance and must subtract `salarySplitAmount`:

1. **`GetDashboardDataUseCase`** (line 79-80): `totalIn = salaryAmount + totalIncome` → `totalIn = salaryAmount - salarySplitAmount + totalIncome`
2. **`DepositCycleSavingsUseCase`**: End-of-cycle savings deposit computes remaining balance — must subtract split amount
3. **Inline `_getCurrentBalance()` methods**: Found in `debt_detail_page.dart` and `add_expense_page.dart` — must subtract split amount
4. **`CycleRepository.createCycle()`**: Must accept optional `salarySplitAmount` parameter

All other consumers of `FinancialCycleEntity.salaryAmount` (e.g., settings display) remain unchanged since they show the original salary, not the cycle balance.
