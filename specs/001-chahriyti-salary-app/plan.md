# Implementation Plan: Chahriyti — Personal Salary & Expense Management App

**Branch**: `001-chahriyti-salary-app` | **Date**: 2026-06-25 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/001-chahriyti-salary-app/spec.md`

## Summary

Build a fully offline, Arabic-first mobile app (Flutter) that helps Algerian salaried employees track their expenses, manage debts, set savings goals, and receive smart financial insights. The app uses Clean Architecture with Drift/SQLite for local storage, BloC/Cubit for state management, and a device-based licensing model activated via WhatsApp. Key emphasis: **clean professional UI, modern UX for non-technical users, performance-first design with paginated lists and smooth animations**.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.x  
**Primary Dependencies**: Drift (ORM), flutter_bloc (state), GoRouter (navigation), Freezed (models), google_fonts (Cairo), lottie (animations), flutter_svg (illustrations), crypto (licensing), device_info_plus + flutter_secure_storage (device ID), url_launcher (WhatsApp)  
**Storage**: SQLite via Drift (offline-first, WAL journal mode)  
**Testing**: flutter_test (unit + widget), integration_test  
**Target Platform**: Android 8+ / iOS 15+  
**Project Type**: Mobile app  
**Performance Goals**: 60 fps UI, <100ms page transitions, <200ms list loads, smooth onboarding animations  
**Constraints**: Fully offline (except WhatsApp activation + notifications), <50MB app size, Arabic RTL primary layout  
**Scale/Scope**: Single-user per device, ~1,000 concurrent installs, 16 screens, ~40 functional requirements

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | PASS | Fully offline, SQLite local storage, no cloud dependency |
| II. Testing Mandatory | PASS | Unit tests for domain/application, widget tests for UI, integration tests for flows |
| III. Data Safety | PASS | Drift with WAL mode, safe migrations, centimes for monetary values |
| IV. Approved Stack | PASS | Flutter, Dart, Drift, BloC/Cubit, GoRouter, Freezed. All additional packages have business justification (see research.md) |
| V. Clean Architecture | PASS | Domain → Application → Infrastructure/Presentation. Use cases orchestrate all logic |
| VI. Separation of Concerns | PASS | One class per file, feature modules self-contained, dedicated file naming conventions |
| VII. Performance Engineering | PASS | Paginated lists (ListView.builder + limit/offset), const widgets, RepaintBoundary, lazy loading, no heavy work in build() |
| VIII. Product Stability | PASS | Drift explicit migrations, schema versioning, backward compatibility |
| IX. Definition of Done | PASS | Each feature: implemented, tested, validated, performant, offline, safe data |

**Pre-design gate: PASSED** — No violations. All principles satisfied.

## Project Structure

### Documentation (this feature)

```text
specs/001-chahriyti-salary-app/
├── plan.md                 # This file
├── spec.md                 # Feature specification
├── research.md             # Phase 0: Technology research
├── data-model.md           # Phase 1: Entity definitions & schema
├── quickstart.md           # Phase 1: Setup & build instructions
├── contracts/
│   └── ui-contracts.md     # Phase 1: Screen layouts & navigation
├── checklists/
│   └── requirements.md     # Spec quality checklist
└── tasks.md                # Phase 2: Task breakdown (created by /speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti/
├── lib/
│   ├── main.dart                              # Entry point, DI bootstrap
│   ├── app.dart                               # MaterialApp, theme, locale, router
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart                # 6-color palette (teal, green, red, white, charcoal, gray)
│   │   │   ├── app_typography.dart            # Cairo font styles
│   │   │   └── app_theme.dart                 # ThemeData assembly
│   │   ├── constants/
│   │   │   ├── categories.dart                # Expense category/subcategory enums
│   │   │   └── wilayas.dart                   # 58 Algerian wilayas
│   │   ├── extensions/
│   │   │   └── money_extensions.dart          # Centimes ↔ DZD formatting
│   │   └── di/
│   │       └── injection.dart                 # Service locator / DI setup
│   ├── domain/
│   │   ├── entities/
│   │   │   ├── user_entity.dart
│   │   │   ├── financial_cycle_entity.dart
│   │   │   ├── expense_entity.dart
│   │   │   ├── debt_entity.dart
│   │   │   ├── savings_goal_entity.dart
│   │   │   ├── additional_income_entity.dart
│   │   │   └── weekly_challenge_entity.dart
│   │   ├── repositories/
│   │   │   ├── user_repository.dart
│   │   │   ├── cycle_repository.dart
│   │   │   ├── expense_repository.dart
│   │   │   ├── debt_repository.dart
│   │   │   ├── goal_repository.dart
│   │   │   └── income_repository.dart
│   │   └── value_objects/
│   │       ├── money.dart                     # Type-safe monetary value (centimes)
│   │       └── device_id.dart                 # Device identifier wrapper
│   ├── application/
│   │   └── use_cases/
│   │       ├── onboarding/
│   │       │   ├── setup_salary_use_case.dart
│   │       │   └── add_initial_income_use_case.dart
│   │       ├── activation/
│   │       │   ├── get_device_id_use_case.dart
│   │       │   ├── validate_license_use_case.dart
│   │       │   └── compose_whatsapp_message_use_case.dart
│   │       ├── expense/
│   │       │   ├── add_expense_use_case.dart
│   │       │   ├── edit_expense_use_case.dart
│   │       │   ├── delete_expense_use_case.dart
│   │       │   └── get_expenses_use_case.dart
│   │       ├── dashboard/
│   │       │   ├── get_dashboard_data_use_case.dart
│   │       │   └── get_safe_balance_use_case.dart
│   │       ├── statistics/
│   │       │   ├── get_category_breakdown_use_case.dart
│   │       │   ├── get_predictions_use_case.dart
│   │       │   ├── get_monthly_comparison_use_case.dart
│   │       │   ├── get_financial_classification_use_case.dart
│   │       │   └── detect_financial_leaks_use_case.dart
│   │       ├── debt/
│   │       │   ├── add_debt_use_case.dart
│   │       │   ├── make_debt_payment_use_case.dart
│   │       │   └── get_debts_use_case.dart
│   │       ├── goal/
│   │       │   ├── create_goal_use_case.dart
│   │       │   ├── contribute_to_goal_use_case.dart
│   │       │   └── get_goals_use_case.dart
│   │       ├── income/
│   │       │   └── add_income_use_case.dart
│   │       ├── cycle/
│   │       │   └── reset_cycle_use_case.dart
│   │       └── challenge/
│   │           └── generate_weekly_challenge_use_case.dart
│   ├── infrastructure/
│   │   ├── database/
│   │   │   ├── app_database.dart              # Drift GeneratedDatabase
│   │   │   ├── tables/                        # Drift table definitions
│   │   │   │   ├── users_table.dart
│   │   │   │   ├── financial_cycles_table.dart
│   │   │   │   ├── expenses_table.dart
│   │   │   │   ├── debts_table.dart
│   │   │   │   ├── debt_payments_table.dart
│   │   │   │   ├── savings_goals_table.dart
│   │   │   │   ├── savings_contributions_table.dart
│   │   │   │   ├── additional_incomes_table.dart
│   │   │   │   ├── weekly_challenges_table.dart
│   │   │   │   └── license_activations_table.dart
│   │   │   └── daos/                          # Drift DAOs
│   │   │       ├── users_dao.dart
│   │   │       ├── cycles_dao.dart
│   │   │       ├── expenses_dao.dart
│   │   │       ├── debts_dao.dart
│   │   │       ├── goals_dao.dart
│   │   │       └── incomes_dao.dart
│   │   ├── repositories/                      # Repository implementations
│   │   │   ├── user_repository_impl.dart
│   │   │   ├── cycle_repository_impl.dart
│   │   │   ├── expense_repository_impl.dart
│   │   │   ├── debt_repository_impl.dart
│   │   │   ├── goal_repository_impl.dart
│   │   │   └── income_repository_impl.dart
│   │   └── services/
│   │       ├── device_info_service.dart        # Device UUID via device_info_plus
│   │       ├── secure_storage_service.dart     # flutter_secure_storage wrapper
│   │       └── license_service.dart            # HMAC validation logic
│   └── presentation/
│       ├── onboarding/
│       │   ├── pages/
│       │   │   ├── splash_page.dart
│       │   │   ├── salary_setup_page.dart
│       │   │   ├── additional_income_page.dart
│       │   │   └── value_proposition_page.dart
│       │   ├── cubits/
│       │   │   └── onboarding_cubit.dart
│       │   └── widgets/
│       │       └── onboarding_page_indicator.dart
│       ├── activation/
│       │   ├── pages/
│       │   │   └── activation_page.dart
│       │   ├── cubits/
│       │   │   └── activation_cubit.dart
│       │   └── widgets/
│       │       └── license_key_dialog.dart
│       ├── home/
│       │   ├── pages/
│       │   │   └── home_page.dart
│       │   ├── cubits/
│       │   │   └── dashboard_cubit.dart
│       │   └── widgets/
│       │       ├── balance_card.dart
│       │       ├── expenses_card.dart
│       │       ├── days_remaining_widget.dart
│       │       ├── daily_average_widget.dart
│       │       ├── consumption_bar.dart
│       │       ├── safe_balance_card.dart
│       │       ├── goal_progress_card.dart
│       │       ├── debt_summary_card.dart
│       │       └── recent_expenses_list.dart
│       ├── expense/
│       │   ├── pages/
│       │   │   ├── add_expense_page.dart
│       │   │   └── edit_expense_page.dart
│       │   ├── cubits/
│       │   │   └── expense_cubit.dart
│       │   └── widgets/
│       │       ├── category_grid.dart
│       │       ├── subcategory_chips.dart
│       │       └── expense_form.dart
│       ├── history/
│       │   ├── pages/
│       │   │   └── expense_history_page.dart
│       │   └── cubits/
│       │       └── history_cubit.dart
│       ├── statistics/
│       │   ├── pages/
│       │   │   └── statistics_page.dart
│       │   ├── cubits/
│       │   │   └── statistics_cubit.dart
│       │   └── widgets/
│       │       ├── category_breakdown_chart.dart
│       │       ├── prediction_card.dart
│       │       ├── monthly_comparison_chart.dart
│       │       └── classification_badge.dart
│       ├── debt/
│       │   ├── pages/
│       │   │   ├── add_debt_page.dart
│       │   │   └── debt_detail_page.dart
│       │   └── cubits/
│       │       └── debt_cubit.dart
│       ├── goal/
│       │   ├── pages/
│       │   │   ├── add_goal_page.dart
│       │   │   └── goal_detail_page.dart
│       │   └── cubits/
│       │       └── goal_cubit.dart
│       ├── income/
│       │   ├── pages/
│       │   │   └── add_income_page.dart
│       │   └── cubits/
│       │       └── income_cubit.dart
│       ├── settings/
│       │   ├── pages/
│       │   │   └── settings_page.dart
│       │   └── cubits/
│       │       └── settings_cubit.dart
│       └── shared/
│           ├── widgets/
│           │   ├── empty_state_widget.dart     # Reusable: SVG + title + subtitle + CTA
│           │   ├── money_text.dart             # LTR amount + دج
│           │   ├── loading_shimmer.dart        # Skeleton loading
│           │   └── confirmation_dialog.dart    # Reusable confirmation dialog
│           └── routing/
│               └── app_router.dart             # GoRouter configuration
├── assets/
│   ├── illustrations/                          # SVG empty states (from unDraw)
│   │   ├── empty_expenses.svg
│   │   ├── empty_debts.svg
│   │   ├── empty_goals.svg
│   │   ├── empty_history.svg
│   │   └── empty_stats.svg
│   └── animations/                             # Lottie onboarding files
│       ├── welcome.json
│       ├── features.json
│       └── activate.json
├── test/
│   ├── unit/
│   │   ├── domain/                             # Entity validation tests
│   │   ├── application/                        # Use case tests
│   │   └── infrastructure/                     # DAO & repository tests
│   └── widget/
│       ├── onboarding/                         # Onboarding flow widget tests
│       ├── home/                               # Dashboard widget tests
│       ├── expense/                            # Expense flow widget tests
│       └── shared/                             # Shared widget tests
├── integration_test/
│   ├── onboarding_flow_test.dart
│   ├── expense_flow_test.dart
│   └── activation_flow_test.dart
└── tools/
    └── generate_license.dart                   # Admin-side license key generator
