# Feature Specification: Onboarding Financial Setup Wizard

**Feature Branch**: `008-onboarding-setup-wizard`  
**Created**: 2026-07-06  
**Status**: Draft  
**Input**: User description: "Post-verification onboarding wizard to collect user's real financial situation — balance, savings, debts, and lendings — so the app starts with accurate data"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Enter Current Balance (Priority: P1)

A first-time user who just completed verification opens the app. They see a guided wizard that asks how much money they currently have (bank + cash). They enter their total balance and move to the next step.

**Why this priority**: Balance is the foundational number — every other financial feature depends on knowing what the user has right now. Without it, the app cannot provide any meaningful tracking.

**Independent Test**: Can be fully tested by completing the balance step alone and verifying the amount is saved and visible on the dashboard.

**Acceptance Scenarios**:

1. **Given** a verified user opens the app for the first time, **When** they land on the wizard, **Then** they see a welcome screen explaining the setup process with a "Start" button and a progress indicator.
2. **Given** the user is on the balance step, **When** they enter an amount and tap "Next", **Then** the balance is saved and they advance to the next step.
3. **Given** the user is on the balance step, **When** they enter 0 or leave it empty, **Then** the system accepts 0 as a valid balance and allows them to proceed.

---

### User Story 2 - Enter Savings (Priority: P2)

The user reaches the savings step and enters how much money they have set aside for future use (emergency fund, goals, etc.). This step is skippable if the user has no savings.

**Why this priority**: Savings represent money the user has but has earmarked — it affects available spending money calculations and savings tracking features.

**Independent Test**: Can be tested by entering a savings amount and verifying it appears correctly in the savings section of the app.

**Acceptance Scenarios**:

1. **Given** the user completed the balance step, **When** they reach the savings step, **Then** they see a clear prompt asking about money saved for the future with helpful context.
2. **Given** the user has no savings, **When** they tap "Skip", **Then** savings is recorded as 0 and they advance to the next step.
3. **Given** the user enters a savings amount, **When** they tap "Next", **Then** the amount is saved and they advance.

---

### User Story 3 - Add Debts (Priority: P2)

The user reaches the debts step and can add one or more debts. For each debt, they provide the creditor name (person or company) and the total amount owed. This step is skippable.

**Why this priority**: Debts impact the user's true financial picture. Knowing who they owe and how much enables debt tracking and repayment features from day one.

**Independent Test**: Can be tested by adding multiple debts and verifying each appears in the debts section with correct name and amount.

**Acceptance Scenarios**:

1. **Given** the user is on the debts step, **When** there are no debts added yet, **Then** they see an empty state with an "Add first debt" button and a "Skip" option.
2. **Given** the user taps "Add first debt" or "Add another", **When** a form appears, **Then** it contains two fields: name/company and amount owed.
3. **Given** the user has added one or more debts, **When** they view the debts step, **Then** they see a list of cards showing each debt (creditor name and amount).
4. **Given** the user taps on an existing debt card, **When** the edit form opens, **Then** they can modify or delete that debt entry.
5. **Given** the user has no debts, **When** they tap "Skip", **Then** no debts are recorded and they advance.

---

### User Story 4 - Add Lendings (Priority: P3)

The user reaches the lendings step and can add money they have lent to others. For each lending, they provide the borrower's name and the amount owed to them. This step is skippable.

**Why this priority**: Lendings are less common than debts but still important for a complete financial picture. Many users may skip this step.

**Independent Test**: Can be tested by adding lendings and verifying each appears in the lendings section with correct borrower name and amount.

**Acceptance Scenarios**:

1. **Given** the user is on the lendings step, **When** there are no lendings added yet, **Then** they see an empty state with an "Add" button and a "Skip" option.
2. **Given** the user adds a lending, **When** they provide a borrower name and amount, **Then** the lending is saved and shown in a card list.
3. **Given** the user taps on an existing lending card, **When** the edit form opens, **Then** they can modify or delete that lending entry.
4. **Given** the user has no lendings, **When** they tap "Skip", **Then** no lendings are recorded and they advance to the summary.

---

### User Story 5 - Review and Confirm Summary (Priority: P2)

After completing all steps, the user sees a summary of everything they entered: balance, savings, all debts, and all lendings. They can edit any section before confirming.

**Why this priority**: Prevents data entry mistakes. Gives users confidence that their financial snapshot is accurate before starting to use the app.

**Independent Test**: Can be tested by completing all wizard steps and verifying the summary displays all entered data correctly, and that tapping "Edit" on any section returns to that step.

**Acceptance Scenarios**:

