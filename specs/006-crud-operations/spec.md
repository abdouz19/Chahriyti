# Feature Specification: Full CRUD Operations for Financial Records

**Feature Branch**: `006-crud-operations`  
**Created**: 2026-06-29  
**Status**: Draft  
**Input**: User description: "we should provide high quality user experience, we should allow our users to edit/delete/cancel operations, so the user find our mobile app flexible, for the financial goals/debts/lendings/spent"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Edit an Expense (Priority: P1)

A user recorded an expense with the wrong amount or category and needs to correct it without deleting and re-entering everything.

**Why this priority**: Mistakes in data entry are the most frequent user action needing correction. Blocking edits forces deletion + re-entry, damaging trust and data integrity.

**Independent Test**: Tap an existing expense → tap Edit → change amount/category/note → save → expense appears with updated values on the list and dashboard.

**Acceptance Scenarios**:

1. **Given** a recorded expense exists, **When** the user opens it and taps Edit, **Then** a pre-filled form with all current values appears.
2. **Given** the edit form is open, **When** the user changes the amount and saves, **Then** the expense is updated and all balance calculations reflect the new amount immediately.
3. **Given** the edit form is open, **When** the user taps Cancel, **Then** no changes are saved and the user returns to the previous screen.

---

### User Story 2 - Delete an Expense (Priority: P1)

A user recorded a duplicate or erroneous expense and wants to remove it entirely.

**Why this priority**: Without delete, users accumulate phantom entries that distort their financial picture. Deleting is the most basic data control.

**Independent Test**: Long-press or open expense → tap Delete → confirm → expense disappears from list and balance recalculates.

**Acceptance Scenarios**:

1. **Given** a recorded expense exists, **When** the user chooses Delete, **Then** a confirmation dialog appears before deletion.
2. **Given** the confirmation dialog is shown, **When** the user confirms, **Then** the expense is permanently removed and dashboard totals update instantly.
3. **Given** the confirmation dialog is shown, **When** the user cancels, **Then** the expense remains unchanged.

---

### User Story 3 - Edit a Financial Goal (Priority: P2)

A user's circumstances change (e.g., target amount, deadline) and they need to update an existing savings goal.

**Why this priority**: Goals are long-lived records. Life changes require goal adjustments; immutable goals lead to abandonment.

**Independent Test**: Open goals list → tap a goal → tap Edit → change name/target amount/deadline → save → goal card reflects new values.

**Acceptance Scenarios**:

1. **Given** a savings goal exists, **When** the user taps Edit, **Then** a pre-filled form with current goal values appears.
2. **Given** the edit form is open, **When** the user changes the target amount and saves, **Then** the progress percentage recalculates against the new target.
3. **Given** the edit form is open, **When** the user taps Cancel, **Then** no changes are saved.

---

### User Story 4 - Delete a Financial Goal (Priority: P2)

A user has completed or abandoned a goal and wants to remove it from the app.

**Why this priority**: Goals accumulate over time; completed/abandoned goals clutter the UI and confuse the user.

**Independent Test**: Open goal → tap Delete → confirm → goal removed from goals list.

**Acceptance Scenarios**:

1. **Given** a goal exists, **When** the user chooses Delete and confirms, **Then** the goal is permanently removed.
2. **Given** a goal has associated savings contributions, **When** the user deletes it, **Then** the system preserves the contributed savings balance (funds not lost).
3. **Given** the delete confirmation is shown, **When** the user cancels, **Then** the goal remains.

---

### User Story 5 - Edit a Debt Record (Priority: P2)

A user entered incorrect debt details (creditor name, total amount, due date) and needs to correct them.

**Why this priority**: Debt records affect remaining balance calculations. Wrong data leads to wrong financial decisions.

**Independent Test**: Open debts list → tap a debt → tap Edit → update field → save → debt card shows updated values.

**Acceptance Scenarios**:

1. **Given** a debt record exists, **When** the user taps Edit, **Then** all current debt fields are pre-filled and editable.
2. **Given** the edit form is open, **When** the user saves, **Then** remaining balance recalculates based on updated total.
3. **Given** the edit form is open, **When** the user taps Cancel, **Then** no changes are saved.

---

### User Story 6 - Delete a Debt Record (Priority: P2)

A debt was fully paid outside the app or entered by mistake and the user wants to remove it.

**Why this priority**: Paid-off or erroneous debts inflate reported obligations and reduce available balance incorrectly.

**Independent Test**: Open debt → Delete → confirm → debt removed, balance updates.

**Acceptance Scenarios**:

1. **Given** a debt exists, **When** the user deletes it and confirms, **Then** it is permanently removed and balance formula excludes it.
2. **Given** the delete confirmation is shown, **When** the user cancels, **Then** the debt remains unchanged.

---

### User Story 7 - Edit a Lending Record (Priority: P3)

A user entered the wrong borrower name or amount for a lending record.

