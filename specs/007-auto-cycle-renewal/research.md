# Research: Automatic Monthly Cycle Renewal

## Decision 1: Cycle Detection Trigger Point

**Decision**: Check for cycle renewal in the GoRouter `redirect` function on every app launch.

**Rationale**: The redirect already runs async logic (user existence check). Adding a cycle check here is the least invasive hook — it fires before any screen renders, blocking navigation until the cycle state is resolved. No background scheduler needed.

**Alternatives considered**:
- `main()` / `Injection.init()` startup: would work but couples infrastructure to a UI concern (needing to push a route). Rejected.
- Background isolate / WorkManager: overkill for a single-user offline app. Rejected.
- Per-screen check in HomeCubit: too late — user would see stale data before redirect. Rejected.

---

## Decision 2: Cycle Existence Check — "One Per Month"

**Decision**: `getCycleForMonth(int year, int month)` — query cycles where `startDate` falls within the given calendar month. A new cycle is only created if no cycle with a startDate in the current month exists.

**Rationale**: The cycle's `startDate` is always the salary day for that month. Querying by calendar month of `startDate` is both correct and efficient. No schema change needed.

**Alternatives considered**:
- Add a `monthKey` (int, YYYYMM) column to `FinancialCycles`: cleaner query, but requires a DB migration. Rejected for minimal scope.
- Query by `isActive` flag only: wrong — a cycle could have been manually closed before month-end, leaving no active cycle for that month. Rejected.

---

## Decision 3: Short-Month Salary Day Handling

**Decision**: Compute `effectiveSalaryDay = min(salaryDay, daysInMonth)` wherever a salary date is constructed. `DateTime(year, month + 1, 0).day` gives the last day of the month in Dart.

**Rationale**: Dart's `DateTime(year, month, 31)` overflows into the next month silently (e.g., `DateTime(2023, 2, 31)` → March 3). Explicit clamping is mandatory.

**Alternatives considered**:
- Clamp at input (restrict salary day to 1–28): simplest, but loses valid salary days 29/30/31 for most months. Rejected per FR-009.

---

## Decision 4: Salary Day Change — Locking Rule Implementation

**Decision**: `UpdateSalaryDayUseCase` updates only `user.salaryDay`. It never modifies the active cycle's dates. The auto-cycle logic picks up the new salary day when it creates the next cycle naturally.

**Rationale**: "Never retroactively change an already-started cycle" (FR spec). Since `CheckAndStartCycleUseCase` always reads `user.salaryDay` fresh, updating the user record is the single point of truth. No additional locking mechanism required.

**The locking rule is automatically satisfied**: if today ≥ this month's salary day, the current cycle already started. The next auto-cycle will use the new salary day. If today < this month's salary day, the current cycle is from a previous month and won't be touched.

**Alternatives considered**:
- Store `pendingSalaryDay` separately on user: adds complexity with no benefit. Rejected.
- Update `endDate` of current cycle when salary day changes: violates the no-retroactive-change rule. Rejected (and removes the existing `updateCycleSalaryDay` DAO method).

---

## Decision 5: Salary Split Routing for Auto-Cycle

**Decision**: When a new cycle is auto-created, store `cycleId` in `Injection.pendingCycleForSplit`. The router redirects to `/salary-split`. The `SalarySplitPage` route reads from `Injection.pendingCycleForSplit` when `state.extra` is null.

**Rationale**: GoRouter's `redirect` cannot pass `extra` objects. Query params could pass `cycleId` but not the `onComplete` callback. The simplest bridge is a static field on `Injection` that the route builder consumes and clears.

**Alternatives considered**:
- Query params only: can pass `cycleId` and `salaryAmount`, but `onComplete` callback needed for post-split navigation must come from somewhere. Route builder would just navigate to `/home`. Acceptable but less flexible. Could be refactored to use this.
- Shared state object (ChangeNotifier): cleaner, but adds a new dependency for what is a one-shot initialization concern. Rejected.

---

## Decision 6: Remove Manual Reset Button

**Decision**: Remove "إعادة تعيين الدورة" from the Settings page. The cycle lifecycle is now fully automatic.

**Rationale**: Manual reset is superseded by the auto-cycle mechanism. Keeping it would create two code paths for cycle creation, both needing to be correct and tested. Single responsibility wins.

**Alternatives considered**:
- Keep as hidden "emergency" feature: no use case justifies it given auto-cycle handles the same need. Rejected.

---

## Decision 7: DB Schema — No Migration Required

**Decision**: No new columns or tables. `getCycleForMonth` is a pure query addition on the existing `FinancialCycles` table.

**Rationale**: The existing schema (v8) has all needed fields. The new query is expressible in Drift using `isGreaterOrEqualValue`/`isSmallerThanValue` on `startDate`.

**Alternatives considered**:
- Add `monthYear` int column (YYYYMM): would enable index-based lookup. Rejected — query volume is negligible for a single-user app.