1. **Given** the user completed all wizard steps, **When** they reach the summary screen, **Then** they see all entered values organized by category (balance, savings, debts list, lendings list).
2. **Given** the user spots an error on the summary, **When** they tap "Edit" next to a category, **Then** they return to that specific step to make corrections.
3. **Given** the user is satisfied with the summary, **When** they tap "Confirm & Start", **Then** all data is saved and they are redirected to the main dashboard.

---

### User Story 6 - Navigate Back Through Wizard (Priority: P3)

At any step in the wizard, the user can go back to the previous step to review or change their input. Previously entered data is preserved.

**Why this priority**: Users make mistakes or change their mind. Back navigation prevents frustration and data loss.

**Independent Test**: Can be tested by entering data in step 3, going back to step 2, then returning to step 3 and verifying original step 3 data is still there.

**Acceptance Scenarios**:

1. **Given** the user is on any step after the welcome screen, **When** they tap the back arrow, **Then** they return to the previous step with their previously entered data intact.
2. **Given** the user navigates back and changes a value, **When** they proceed forward again, **Then** the updated value is preserved.

---

### Edge Cases

- What happens when the user closes the app mid-wizard? The wizard resumes from the last completed step on next app open.
- What happens when the user enters extremely large numbers? The system accepts them but displays them in a readable format (e.g., formatted with thousand separators).
- What happens when the user adds a debt/lending with an empty name? The system requires a name before saving — inline validation message shown.
- What happens when the user adds a debt/lending with amount 0? The system requires a positive amount — inline validation message shown.
- What happens when the user has already completed onboarding and opens the app again? They go directly to the dashboard; the wizard does not reappear.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a step-by-step wizard after the user completes verification for the first time.
- **FR-002**: System MUST show a visual progress indicator (progress bar) throughout the wizard showing current step out of total steps.
- **FR-003**: System MUST collect the user's current total balance (bank + cash) as a numeric value.
- **FR-004**: System MUST collect the user's current savings amount, with the option to skip (defaults to 0).
- **FR-005**: System MUST allow users to add multiple debts, each with a creditor name (text) and total amount owed (positive number).
- **FR-006**: System MUST allow users to add multiple lendings, each with a borrower name (text) and total amount lent (positive number).
- **FR-007**: System MUST allow users to edit or delete individual debt/lending entries during the wizard.
- **FR-008**: System MUST display a summary of all entered data before final confirmation.
- **FR-009**: System MUST allow users to navigate back to any previous step from the summary to make edits.
- **FR-010**: System MUST persist wizard progress so that if the app is closed mid-wizard, the user resumes from the last completed step.
- **FR-011**: System MUST redirect the user to the main dashboard after successful wizard completion.
- **FR-012**: System MUST NOT show the wizard again after it has been completed — subsequent app opens go directly to the dashboard.
- **FR-013**: System MUST use plain, non-technical language throughout the wizard (e.g., "How much money do you have right now?" not "Enter your liquidity").
- **FR-014**: System MUST validate that debt/lending entries have a non-empty name and a positive amount before saving.
- **FR-015**: System MUST allow the debts step and lendings step to be skipped entirely if the user has none.

### Key Entities

- **Balance**: The user's total available money across all sources (bank accounts, cash, wallet). A single numeric value.
- **Savings**: Money the user has set aside for future use. A single numeric value, defaults to 0 if skipped.
- **Debt**: Money the user owes to someone. Each debt has a creditor name and a total amount owed. A user can have zero or many debts.
- **Lending**: Money someone owes to the user. Each lending has a borrower name and a total amount lent. A user can have zero or many lendings.
- **Onboarding Status**: Tracks whether the user has completed the financial setup wizard. Determines routing (wizard vs. dashboard).

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 90% of first-time users complete the wizard without abandoning mid-flow.
- **SC-002**: Users complete the full wizard in under 3 minutes on average.
- **SC-003**: 100% of users who complete the wizard have at least their balance recorded (no empty/null balance post-onboarding).
- **SC-004**: Users who complete the wizard engage with debt/lending tracking features 2x more than users who manually add data later.
- **SC-005**: Zero users see the wizard a second time after completing it (no accidental re-triggers).

## Assumptions

- Users have already completed account creation and verification (activation) before encountering this wizard.
- The existing onboarding flow (salary, salary split, additional income) remains in place — this wizard either extends it or runs as a separate post-activation step.
- Currency is consistent with the user's profile settings (Algerian Dinar assumed based on existing app context).
- Users have a general idea of their financial situation (approximate balance, who they owe/are owed) — exact-to-the-cent accuracy is not expected.
- The app already has the ability to store debts and lendings — this wizard provides the initial data entry point for these existing features.
- Mobile-first experience — wizard is designed for phone screens with touch interaction.
