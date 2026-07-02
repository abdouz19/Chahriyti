# Implementation Plan: Savings Account (المدخرات)

**Branch**: `003-savings-account` | **Date**: 2026-06-26 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/003-savings-account/spec.md`
**User instructions**: Keep the same UX/UI consistency, test everything before finishing, implement end to end.

## Summary

Add a savings account system where unspent cycle balances are automatically deposited as savings, and users can pay expenses/debts from savings via a toggle on payment forms. A dedicated savings history screen is accessible from Settings. The implementation adds a new `savings_history` table, extends existing `expenses` and `debt_payments` tables with a `fromSavings` flag, and modifies balance calculations to exclude savings-funded transactions.

## Technical Context

**Language/Version**: Dart 3.x / Flutter  
**Primary Dependencies**: Drift (SQLite ORM), BLoC/Cubit, GoRouter, Freezed, json_serializable  
**Storage**: SQLite via Drift (local, offline-first)  
**Testing**: Flutter test (unit tests for use cases, widget tests for UI components, integration tests for flows)  
**Target Platform**: Android / iOS  
**Project Type**: Mobile app  
**Performance Goals**: 60fps UI, <1s screen loads  
**Constraints**: Offline-first, <200ms DB operations, single-user local data  
**Scale/Scope**: Single user, ~50 screens, local storage only

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | ✅ PASS | All data in local SQLite. No network dependency. |
| II. Testing (NON-NEGOTIABLE) | ✅ PASS | Unit tests for all use cases, widget tests for savings UI, integration tests for cycle-end deposit flow. |
| III. Data Safety (NON-NEGOTIABLE) | ✅ PASS | Savings deposit + withdrawal in Drift transactions. Migration is additive (new table + new columns with defaults). |
| IV. Approved Tech Stack (STRICT) | ✅ PASS | Using only Drift, BLoC/Cubit, GoRouter, Freezed — all approved. No new dependencies. |
| V. Clean Architecture (STRICT) | ✅ PASS | Domain entities/repos → Application use cases → Infrastructure DAOs/impls → Presentation cubits/pages. All dependency arrows inward. |
| VI. Separation of Concerns (STRICT) | ✅ PASS | One class per file. DAOs handle data only. Use cases handle logic. Cubits orchestrate. Widgets render. |
| VII. Performance (CRITICAL) | ✅ PASS | ListView.builder for history, const widgets, no DB calls in build(). |
| VIII. Product Stability | ✅ PASS | Additive DB migration (schema v3→v4). Backward compatible — existing data untouched. New columns have defaults. |
| IX. Definition of Done (STRICT) | ✅ PASS | Implemented + tested + offline + no data corruption risk + clean architecture compliance. |

**No violations. No complexity tracking needed.**

## Project Structure

### Documentation (this feature)

```text
specs/003-savings-account/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (/speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti/lib/
├── domain/
│   ├── entities/
│   │   └── savings_history_entity.dart          # NEW
│   └── repositories/
│       └── savings_repository.dart              # NEW
├── application/
│   └── use_cases/
│       └── savings/
│           ├── get_savings_balance_use_case.dart   # NEW
│           ├── get_savings_history_use_case.dart   # NEW
│           ├── deposit_cycle_savings_use_case.dart # NEW
│           └── withdraw_savings_use_case.dart      # NEW
├── infrastructure/
│   ├── database/
│   │   ├── tables/
│   │   │   └── savings_history_table.dart       # NEW
│   │   ├── daos/
│   │   │   └── savings_dao.dart                 # NEW
│   │   └── app_database.dart                    # MODIFIED (add table, migration v3→v4)
│   └── repositories/
│       └── savings_repository_impl.dart         # NEW
├── presentation/
│   ├── savings/
│   │   ├── pages/
│   │   │   └── savings_page.dart                # NEW
│   │   ├── cubits/
│   │   │   ├── savings_cubit.dart               # NEW
│   │   │   └── savings_state.dart               # NEW
│   │   └── widgets/
│   │       └── savings_history_item.dart        # NEW
│   └── shared/
│       └── widgets/
│           └── payment_source_toggle.dart       # NEW (reusable toggle widget)
├── core/
│   └── di/
│       └── injection.dart                       # MODIFIED (register savings dependencies)

chahriyti/test/
├── unit/
│   └── savings/
│       ├── deposit_cycle_savings_use_case_test.dart  # NEW
│       ├── withdraw_savings_use_case_test.dart       # NEW
│       ├── get_savings_balance_use_case_test.dart    # NEW
│       └── get_savings_history_use_case_test.dart    # NEW
├── widget/
│   └── savings/
│       ├── savings_page_test.dart                   # NEW
│       └── payment_source_toggle_test.dart          # NEW
└── integration/
    └── savings/
        └── savings_flow_test.dart                   # NEW
```

### Modified Existing Files

```text
chahriyti/lib/
├── infrastructure/
│   ├── database/
│   │   ├── tables/
│   │   │   ├── expenses_table.dart              # ADD fromSavings column
│   │   │   └── debt_payments_table.dart         # ADD fromSavings column (new table file)
│   │   └── daos/
│   │       ├── expenses_dao.dart                # ADD fromSavings filter to getTotalExpenses
│   │       └── debts_dao.dart                   # ADD fromSavings filter to getTotalPaymentsForCycle
│   └── repositories/
│       ├── expense_repository_impl.dart         # PASS fromSavings through
│       └── debt_repository_impl.dart            # PASS fromSavings through
├── domain/
│   ├── entities/
│   │   └── expense_entity.dart                  # ADD fromSavings field
│   └── repositories/
│       ├── expense_repository.dart              # ADD fromSavings param to addExpense
│       └── debt_repository.dart                 # ADD fromSavings param to makePayment
├── application/
│   └── use_cases/
│       ├── expense/
│       │   └── add_expense_use_case.dart        # ADD fromSavings + savings withdrawal
│       ├── debt/
│       │   └── add_debt_payment_use_case.dart   # ADD fromSavings + savings withdrawal
│       └── cycle/
│           └── reset_cycle_use_case.dart         # ADD savings deposit on cycle close
├── presentation/
│   ├── expense/
│   │   ├── cubits/expense_cubit.dart            # ADD fromSavings state + toggle
│   │   └── pages/add_expense_page.dart          # ADD payment source toggle UI
│   ├── debt/
│   │   ├── cubits/debt_cubit.dart               # ADD fromSavings to payment
│   │   └── pages/debt_detail_page.dart          # ADD payment source toggle UI
│   ├── settings/
│   │   └── pages/settings_page.dart             # ADD savings entry button
│   └── shared/
│       └── routing/app_router.dart              # ADD /savings route
```

**Structure Decision**: Follows the existing Clean Architecture pattern. New `savings/` feature module under each layer. Shared `PaymentSourceToggle` widget in `presentation/shared/widgets/` for reuse across expense and debt payment forms.
