<!--
Sync Impact Report
==================
- Version change: 1.2.0 → 1.3.0
- MINOR bump: new principle added
- Added principles:
  - VI. Separation of Concerns (STRICT) — new dedicated principle
- Modified principles:
  - VII. Performance Engineering (CRITICAL) — renumbered from VI
  - VIII. Product Stability — renumbered from VII
  - IX. Definition of Done (STRICT) — renumbered from VIII;
    updated to reference Principle VI
- Removed sections: none
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ reviewed; no update needed
  - .specify/templates/spec-template.md — ✅ reviewed, compatible
  - .specify/templates/tasks-template.md — ✅ reviewed, compatible
- Follow-up TODOs: none
-->

# Matla System Constitution

## Core Principles

### I. Offline-First Industrial Reliability

Matla is an offline-first industrial system built for real
garment workshops.

We prioritize:

- Reliability over complexity
- Determinism over experimentation
- Performance over unnecessary abstraction
- Real-world usage over theoretical design

If it does not improve workshop operations, it does not exist.

### II. Testing is Mandatory (NON-NEGOTIABLE)

Testing is not optional. It is part of the feature.

**Testing Layers:**

- **Unit Tests**: Business logic MUST be unit tested
  (stock calculations, production flow transitions, pricing logic)
- **Widget Tests**: Every important UI component MUST be tested
  for correct rendering, state changes, and interactions
- **Integration Tests**: Full workflow testing MUST simulate
  real workshop behavior

**Testing Rules:**

- No feature is considered DONE without tests
- Bugs found in production MUST result in a test being added
- Critical business logic MUST have >80% coverage
- Fixing a bug without adding a regression test is forbidden

### III. Data Safety (NON-NEGOTIABLE)

The system MUST NEVER lose or corrupt data.

We MUST simulate and verify recovery from:

- App crash during write operations
- Power loss scenarios
- Corrupted transaction recovery

### IV. Approved Technology Stack (STRICT)

**Matla Start (Mobile App):**

- Flutter (UI framework)
- Dart (core language)
- Clean Architecture (Architecture — see Principle V for rules)
- Drift (local ORM layer)
- SQLite (local database)
- BloC/Cubit (state management)
- GoRouter (navigation)
- Freezed (immutable models / union types)
- json_serializable (serialization)

**Optional utilities:**

- path_provider (file system access)
- logger (structured logging)

**Stack Rules:**

- No new technology may be introduced without team approval
- Every dependency MUST have a clear business justification
- Experimental or unstable libraries are forbidden in production
- Stability MUST be preferred over novelty

### V. Clean Architecture (STRICT)

All application code MUST follow Clean Architecture. This is not
a suggestion — it is a structural constraint.

**Layer Definitions:**

- **Domain**: Entities, value objects, and repository interfaces.
  MUST have zero dependencies on Flutter, Drift, or any framework.
- **Application**: Use cases (interactors) that orchestrate domain
  logic. MUST depend only on the Domain layer.
- **Infrastructure**: Concrete implementations of repository
  interfaces (Drift DAOs, file storage, etc.). Depends on Domain
  and external libraries.
- **Presentation**: Flutter widgets, BloC/Cubit, and routing.
  Depends on Application use cases only — NEVER on Infrastructure.

**Dependency Rule (NON-NEGOTIABLE):**

Dependencies MUST point inward only:

```
Presentation → Application → Domain ← Infrastructure
```

No inner layer may import from an outer layer.

**Structural Rules:**

- Business logic MUST live in the Domain or Application layer
- BloC/Cubit MUST call use cases — never repositories directly
- Repository interfaces MUST be defined in the Domain layer
- Concrete repositories MUST live in the Infrastructure layer
- Entities MUST be pure Dart classes (no Flutter imports)
- Use cases MUST each represent a single business operation
- Shared UI components belong in Presentation — never in Domain
  or Application

**Rationale:**

Clean Architecture ensures that business logic survives framework
changes, is independently testable, and remains comprehensible
years after the original author has left.

### VI. Separation of Concerns (STRICT)

Every class, file, and module MUST have one clearly defined
responsibility. Mixing concerns is forbidden.

