# Implementation Plan: Salary Split to Savings

**Branch**: `004-salary-split-savings` | **Date**: 2026-06-28 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/004-salary-split-savings/spec.md`

## Summary

Allow users to split their salary between current cycle balance and savings at cycle start. A new salary split screen appears during onboarding (after salary setup) and cycle reset (after previous cycle closes), letting users allocate 0 to 100% of their salary to savings via a numeric input. The implementation adds a `salarySplitAmount` column to `financial_cycles`, creates a new `DepositSalarySplitUseCase`, inserts the split screen into onboarding and settings flows, and updates all balance formulas to subtract the split amount.

## Technical Context

**Language/Version**: Dart 3.x / Flutter  
**Primary Dependencies**: Drift (SQLite ORM), BLoC/Cubit, GoRouter, Freezed, json_serializable  
**Storage**: SQLite via Drift (local, offline-first)  
**Testing**: Flutter test (unit tests for use cases, widget tests for UI components)  
**Target Platform**: Android / iOS  
**Project Type**: Mobile app  
**Performance Goals**: 60fps UI, <500ms split screen response (SC-004)  
**Constraints**: Offline-first, <200ms DB operations, single-user local data  
**Scale/Scope**: Single user, ~50 screens, local storage only

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | PASS | All data in local SQLite. No network dependency. Split amount stored in cycle row. |
| II. Testing (NON-NEGOTIABLE) | PASS | Unit tests for DepositSalarySplitUseCase, balance formula. Widget tests for split screen. |
| III. Data Safety (NON-NEGOTIABLE) | PASS | Additive migration (new column with default 0). Split deposit uses existing Drift transaction patterns. |
| IV. Approved Tech Stack (STRICT) | PASS | Using only Drift, BLoC/Cubit, GoRouter, Freezed. No new dependencies. |
| V. Clean Architecture (STRICT) | PASS | Domain entity/repo changes -> Application use case -> Infrastructure DAO/impl -> Presentation cubit/page. All dependency arrows inward. |
| VI. Separation of Concerns (STRICT) | PASS | One class per file. SalarySplitCubit orchestrates use case. Split page renders. No business logic in widgets. |
| VII. Performance (CRITICAL) | PASS | Single DB write on confirm. Real-time balance preview is pure arithmetic (no DB calls). const widgets where possible. |
| VIII. Product Stability | PASS | Additive DB migration (schema v4 -> v5). Backward compatible — existing cycles get salarySplitAmount=0, preserving current balance calculations. |
| IX. Definition of Done (STRICT) | PASS | Implemented + tested + offline + no data corruption risk + clean architecture + separation of concerns. |

**No violations. No complexity tracking needed.**

## Project Structure

### Documentation (this feature)

```text
specs/004-salary-split-savings/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti/lib/
├── domain/
│   ├── entities/
│   │   └── financial_cycle_entity.dart          # MODIFIED (add salarySplitAmount field)
│   └── repositories/
│       └── cycle_repository.dart                # MODIFIED (add salarySplitAmount to createCycle)
├── application/
│   └── use_cases/
│       └── savings/
│           └── deposit_salary_split_use_case.dart  # NEW
├── infrastructure/
│   ├── database/
│   │   ├── tables/
│   │   │   └── financial_cycles_table.dart      # MODIFIED (add salarySplitAmount column)
│   │   ├── daos/
│   │   │   └── cycles_dao.dart                  # MODIFIED (pass salarySplitAmount in insert)
│   │   └── app_database.dart                    # MODIFIED (schema v4→v5 migration)
│   ├── repositories/
│   │   └── cycle_repository_impl.dart           # MODIFIED (pass salarySplitAmount)
│   └── mappers/
│       └── cycle_mapper.dart                    # MODIFIED (map salarySplitAmount if mapper exists)
├── presentation/
│   ├── salary_split/
│   │   ├── pages/
│   │   │   └── salary_split_page.dart           # NEW
│   │   ├── cubits/
│   │   │   ├── salary_split_cubit.dart          # NEW
│   │   │   └── salary_split_state.dart          # NEW
│   │   └── widgets/
│   │       └── balance_preview_card.dart        # NEW (shows salary, allocation, remaining)
│   ├── onboarding/
│   │   └── cubits/
│   │       ├── onboarding_cubit.dart            # MODIFIED (add OnboardingSalarySplit state)
│   │       └── onboarding_state.dart            # MODIFIED (add OnboardingSalarySplit)
│   ├── settings/
│   │   ├── cubits/
│   │   │   ├── settings_cubit.dart              # MODIFIED (emit SettingsResetWithSplit)
│   │   │   └── settings_state.dart              # MODIFIED (add SettingsResetWithSplit)
│   │   └── pages/
│   │       └── settings_page.dart               # MODIFIED (navigate to split on reset)
│   └── shared/
│       └── routing/
│           └── app_router.dart                  # MODIFIED (add /salary-split route)
├── core/
│   └── di/
│       └── injection.dart                       # MODIFIED (register DepositSalarySplitUseCase, SalarySplitCubit)

chahriyti/test/
├── unit/
│   └── savings/
│       ├── deposit_salary_split_use_case_test.dart  # NEW
│       └── balance_formula_with_split_test.dart     # NEW
└── widget/
    └── salary_split/
        └── salary_split_page_test.dart              # NEW
```

### Modified Existing Files

```text
chahriyti/lib/
├── application/
│   └── use_cases/
│       ├── savings/
│       │   └── deposit_cycle_savings_use_case.dart  # MODIFIED (subtract salarySplitAmount in balance calc)
│       ├── dashboard/
│       │   └── get_dashboard_data_use_case.dart     # MODIFIED (subtract salarySplitAmount from totalIn)
│       └── cycle/
│           └── reset_cycle_use_case.dart             # MODIFIED (return created cycle entity)
├── presentation/
│   ├── expense/
│   │   └── pages/
│   │       └── add_expense_page.dart                # MODIFIED (_getCurrentBalance subtracts salarySplitAmount)
│   └── debt/
│       └── pages/
│           └── debt_detail_page.dart                # MODIFIED (_getCurrentBalance subtracts salarySplitAmount)
```

**Structure Decision**: Follows existing Clean Architecture pattern. New `salary_split/` feature module in Presentation layer. The use case lives under existing `savings/` domain since it creates a savings deposit. No new external interfaces (contracts/ not needed — this is a purely local mobile app feature).