```

**Structure Decision**: Flutter Clean Architecture with feature-based module organization under `presentation/`. Each feature module contains its own `pages/`, `cubits/`, and `widgets/` subdirectories. Domain and application layers are feature-agnostic (organized by entity/use-case). Infrastructure contains the Drift database with table definitions and DAOs.

## Design Decisions

### UX/UI Priorities (Per User Request)

1. **Clean, professional UI** — 6-color minimal palette (Deep Teal `#0D6E6E` brand), Cairo font, consistent spacing
2. **Non-technical user friendly** — Simple 4-category expense system, large touch targets, clear Arabic labels, no jargon
3. **Onboarding animations** — Lottie illustrations with staggered entry transitions (3 screens max)
4. **Empty state illustrations** — SVG illustrations from unDraw for every empty list/screen
5. **Performance-first** — Paginated lists with `ListView.builder` + `limit/offset`, `const` widgets, `RepaintBoundary`, no heavy work in `build()`

### Performance Rules (From Constitution VII)

- All lists use `ListView.builder` with pagination (20 items per page)
- `const` constructors everywhere possible
- `BlocBuilder` with `buildWhen` for granular rebuilds — never rebuild full screens
- `RepaintBoundary` around charts and progress bars
- No database calls or heavy computation in `build()`
- Implicit animations only (`AnimatedContainer`, `AnimatedOpacity`) except onboarding Lottie
- Lazy-load screens via GoRouter
- Structured logging via `logger` — no `print()` in production

