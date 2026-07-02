# Implementation Plan: Lending Tracker (السلف)

**Branch**: `005-lending-tracker` | **Date**: 2026-06-28 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/005-lending-tracker/spec.md`

## Summary

Add a lending tracker feature that allows users to record money lent to other people, track partial repayments (collections), and see outstanding lending amounts on the dashboard. Lending can be funded from the current cycle balance (deducted as a separate category in the balance formula) or from savings (via withdrawal). The feature mirrors the existing debt feature architecture: Drift tables, domain entities, repository, use cases, cubit/state, and three pages (list, add, detail). The dashboard spending card gains a "سلف" breakdown line showing all outstanding lending amounts. The lending list uses tab-based filtering (active vs collected).

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x
**Primary Dependencies**: Drift (ORM), Freezed (immutable models), BLoC/Cubit (state), GoRouter (navigation), google_fonts (Cairo)
**Storage**: SQLite via Drift — schema version 5 → 6 (add Lendings + LendingCollections tables, add relatedLendingId to SavingsHistory)
**Testing**: flutter_test (unit tests)
**Target Platform**: Android / iOS mobile app
**Project Type**: Mobile app (offline-first personal finance tracker)
**Performance Goals**: 60 fps UI, lending list loads < 500ms, form submission < 30s user flow
**Constraints**: Offline-capable, Arabic RTL UI, all amounts are int (centimes), no data loss on crash
**Scale/Scope**: Single user, ~50 screens total, adding 3 new pages + 1 dashboard modification

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First Reliability | PASS | SQLite-only, no network calls |
| II. Testing is Mandatory | PASS | Unit tests planned for use cases and balance formula |
| III. Data Safety | PASS | Drift transactions for multi-table writes (lending + savings withdrawal) |
| IV. Approved Technology Stack | PASS | All dependencies already in use (Drift, Freezed, Cubit, GoRouter) |
| V. Clean Architecture | PASS | Domain → Application → Infrastructure → Presentation layers maintained |
| VI. Separation of Concerns | PASS | One class per file, cubit calls use cases only, no business logic in widgets |
| VII. Performance Engineering | PASS | const widgets, ListView.builder for lending list, no heavy work in build() |
| VIII. Product Stability | PASS | Schema migration v5→v6, backward compatible (new tables + new nullable column) |
| IX. Definition of Done | PASS | Implementation + tests + offline-capable + no data corruption risk |

## Project Structure

### Documentation (this feature)

```text
specs/005-lending-tracker/
├── plan.md              # This file
├── research.md          # Phase 0: codebase pattern research
├── data-model.md        # Phase 1: entity definitions
├── quickstart.md        # Phase 1: integration test scenarios
├── checklists/
│   └── requirements.md  # Specification quality checklist
└── tasks.md             # Phase 2: task breakdown (via /speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti/lib/
├── domain/
│   ├── entities/
│   │   ├── lending_entity.dart              # NEW: Lending freezed entity
│   │   └── lending_collection_entity.dart   # NEW: LendingCollection freezed entity
│   └── repositories/
│       ├── lending_repository.dart          # NEW: Repository interface
│       └── savings_repository.dart          # MODIFIED: add lendingId param to createWithdrawal
│
├── application/use_cases/
│   ├── lending/
│   │   ├── create_lending_use_case.dart     # NEW
│   │   ├── get_lendings_use_case.dart       # NEW
│   │   ├── delete_lending_use_case.dart     # NEW
│   │   └── add_lending_collection_use_case.dart  # NEW
│   ├── dashboard/
│   │   └── get_dashboard_data_use_case.dart # MODIFIED: add totalLendings to formula
│   └── savings/
│       └── withdraw_savings_use_case.dart   # MODIFIED: add lendingId param
│
├── infrastructure/
│   ├── database/
│   │   ├── app_database.dart               # MODIFIED: schema v6, register tables
│   │   ├── tables/
│   │   │   ├── lendings_table.dart          # NEW: Drift table
│   │   │   └── lending_collections_table.dart  # NEW: Drift table
│   │   └── daos/
│   │       └── lendings_dao.dart            # NEW: DAO with queries
│   └── repositories/
│       ├── lending_repository_impl.dart     # NEW
│       └── savings_repository_impl.dart     # MODIFIED: handle lendingId
│
├── presentation/
│   ├── lending/
│   │   ├── cubits/
│   │   │   ├── lending_cubit.dart           # NEW
│   │   │   └── lending_state.dart           # NEW (freezed)
│   │   ├── pages/
│   │   │   ├── lendings_list_page.dart      # NEW: list with active/collected tabs
│   │   │   ├── add_lending_page.dart        # NEW: creation form
│   │   │   └── lending_detail_page.dart     # NEW: detail + collection recording
│   │   └── widgets/
│   │       └── lending_card.dart            # NEW: list item card
│   ├── home/
│   │   ├── widgets/
│   │   │   └── expenses_card.dart           # MODIFIED: add سلف breakdown line
│   │   ├── pages/
│   │   │   └── home_page.dart               # MODIFIED: add lendings section
│   │   └── cubits/
│   │       └── dashboard_cubit.dart         # MODIFIED: fetch lending data
│   └── shared/routing/
│       └── app_router.dart                  # MODIFIED: add lending routes
│
├── core/di/
│   └── injection.dart                       # MODIFIED: register lending DI
│
└── test/unit/lending/
    ├── create_lending_use_case_test.dart     # NEW
    └── balance_formula_with_lending_test.dart # NEW
```

**Structure Decision**: Follows existing Clean Architecture layout. New `lending/` feature module mirrors the `debt/` module. All modifications to existing files are additive (new parameters, new breakdown lines, new DI registrations).

## UX Design Notes

The user requested easy and friendly UX/UI. Key design decisions:

1. **Consistent with existing patterns**: Lending list/add/detail pages mirror the debt pages for familiarity
2. **Tab-based filtering**: Active/collected toggle on the lending list (not a separate page)
3. **PaymentSourceToggle reuse**: Same toggle widget for choosing balance vs savings
4. **Arabic RTL**: All text in Arabic, right-to-left layout, Cairo font
5. **Progress visualization**: Lending cards show a progress bar (collected/total) like debt cards
6. **Simple collection recording**: Dialog-based collection entry (like debt payment dialog)
7. **Dashboard awareness**: "سلف" breakdown line in spending card + lending summary section below debts
8. **Empty states**: Arabic messages ("لا توجد سلف حالياً") with friendly empty illustrations
9. **Confirmation dialogs**: Delete lending requires confirmation (matching debt delete pattern)

## Complexity Tracking

No constitution violations. All patterns reuse existing, proven architecture.