**Why this priority**: Lending records are less frequently wrong than expenses, but errors still affect outstanding balance tracking.

**Independent Test**: Open lendings list → tap a lending → Edit → change name/amount → save → lending card updated.

**Acceptance Scenarios**:

1. **Given** a lending record exists, **When** the user taps Edit, **Then** a pre-filled edit form appears.
2. **Given** the edit form is open, **When** the user saves changes, **Then** outstanding lending totals recalculate.
3. **Given** the edit form is open, **When** the user cancels, **Then** no changes are saved.

---

### User Story 8 - Delete a Lending Record (Priority: P3)

A lending was fully collected outside the app or entered by mistake.

**Why this priority**: Stale lending records inflate the outstanding lending amount shown on dashboard.

**Independent Test**: Open lending → Delete → confirm → lending removed, dashboard lending total updates.

**Acceptance Scenarios**:

1. **Given** a lending exists, **When** the user deletes it and confirms, **Then** it is permanently removed and dashboard recalculates.
2. **Given** the delete confirmation is shown, **When** the user cancels, **Then** the lending remains.

---

### Edge Cases

- What happens when a user tries to edit an expense from a previous (closed) financial cycle? — Edit is blocked with a clear message; only current-cycle records are editable.
- What happens when a goal is deleted that has contributions already recorded? — Contributions remain in savings balance; only the goal target is removed.
- What happens when network/storage fails mid-save during an edit? — Changes are not partially applied; original record is preserved and an error message is shown.
- How does the system handle deleting a debt that has payment history? — All associated payment records are also deleted together with the debt.
- What happens when a user deletes a lending that has partial collections recorded? — All associated collection records are also deleted.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Users MUST be able to edit any expense recorded in the current financial cycle, with all fields pre-filled from the existing record.
- **FR-002**: Users MUST be able to delete any expense from the current financial cycle after confirming intent.
- **FR-003**: Users MUST be able to edit any financial goal (name, target amount, deadline).
- **FR-004**: Users MUST be able to delete any financial goal; associated savings contributions are preserved in the savings balance.
- **FR-005**: Users MUST be able to edit any debt record (creditor name, total amount, due date, notes).
- **FR-006**: Users MUST be able to delete any debt record; all associated payment records are removed together.
- **FR-007**: Users MUST be able to edit any lending record (borrower name, amount, notes).
- **FR-008**: Users MUST be able to delete any lending record; all associated collection records are removed together.
- **FR-009**: All destructive actions (delete) MUST require explicit user confirmation via a dialog before executing.
- **FR-010**: All edit forms MUST provide a Cancel action that discards changes and returns the user to the previous screen.
- **FR-011**: All balance-affecting changes (edit/delete) MUST immediately reflect in dashboard totals and balances without requiring a manual refresh.
- **FR-012**: Editing or deleting a record from a previous (closed) financial cycle MUST be blocked, with a clear explanatory message.
- **FR-013**: Edit operations MUST be atomic — either all changes are saved or none are (no partial updates on failure).

### Key Entities *(include if feature involves data)*

- **Expense**: A spending record with amount, category, subcategory, note, and date; belongs to a financial cycle.
- **Financial Goal**: A savings target with name, target amount, deadline, and linked contributions.
- **Debt**: An amount owed to a creditor with total amount, due date, and associated payment records.
- **Lending**: An amount lent to a borrower with total amount, date, and associated collection records.
- **Financial Cycle**: The active budget period; only current-cycle records are mutable.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete an edit operation (open record → change field → save) in under 30 seconds.
- **SC-002**: Users can complete a delete operation (open record → confirm delete) in under 15 seconds.
- **SC-003**: Dashboard totals update within 1 second of completing any edit or delete action.
- **SC-004**: 100% of delete actions show a confirmation dialog before executing — no accidental deletions.
- **SC-005**: Edit forms pre-fill all existing values correctly in 100% of cases — no blank or wrong pre-filled data.
- **SC-006**: 0% data loss on failed save — original record intact if edit fails mid-operation.
- **SC-007**: Users rate the edit/delete experience 4+ stars in in-app feedback (qualitative goal).

## Assumptions

- All four entity types (expenses, goals, debts, lendings) get edit and delete capability in the same feature release.
- Only records from the **current active financial cycle** are editable for expenses; goals, debts, and lendings are editable regardless of cycle.
- The existing confirmation dialog widget is reused for all delete confirmations (no new dialog design needed).
- Edit forms reuse the existing add forms (add_expense_page, add_debt_page, add_lending_page, add_goal_page) pre-populated with existing data.
- Savings contributions linked to deleted goals are retained in the savings balance (not reversed).
- Debt payment records and lending collection records are cascade-deleted when their parent record is deleted.
- The app is offline-first; all edits and deletes execute against local SQLite storage with no network calls.
- Arabic RTL UI conventions apply to all new edit/delete UI elements.
