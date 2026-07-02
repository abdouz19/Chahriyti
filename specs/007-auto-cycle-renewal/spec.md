# Feature Specification: Automatic Monthly Cycle Renewal

**Feature Branch**: `007-auto-cycle-renewal`
**Created**: 2026-06-30
**Status**: Draft

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Auto Cycle Start on Salary Day (Priority: P1)

When the user opens the app on or after their salary day, a new monthly cycle starts automatically. The spending list resets to zero. The user is immediately prompted to split their incoming salary between spendable balance and savings before they can record any expenses.

**Why this priority**: Core mechanic — everything else depends on cycles being created correctly and automatically.

**Independent Test**: Open the app on salary day with an expired or missing cycle → app detects the condition, creates a new cycle, and presents the salary split screen. Spending history is empty. Debts, lendings, and goals remain untouched.

**Acceptance Scenarios**:

1. **Given** today is the user's salary day and no active cycle exists, **When** the user opens the app, **Then** a new cycle is created automatically, spending list resets, and the salary split prompt appears before the home screen.
2. **Given** today is the user's salary day and the previous cycle is still "active", **When** the user opens the app, **Then** the previous cycle is closed, a new one opens, and the salary split prompt appears.
3. **Given** a new cycle was just created, **When** the user views debts, **Then** all previously recorded debts are still visible.
4. **Given** a new cycle was just created, **When** the user views lendings, **Then** all previously recorded lendings are still visible.
5. **Given** a new cycle was just created, **When** the user views goals, **Then** all previously recorded goals and progress are still visible.

---

### User Story 2 - Salary Split on Cycle Start (Priority: P2)

At the start of each new cycle, the user allocates their salary: a portion goes to the spendable balance and the rest is deposited into savings. The user must complete this split before proceeding to the home screen. The split amounts persist for the duration of the cycle.

**Why this priority**: Without salary allocation, balance and safe-daily calculations are meaningless.

**Independent Test**: Trigger a new cycle → salary split screen appears → user enters amounts → home screen shows correct balance and savings updated.

**Acceptance Scenarios**:

1. **Given** a new cycle has just started, **When** the user allocates 30,000 to balance and 10,000 to savings, **Then** the home screen shows 30,000 as available balance and savings increases by 10,000.
2. **Given** the salary split screen is open, **When** the user enters an allocation where balance + savings ≠ salary, **Then** the system prevents confirmation and shows a clear error.
3. **Given** the salary split screen is open, **When** the user allocates the entire salary to balance (0 to savings), **Then** the system accepts this as a valid split.
4. **Given** the salary split screen is open, **When** the user allocates the entire salary to savings (0 to balance), **Then** the system accepts this as a valid split.

---

### User Story 3 - Salary Day Change Locking Rule (Priority: P3)

The user can change their salary day in settings. If their current month's salary day has already passed (today ≥ current salary day), the change takes effect from the next month's cycle. If the current salary day has not yet occurred this month, the change applies to the current month.

**Why this priority**: Prevents data corruption from retroactive cycle date changes while still giving users flexibility.

**Independent Test**: Set salary day to a future date when today > current salary day → current cycle dates unchanged → next cycle uses new salary day. Set salary day to a future date when today < current salary day → current cycle updates immediately.

**Acceptance Scenarios**:

1. **Given** today is July 4 and current salary day is July 1 (already passed), **When** the user changes salary day to July 6, **Then** the current cycle remains unchanged and the next cycle will start on August 6.
2. **Given** today is July 4 and current salary day is July 10 (not yet passed), **When** the user changes salary day to July 15, **Then** the current cycle end date updates to reflect the new salary day.
3. **Given** a salary day change is scheduled for next month, **When** the next cycle auto-starts, **Then** it uses the newly configured salary day.
4. **Given** the user changes salary day, **When** they view the settings, **Then** the displayed salary day reflects the new value immediately.

---

### Edge Cases

- What happens if the user does not open the app on salary day but opens it 3 days later? → The cycle should still be created for the correct salary day, not today.
- What happens if the user's salary day is the 31st and the current month has only 28/29/30 days? → Use the last day of that month as the effective salary day.
- What happens if the app is opened mid-month with no active cycle and no previous cycle (fresh install)? → Create cycle starting from the most recent past salary day.
- What happens if the user tries to navigate away from the salary split screen without completing it? → Navigation is blocked; split must be completed before accessing any other part of the app.
- What happens if two cycles exist for the same calendar month? → System must prevent duplicate monthly cycles; enforce one cycle per calendar month.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST automatically detect when a new cycle should start (today ≥ salary day and no cycle exists for the current month).
- **FR-002**: System MUST close any previously active cycle and create a new one when cycle start conditions are met.
- **FR-003**: System MUST reset the spending list at the start of each new cycle (no expenses carry over).
- **FR-004**: System MUST preserve all debts, lendings, and savings goals across cycle boundaries — they must remain fully visible and editable in each new cycle.
- **FR-005**: System MUST present the salary split screen immediately when a new cycle starts, blocking access to the home screen until the split is completed.
- **FR-006**: System MUST validate that the sum of balance allocation and savings allocation equals the total salary; reject mismatched splits with a clear message.
- **FR-007**: System MUST apply salary day changes immediately if today < current month's salary day.
- **FR-008**: System MUST defer salary day changes to the next month's cycle if today ≥ current month's salary day.
- **FR-009**: System MUST handle months with fewer days than the configured salary day by using the last valid day of that month (e.g., salary day 31 → February 28/29).
- **FR-010**: System MUST enforce exactly one cycle per calendar month — no duplicate monthly cycles.
- **FR-011**: System MUST backfill a missing cycle from the correct salary day even if the user opens the app days after the salary day has passed.

### Key Entities

- **Financial Cycle**: Represents one monthly period. Has a start date (salary day), an end date (day before next salary day), an active/inactive status, and the salary amount for that period. Exactly one cycle per calendar month.
- **Salary Split**: The allocation decision made at cycle start. Records how much of the salary was allocated to spendable balance versus savings for that cycle.
- **Salary Day Setting**: The user-configured day of the month on which salary arrives. Subject to the locking rule when changed.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: New cycle creation and salary split prompt appear within 2 seconds of the user opening the app on salary day.
- **SC-002**: 100% of expense records from the previous cycle are absent from the new cycle's spending list.
- **SC-003**: 100% of debts, lendings, and goals remain accessible and unmodified after a cycle transition.
- **SC-004**: Salary day change takes effect in the correct cycle in 100% of cases (same month if before salary day, next month if after).
- **SC-005**: The system correctly resolves short-month edge cases (e.g., salary day 31 in February) with no user-visible errors.
- **SC-006**: Users complete the salary split in under 1 minute in the standard flow.

## Assumptions

- The app is a single-user mobile application; no multi-user or server-sync concerns.
- The user has already completed onboarding and has a salary day configured.
- "Spending list resets" means expenses are not deleted but are scoped to a cycle — previous cycle expenses remain accessible in history views.
- The cycle transition check runs every time the app is launched (foreground open), not on a background schedule.
- If the user has never set a salary day (edge case), the app falls back to the existing onboarding flow rather than auto-creating a cycle.
- Additional income entries (non-salary) are also cycle-scoped and reset with each new cycle.
