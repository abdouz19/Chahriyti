# Implementation Plan: Onboarding Financial Setup Wizard

**Branch**: `008-onboarding-setup-wizard` | **Date**: 2026-07-06 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/008-onboarding-setup-wizard/spec.md`

## Summary

Post-verification step-by-step wizard that captures users' real financial starting point: balance, savings, debts (who + amount), and lendings (who + amount). Runs after license activation, before salary onboarding. Uses existing debt/lending/savings infrastructure. New sealed-state cubit, new use cases, DB migration for 3 user fields, router guard addition.

## Technical Context

**Language/Version**: Dart 3.x / Flutter  
**Primary Dependencies**: BloC/Cubit, Drift (SQLite ORM), GoRouter, Freezed (entities)  
**Storage**: SQLite via Drift — local-only, offline-first  
**Testing**: Flutter test (unit + widget + integration)  
**Target Platform**: Android/iOS mobile  
**Project Type**: Mobile app (Flutter, Clean Architecture)  
**Performance Goals**: 60fps wizard transitions, <100ms step saves  
**Constraints**: Offline-capable, must survive app kill mid-wizard  
**Scale/Scope**: Single user per device, 6 wizard screens

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First | PASS | All data stored locally via Drift/SQLite. No network calls. |
| II. Testing Mandatory | PASS | Unit tests for all use cases, widget tests for each step, integration test for full flow. |
| III. Data Safety | PASS | Each step persists immediately. `financialSetupStep` enables resume on crash. No data loss scenario. |
| IV. Approved Stack | PASS | Flutter, Dart, Drift, BloC/Cubit, GoRouter — all approved. No new dependencies. |
| V. Clean Architecture | PASS | Domain (entities + repo interfaces) → Application (use cases) → Infrastructure (Drift impl) → Presentation (cubit + widgets). Dependency rule respected. |
| VI. Separation of Concerns | PASS | Separate cubit from existing onboarding. One class per file. Widgets contain no business logic. Use cases are single-operation. Mappers in dedicated files. |
| VII. Performance | PASS | Const widgets, no heavy computation in build(). ListView.builder for debt/lending lists. No unnecessary rebuilds — BlocBuilder per step. |
| VIII. Product Stability | PASS | DB migration is additive (new nullable columns). Backward compatible. |
| IX. Definition of Done | PASS | All criteria addressed in testing plan. |

**Gate Result**: ALL PASS — no violations.

## Project Structure

### Documentation (this feature)

```text
specs/008-onboarding-setup-wizard/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 research decisions
├── data-model.md        # Entity/schema changes
├── quickstart.md        # Implementation guide
├── contracts/
│   └── financial-setup-contract.md  # UI/cubit contract
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 output (via /speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti/lib/
├── core/
│   └── di/injection_container.dart          # DI registration (modified)
├── domain/
│   ├── entities/user_entity.dart            # Add 3 fields (modified)
│   └── repositories/user_repository.dart    # Add 3 methods (modified)
├── application/
│   └── use_cases/financial_setup/           # NEW directory
│       ├── set_initial_balance_use_case.dart
│       ├── set_initial_savings_use_case.dart
│       ├── add_initial_debt_use_case.dart
│       ├── edit_initial_debt_use_case.dart
│       ├── delete_initial_debt_use_case.dart
│       ├── add_initial_lending_use_case.dart
│       ├── edit_initial_lending_use_case.dart
│       ├── delete_initial_lending_use_case.dart
│       ├── complete_financial_setup_use_case.dart
│       ├── get_financial_setup_step_use_case.dart
│       └── get_setup_summary_use_case.dart
├── infrastructure/
│   ├── database/
│   │   ├── app_database.dart                # Migration bump (modified)
│   │   └── daos/users_dao.dart              # New columns (modified)
│   └── repositories/
│       └── user_repository_impl.dart        # New methods (modified)
└── presentation/
    ├── financial_setup/                     # NEW feature module
    │   ├── cubits/
    │   │   ├── financial_setup_cubit.dart
    │   │   └── financial_setup_state.dart
    │   ├── pages/
    │   │   └── financial_setup_page.dart
    │   └── widgets/
    │       ├── welcome_step_widget.dart
    │       ├── balance_step_widget.dart
    │       ├── savings_step_widget.dart
    │       ├── debts_step_widget.dart
    │       ├── lendings_step_widget.dart
    │       ├── summary_step_widget.dart
    │       ├── setup_progress_bar.dart
    │       ├── amount_input_field.dart
    │       ├── debt_form_bottom_sheet.dart
    │       └── lending_form_bottom_sheet.dart
    └── shared/
        └── routing/app_router.dart          # Add guard + route (modified)

chahriyti/test/
├── unit/
│   └── application/financial_setup/         # NEW
│       ├── set_initial_balance_use_case_test.dart
│       ├── set_initial_savings_use_case_test.dart
│       ├── add_initial_debt_use_case_test.dart
│       ├── complete_financial_setup_use_case_test.dart
│       └── get_setup_summary_use_case_test.dart
├── widget/
│   └── presentation/financial_setup/        # NEW
│       ├── balance_step_widget_test.dart
│       ├── debts_step_widget_test.dart
│       ├── summary_step_widget_test.dart
│       └── setup_progress_bar_test.dart
└── integration/
    └── financial_setup_flow_test.dart       # NEW
```

**Structure Decision**: Follows existing Clean Architecture layout. New feature module `financial_setup` under presentation. Use cases grouped in `application/use_cases/financial_setup/`. No new infrastructure modules — reuses existing DAOs/repos for debts, lendings, savings.

## Complexity Tracking

> No violations — no complexity justification needed.

## Post-Design Constitution Re-Check

| Principle | Status | Notes |
|-----------|--------|-------|
| V. Clean Architecture | PASS | All layers respect dependency rule. Cubit calls use cases only. No infra imports in presentation. |
| VI. Separation of Concerns | PASS | 11 single-purpose use cases. 10 single-purpose widgets. 1 cubit. No god classes. File naming follows convention. |
| All others | PASS | No changes from initial check. |