### Data Safety (From Constitution III)

- WAL journal mode for concurrent read safety
- Explicit Drift migrations with version tracking
- All monetary values in centimes (integer) — no floating point
- Transaction wrapping for multi-table operations (e.g., debt payment updates both Debt and DebtPayment)

## Post-Design Constitution Re-Check

| Principle | Status | Verification |
|-----------|--------|-------------|
| I. Offline-First | PASS | SQLite local, no cloud sync, WhatsApp only external dependency |
| II. Testing | PASS | test/ structure mirrors source, unit + widget + integration layers defined |
| III. Data Safety | PASS | WAL mode, explicit migrations, centimes, transaction wrapping |
| IV. Approved Stack | PASS | All packages listed in research.md with business justification |
| V. Clean Architecture | PASS | Domain/Application/Infrastructure/Presentation layers, dependency rule enforced |
| VI. Separation of Concerns | PASS | One class per file, feature modules isolated, file naming conventions |
| VII. Performance | PASS | Paginated lists, const widgets, granular rebuilds, lazy loading |
| VIII. Product Stability | PASS | Schema versioning, backward-compatible migrations |
| IX. Definition of Done | PASS | Each task will require: implementation + tests + performance check |

**Post-design gate: PASSED** — No violations.

## Complexity Tracking

> No violations to justify — all principles satisfied without exceptions.
