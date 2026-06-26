# Implementation Plan: Advanced Financial Tools & Intelligence

**Branch**: `002-finance-intelligence` | **Date**: 2026-06-26 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `specs/002-finance-intelligence/spec.md`

## Summary

Extend the Chahriyti salary management app with sophisticated financial tools: Goals tracking with progress visualization, Debt management with payment tracking, User financial classification based on savings rates, optional Weekly challenges, Financial leak detection, and Smart insights. All features maintain the existing Clean Architecture, offline-first design, Arabic-first UX, performance-first approach with paginated lists, and seamless integration with the existing UI/UX system.

## Technical Context

**Language/Version**: Dart 3.9.2 / Flutter 3.x  
**Primary Dependencies**: Drift (ORM), flutter_bloc (state), GoRouter (navigation), Freezed (models), fl_chart (visualization for goals/debts), existing infrastructure from 001-chahriyti-salary-app  
**Storage**: SQLite via Drift (extends existing schema)  
**Testing**: flutter_test (unit + widget), integration_test  
**Target Platform**: Android 8+ / iOS 15+  
**Project Type**: Mobile app extension  
**Performance Goals**: 60 fps UI, <100ms page transitions, <200ms list loads for debts/goals, instant classification updates  
**Constraints**: Fully offline, <100MB total app size, Arabic RTL primary, consistent with existing design system  
**Scale/Scope**: Single-user per device, extends existing architecture, ~8 new screens, ~6 new use cases, ~22 new functional requirements

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | PASS | All features fully offline; no cloud dependency; SQLite extends existing schema |
| II. Testing Mandatory | PASS | Unit tests for classification logic, goal/debt calculations; widget tests for new screens; integration tests for financial workflows |
| III. Data Safety | PASS | New Drift tables use WAL mode; centimes for monetary values; atomic transactions for debt payments |
| IV. Approved Stack | PASS | Flutter, Dart, Drift, BloC/Cubit, GoRouter, Freezed; fl_chart approved for visualization (business-justified) |
| V. Clean Architecture | PASS | Domain entities (Goal, Debt, Challenge, Insight); Application use cases; Infrastructure repositories + DAOs; Presentation pages + cubits |
| VI. Separation of Concerns | PASS | One file per class; feature modules self-contained; dedicated naming conventions; goal/debt features isolated |
| VII. Performance Engineering | PASS | Paginated lists for debts/goals (ListView.builder + limit/offset); const widgets; no heavy work in build(); lazy-load classification |
| VIII. Product Stability | PASS | Drift explicit migrations for new schema; backward compatibility; safe transaction handling |
| IX. Definition of Done | PASS | All features: implemented, tested, offline, safe data, performant, matches UI/UX design system |

**Pre-design gate: PASSED** — No violations. Extension maintains all constitution compliance.

## Project Structure

### Documentation (this feature)

```text
specs/002-finance-intelligence/
├── plan.md              # This file (implementation plan)
├── spec.md              # Feature specification
├── research.md          # Phase 0: Technology & pattern research (to be created)
├── data-model.md        # Phase 1: Entity definitions & schema (to be created)
├── quickstart.md        # Phase 1: Development setup (to be created)
├── contracts/
│   └── ui-contracts.md  # Phase 1: Screen layouts & navigation (to be created)
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2: Task breakdown (created by /speckit-tasks)
```

### Source Code Structure

**Drift Schema Extensions** (new tables):
```text
chahriyti/lib/infrastructure/database/tables/
├── savings_goals_table.dart          # Goal entity storage
├── debts_table.dart                  # Debt entity storage
├── debt_payments_table.dart          # Payment history per debt
├── weekly_challenges_table.dart       # Challenge definitions (optional feature)
└── financial_insights_table.dart      # Cached insights (trends, leaks, comparisons)
```

**Domain Layer Additions**:
```text
chahriyti/lib/domain/
├── entities/
│   ├── goal_entity.dart              # Freezed: Goal with progress calculation
│   ├── debt_entity.dart              # Freezed: Debt with remaining balance
│   ├── debt_payment_entity.dart       # Freezed: Single payment record
│   ├── challenge_entity.dart          # Freezed: Weekly challenge definition
│   └── insight_entity.dart            # Freezed: Financial insight (trend/leak/comparison)
└── repositories/
    ├── goal_repository.dart           # Interface for goal operations
    ├── debt_repository.dart           # Interface for debt + payment operations
    ├── challenge_repository.dart       # Interface for challenge management
    └── insight_repository.dart         # Interface for insight generation/retrieval
```

**Application Layer Additions**:
```text
chahriyti/lib/application/use_cases/
├── goal/
│   ├── create_goal_use_case.dart
│   ├── update_goal_use_case.dart
│   └── get_goals_use_case.dart
├── debt/
│   ├── create_debt_use_case.dart
│   ├── add_debt_payment_use_case.dart
│   └── get_debts_use_case.dart
├── challenge/
│   ├── generate_weekly_challenge_use_case.dart
│   └── get_active_challenge_use_case.dart
├── classification/
│   └── calculate_financial_classification_use_case.dart
├── insights/
│   ├── detect_financial_leaks_use_case.dart
│   ├── generate_spending_trends_use_case.dart
│   └── generate_comparative_insights_use_case.dart
```

