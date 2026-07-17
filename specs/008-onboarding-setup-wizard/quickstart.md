# Quickstart: Onboarding Financial Setup Wizard

**Branch**: `008-onboarding-setup-wizard` | **Date**: 2026-07-06

## What This Feature Does

Adds a step-by-step wizard that first-time users complete after verification. Collects: current balance, savings, debts (who + amount), lendings (who + amount). Prevents users from starting the app with empty/fake financial data.

## Architecture Overview

```
Presentation          Application              Domain                Infrastructure
─────────────        ──────────────           ──────────              ──────────────
FinancialSetupPage    SetInitialBalanceUseCase  UserEntity (modified)  UserRepositoryImpl
 └─ step widgets      SetInitialSavingsUseCase  UserRepository (mod)   UsersDao (modified)
FinancialSetupCubit   AddInitialDebtUseCase     DebtEntity (as-is)     DebtsDao (as-is)
 └─ sealed states     AddInitialLendingUseCase  LendingEntity (as-is)  LendingsDao (as-is)
                      CompleteFinancialSetup    DebtRepository (as-is) SavingsDao (as-is)
                      GetFinancialSetupStep     LendingRepository      DB migration
                                                SavingsRepository
```

## Layer-by-Layer Implementation Order

### 1. Domain Layer (no dependencies)
- Add `initialBalance`, `hasCompletedFinancialSetup`, `financialSetupStep` to `UserEntity`
- Add corresponding methods to `UserRepository` interface:
  - `updateInitialBalance(int userId, double balance)`
  - `updateFinancialSetupStep(int userId, int? step)`
  - `completeFinancialSetup(int userId)`

### 2. Infrastructure Layer (depends on Domain)
- Drift migration: add 3 columns to users table
- Update `UsersDao` with new column mappings
- Update `UserRepositoryImpl` with new methods
- Update user mapper for new fields

### 3. Application Layer (depends on Domain)
- `SetInitialBalanceUseCase` — saves balance + advances step
- `SetInitialSavingsUseCase` — creates savings deposit + advances step
- `AddInitialDebtUseCase` — creates debt entry via existing repo
- `EditInitialDebtUseCase` — updates debt entry
- `DeleteInitialDebtUseCase` — removes debt entry
- `AddInitialLendingUseCase` — creates lending entry via existing repo
- `EditInitialLendingUseCase` — updates lending entry
- `DeleteInitialLendingUseCase` — removes lending entry
- `CompleteFinancialSetupUseCase` — sets flag, clears step
- `GetFinancialSetupStepUseCase` — reads current step for resume
- `GetSetupSummaryUseCase` — aggregates all wizard data for summary

### 4. Presentation Layer (depends on Application)
- `FinancialSetupCubit` + sealed states
- `FinancialSetupPage` — main page with BlocBuilder
- Step widgets: Welcome, Balance, Savings, Debts, Lendings, Summary
- `DebtFormBottomSheet` / `LendingFormBottomSheet` — add/edit forms
- Shared: `SetupProgressBar`, `AmountInputField`
- Register route `/financial-setup` in GoRouter
- Add redirect guard for `hasCompletedFinancialSetup`

### 5. DI Registration
- Register all new use cases in service locator
- Register `FinancialSetupCubit`

### 6. Testing
- Unit tests: all use cases
- Widget tests: each step widget, progress bar, form validation
- Integration test: full wizard flow end-to-end
- Edge case tests: app restart resume, back navigation, skip flows

## Key Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Wizard placement | After activation, before salary onboarding | Capture baseline before cycle starts |
| Balance storage | New field on UserEntity | Balance ≠ salary; no cycle exists yet |
| Savings entry | Existing SavingsHistory deposit | Reuse infra, no data duplication |
| Debts/Lendings | Existing entities directly | Already have all needed fields |
| Progress tracking | Integer step on UserEntity | Simple, survives app restart |
| Cubit pattern | Sealed classes (not Freezed) | Matches existing OnboardingCubit pattern |

## Files to Create

```
lib/application/use_cases/financial_setup/
├── set_initial_balance_use_case.dart
├── set_initial_savings_use_case.dart
├── add_initial_debt_use_case.dart
├── edit_initial_debt_use_case.dart
├── delete_initial_debt_use_case.dart
├── add_initial_lending_use_case.dart
├── edit_initial_lending_use_case.dart
├── delete_initial_lending_use_case.dart
├── complete_financial_setup_use_case.dart
├── get_financial_setup_step_use_case.dart
└── get_setup_summary_use_case.dart

lib/presentation/financial_setup/
├── cubits/
│   ├── financial_setup_cubit.dart
│   └── financial_setup_state.dart
├── pages/
│   └── financial_setup_page.dart
└── widgets/
    ├── welcome_step_widget.dart
    ├── balance_step_widget.dart
    ├── savings_step_widget.dart
    ├── debts_step_widget.dart
    ├── lendings_step_widget.dart
    ├── summary_step_widget.dart
    ├── setup_progress_bar.dart
    ├── amount_input_field.dart
    ├── debt_form_bottom_sheet.dart
    └── lending_form_bottom_sheet.dart
```

## Files to Modify

```
lib/domain/entities/user_entity.dart          — Add 3 fields
lib/domain/repositories/user_repository.dart  — Add 3 methods
lib/infrastructure/repositories/user_repository_impl.dart — Implement new methods
lib/infrastructure/database/daos/users_dao.dart — Add columns + queries
lib/infrastructure/database/app_database.dart — Migration version bump
lib/presentation/shared/routing/app_router.dart — Add guard + route
lib/core/di/injection_container.dart          — Register new dependencies
```