**Responsibility Rules:**

- Widgets MUST NOT contain business logic or state derivation
- BloC/Cubit MUST NOT perform data access — only orchestrate
  use cases and emit UI states
- Use cases MUST NOT know about Flutter widgets or UI state
- Drift DAOs MUST handle data access only — no business rules
- Mappers/converters MUST live in dedicated files — not embedded
  in entities, DAOs, or widgets
- Formatting and display logic belongs in Presentation — never
  in Domain or Application

**Module Rules:**

- One class per file (exceptions require explicit justification)
- No "god classes" that handle multiple unrelated concerns
- No "utility bags" — shared helpers MUST be scoped and named
  by their single purpose
- Feature modules MUST be self-contained — no cross-feature
  direct imports (communicate through use cases or interfaces)

**File Naming:**

Files MUST clearly communicate their responsibility:

- `*_entity.dart` — Domain entities
- `*_repository.dart` — Repository interfaces (Domain)
- `*_use_case.dart` — Application use cases
- `*_repository_impl.dart` — Infrastructure implementations
- `*_dao.dart` — Drift data access objects
- `*_cubit.dart` / `*_bloc.dart` — Presentation state
- `*_state.dart` — BloC/Cubit state definitions
- `*_page.dart` / `*_widget.dart` — UI components

**Rationale:**

Separated concerns make individual components testable in
isolation, reduce cognitive load, and prevent the codebase
from collapsing into an untestable tangle as the system grows.

### VII. Performance Engineering (CRITICAL)

Matla is expected to run for YEARS on the same device.
Performance is a core feature, not an optimization target.

**UI Performance:**

- Use `const` widgets whenever possible
- Use `StatelessWidget` when state is not needed
- Use `Consumer` / `Selector` / `ref.watch(select(...))` for
  granular updates
- NEVER rebuild full screens for small updates
- Split large widgets into smaller components
- NEVER call `setState()` on large parent widgets
- ALWAYS use `ListView.builder` — NEVER use
  `ListView(children: [...])` for large datasets
- Use pagination or lazy loading when needed

**Widget Structure:**

- Avoid deep nesting
- Prefer `Padding`, `Align`, `Center`, `SizedBox` instead of
  multiple `Container` layers

**Rendering:**

- Use `RepaintBoundary` for expensive UI parts
- Prevent unnecessary repaint propagation
- Keep static UI outside animated trees

**Animations:**

- Prefer implicit animations (`AnimatedContainer`,
  `AnimatedOpacity`)
- Use `AnimationController` only when required
- NEVER allow animations to trigger full rebuilds

**Build Method:**

- NEVER perform database calls, heavy computations, or file
  operations inside `build()`
- `build()` MUST remain pure and fast

**Startup:**

- Minimize work in `main()` and `initState()`
- Lazy-load screens and reduce initial dependencies

**Logging:**

- `print()` is forbidden in production
- Use structured logging (info / warning / error)
- Logs MUST NOT affect performance in release mode

### VIII. Product Stability

- The app MUST remain stable for YEARS
- No architecture assumes frequent updates
- SQLite schema backward compatibility is mandatory
- Migrations MUST be safe and reversible

### IX. Definition of Done (STRICT)

A feature is ONLY complete when:

- Implemented
- Tested (unit + UI where needed)
- Validated in real workshop usage
- No performance regressions
- Works offline
- No risk of data corruption
- Complies with Clean Architecture layer rules (Principle V)
- Complies with Separation of Concerns rules (Principle VI)

## Governance

This constitution supersedes all other development practices.
All code changes MUST comply with the principles above.

**Amendment Process:**

- Amendments require documentation of rationale, team approval,
  and a migration plan for existing code
- Version follows semantic versioning (MAJOR.MINOR.PATCH)

**Compliance:**

- All reviews MUST verify compliance with these principles
- Complexity MUST be justified against the constitution
- Use CLAUDE.md for runtime development guidance

**Final Principle:**

> We do not build features.
> We build reliable systems that survive real workshops,
> real workers, and real years of usage.

**Version**: 1.3.0 | **Ratified**: 2026-06-20 | **Last Amended**: 2026-06-25