**Infrastructure Layer Additions**:
```text
chahriyti/lib/infrastructure/
├── database/daos/
│   ├── goals_dao.dart
│   ├── debts_dao.dart
│   ├── debt_payments_dao.dart
│   ├── challenges_dao.dart
│   └── insights_dao.dart
└── repositories/
    ├── goal_repository_impl.dart
    ├── debt_repository_impl.dart
    ├── challenge_repository_impl.dart
    └── insight_repository_impl.dart
```

**Presentation Layer Additions**:
```text
chahriyti/lib/presentation/
├── goal/
│   ├── pages/
│   │   ├── goals_list_page.dart
│   │   └── add_goal_page.dart
│   ├── cubits/
│   │   └── goal_cubit.dart
│   └── widgets/
│       ├── goal_card.dart
│       └── progress_bar.dart
├── debt/
│   ├── pages/
│   │   ├── debts_list_page.dart
│   │   ├── add_debt_page.dart
│   │   └── debt_detail_page.dart
│   ├── cubits/
│   │   └── debt_cubit.dart
│   └── widgets/
│       ├── debt_card.dart
│       └── payment_form.dart
├── insights/
│   ├── pages/
│   │   └── insights_page.dart
│   ├── cubits/
│   │   └── insights_cubit.dart
│   └── widgets/
│       ├── leak_card.dart
│       ├── trend_card.dart
│       └── classification_widget.dart
└── shared/
    └── widgets/
        ├── chart_widgets/
        │   ├── progress_bar.dart     # Reusable progress visualization
        │   └── classification_badge.dart
```

**Structure Decision**: Single-project mobile app extension, mirroring existing 001-chahriyti-salary-app architecture. All new code follows established Clean Architecture layers and naming conventions. Features integrate into home screen, settings, and new dedicated pages. No new dependencies introduced beyond `fl_chart` (approved for visualization).

## Implementation Strategy

### MVP Scope (Phase 1: P1 Features)
1. **Goals**: Create, track, view with progress bar
2. **Debts**: Create, track payments, view remaining balance

### Phase 2 Enhancements (P2 Features)
3. **Classification**: Calculated at cycle end, displayed with explanation
4. **Leaks**: Analysis on insights page, showing opportunities to save
5. **Insights**: Spend trends with percentage changes and suggestions

### Phase 3 Optional (P3 Features)
6. **Challenges**: Optional weekly savings goals (enable/disable in settings)
7. **Smart Notifications**: Automatic positive, motivational messages

### Complexity Tracking

No constitution violations. Architecture is straightforward:
- Goals/Debts: Standard CRUD + pagination (existing pattern from expenses)
- Classification: Statistical calculation (done end-of-cycle, not real-time)
- Leaks/Insights: Analysis queries on expense data (read-only, non-blocking)
- Challenges: Optional feature, user-configurable

All features reuse established patterns:
- BloC/Cubit for state management (existing pattern)
- Drift DAOs for data access (existing pattern)
- Paginated lists with ListView.builder (existing pattern)
- Consistent UI widgets from design system (existing pattern)

## Navigation & Integration

**New Routes**:
- `/goals` — Goals list page
- `/goal/add` — Add goal page
- `/goal/:id` — Goal detail page
- `/debts` — Debts list page
- `/debt/add` — Add debt page
- `/debt/:id` — Debt detail & payment page
- `/insights` — Financial insights page (leaks, trends, classification)

**Home Screen Integration**:
- Goals section: Next 3 incomplete goals with progress bars
- Debts section: Total remaining debt + nearest due
- Classification badge: Current classification (Legendary Saver, Smart Saver, etc.)

**Settings Integration**:
- New "Savings Goals" section showing goal count and total target
- New "Debts" section showing active debt count
- Toggle for weekly challenges (optional feature)

## Design System Alignment

All new features follow the established Chahriyti design:

**Colors**: Reuse 6-color palette (teal primary, green positive, red negative, etc.)
**Typography**: Cairo font, existing text styles (headlineSmall, bodyMedium, etc.)
**Components**: Consistent card layouts, button styles, input fields
**Animations**: Smooth transitions, const widgets, no heavy animations blocking UI
**Localization**: Arabic-first UI, RTL layout, Arabic numerals with LTR marks where needed
**Empty States**: Use illustrations for empty goals/debts (from flutter_svg)
**Loading States**: Circular progress indicators matching existing style

## Dependencies & Constraints

**New Dependencies**:
- `fl_chart` (v0.68.0+): Bar/line charts for goal progress, debt tracking, spend trends
  - Justification: Essential for financial visualization; established, stable package
  - Alternative considered: Build custom charts (rejected: too much code for limited ROI)

**No Changes to Existing Stack**: All other dependencies from 001-chahriyti-salary-app remain

**Performance Targets**:
- Goals list: <100ms load, paginated by 20
- Debts list: <100ms load, paginated by 20
- Insights page: <500ms calculations (background), instant display
- Classification: <50ms calculation at cycle end
- Charts: 60 fps rendering with RecordRepaintBoundary

**Data Safety**:
- Goal updates: Atomic in Drift
- Debt payments: Immutable records, no editing/deletion
- Classification: Recalculated fresh at cycle end (no stale data)
- Insights: Cached, refreshed on cycle events
