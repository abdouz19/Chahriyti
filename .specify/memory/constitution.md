<!--
Sync Impact Report
==================
- Version change: 0.0.0 → 1.1.0
- This is the initial constitution population (MINOR bump: new principles added)
- Added principles:
  - I. Offline-First Industrial Reliability
  - II. Testing is Mandatory (NON-NEGOTIABLE)
  - III. Data Safety (NON-NEGOTIABLE)
  - IV. Approved Technology Stack (STRICT)
  - V. Performance Engineering (CRITICAL)
  - VI. Product Stability
  - VII. Definition of Done (STRICT)
- Added sections:
  - Performance Engineering Rules (detailed subsections)
  - Product Stability Philosophy
- Removed sections: none (initial population)
- Templates requiring updates:
  - .specify/templates/plan-template.md — ✅ reviewed, Constitution Check
    section is generic and will be filled per-feature; no update needed
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
- Clean Architecture (Architecture)
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

### V. Performance Engineering (CRITICAL)

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

### VI. Product Stability

- The app MUST remain stable for YEARS
- No architecture assumes frequent updates
- SQLite schema backward compatibility is mandatory
- Migrations MUST be safe and reversible

### VII. Definition of Done (STRICT)

A feature is ONLY complete when:

- Implemented
- Tested (unit + UI where needed)
- Validated in real workshop usage
- No performance regressions
- Works offline
- No risk of data corruption

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

**Version**: 1.1.0 | **Ratified**: 2026-06-20 | **Last Amended**: 2026-06-20
