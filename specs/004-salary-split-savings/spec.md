# Feature Specification: Salary Split to Savings

**Feature Branch**: `004-salary-split-savings`
**Created**: 2026-06-26
**Status**: Draft
**Input**: User description: "we can allow our users to split the balance to add some of it in the savings, so we offer flexibility to our users, for example someone who get paid 60000, he put 20000 to balance and the others on the savings.. so we wanna add this flexibility"

## Clarifications

### Session 2026-06-26

- Q: Can the user undo or modify a salary split after confirming it? → A: No — split is final once confirmed. User can withdraw from savings via existing "pay from savings" mechanisms if they need the money back.
- Q: Should the app remember the last split amount and suggest it as default? → A: No — always default to 0. User starts fresh each cycle. Additionally: savings are lifetime and never reset. Savings balance only changes when the user explicitly pays from them (expense or debt payment). End-of-cycle does not reset or affect existing savings.

## User Scenarios & Testing

### User Story 1 - Split Salary into Balance and Savings (Priority: P1)

When a user receives their salary (at cycle start), they can choose to allocate a portion of their salary directly into savings rather than keeping the full amount as their spending balance. For example, a user earning 60,000 DZD can choose to keep 20,000 DZD as their current cycle balance and deposit 40,000 DZD into savings immediately.

This gives users proactive control over their savings rather than only saving whatever is left at cycle end.

**Why this priority**: This is the core feature — without the ability to split salary, the entire feature has no value. It transforms savings from a passive leftover into an active financial planning tool.

**Independent Test**: User sets up or resets a cycle with salary 60,000 DZD. A split screen appears allowing them to drag a slider or enter an amount. They allocate 40,000 DZD to savings. After confirmation, cycle balance shows 20,000 DZD and savings balance increases by 40,000 DZD.

**Acceptance Scenarios**:

1. **Given** a user starts a new salary cycle with 60,000 DZD, **When** they choose to allocate 40,000 DZD to savings, **Then** the cycle balance is set to 20,000 DZD and savings increases by 40,000 DZD
2. **Given** a user starts a new salary cycle, **When** they choose to keep the full salary as balance (allocate 0 to savings), **Then** the cycle balance equals the full salary and savings is unchanged
3. **Given** a user is on the salary split screen, **When** they adjust the savings amount, **Then** the remaining balance updates in real-time to show the inverse
4. **Given** a user tries to allocate more than their salary to savings, **When** they enter an amount exceeding their salary, **Then** the system prevents this and shows the maximum allowed

---

### User Story 2 - Split Salary on Cycle Reset (Priority: P2)

When a user resets their cycle (starts a new salary period), the salary split option appears as part of the reset flow. The user can choose how much of their new salary goes to savings before the new cycle begins.

**Why this priority**: Cycle reset is the most common entry point for a new salary period. Integrating the split here ensures users encounter the feature at the natural moment.

**Independent Test**: User triggers cycle reset from settings. After confirming the reset, a split screen appears for the new cycle's salary. They allocate a portion to savings, confirm, and the new cycle starts with the reduced balance.

**Acceptance Scenarios**:

1. **Given** a user resets their cycle, **When** the reset completes and a new cycle starts, **Then** a salary split screen is presented before the user returns to the dashboard
2. **Given** a user is on the salary split screen during cycle reset, **When** they skip splitting (keep full salary), **Then** the cycle starts normally with full salary as balance
3. **Given** a user is on the salary split screen during cycle reset, **When** they allocate a portion to savings, **Then** the previous cycle's end-of-cycle deposit (if any) and the new split deposit are both recorded separately in savings history

---

### User Story 3 - Split Salary During Onboarding (Priority: P3)

During the initial onboarding flow when the user first sets up their salary, they are offered the option to split their salary. This introduces users to the savings feature from day one.

**Why this priority**: This is a secondary entry point. Most value comes from the cycle reset flow (US2), but offering it during onboarding ensures new users know about the feature.

**Independent Test**: New user goes through onboarding, enters salary of 50,000 DZD. After salary setup, a split screen appears. They allocate 15,000 DZD to savings. The first cycle starts with 35,000 DZD balance.

**Acceptance Scenarios**:

1. **Given** a new user is completing onboarding and has entered their salary, **When** they proceed past salary setup, **Then** a salary split screen is presented
2. **Given** a new user is on the salary split screen, **When** they skip the split, **Then** onboarding continues normally with full salary as balance
3. **Given** a new user allocates a portion to savings during onboarding, **When** the first cycle is created, **Then** the cycle balance reflects the reduced amount and a savings deposit is recorded

---

### Edge Cases

- What happens if the user sets the savings allocation to the full salary amount (balance becomes 0)?
  - The system allows this but shows a warning: "رصيدك الحالي سيكون 0 دج" (Your current balance will be 0 DZD)
- What happens if the user has additional income added after splitting?
  - Additional income is added to the cycle balance as usual; the split only affects the initial salary allocation
- What happens if the user changes their salary amount in settings after splitting?
  - The salary change applies to the current cycle balance (increases or decreases it), but the savings deposit already made is not reversed
- What happens if there is no existing savings feature (first-time setup)?
  - The savings deposit is the first record in savings history; the feature works identically
- What happens if the user wants to undo a salary split after confirming?
  - The split is final and cannot be undone. The user can withdraw from savings using the existing "pay from savings" feature on expenses or debt payments if they need the money back in their cycle balance

## Requirements

### Functional Requirements

- **FR-001**: System MUST provide a salary split screen that allows users to divide their salary between current balance and savings
- **FR-002**: The salary split screen MUST show the total salary amount, the amount allocated to savings, and the remaining balance — all updating in real-time as the user adjusts
- **FR-003**: Users MUST be able to set the savings allocation using a numeric input field
- **FR-004**: The savings allocation MUST default to 0 (full salary kept as balance) so existing behavior is preserved for users who skip
- **FR-005**: System MUST validate that the savings allocation does not exceed the total salary amount
- **FR-006**: System MUST allow a savings allocation of 0 (no split) up to the full salary amount
- **FR-007**: When a savings allocation is confirmed, the system MUST create a savings deposit record of type "deposit" with the allocated amount
- **FR-008**: When a savings allocation is confirmed, the system MUST set the cycle's effective balance to (salary - savings allocation)
- **FR-009**: The savings deposit description MUST clearly indicate it was a salary split (e.g., "تقسيم الراتب")
- **FR-010**: The salary split screen MUST appear during the cycle reset flow, after the previous cycle is closed and before the new cycle's dashboard is shown
- **FR-011**: The salary split screen MUST appear during onboarding, after the user enters their salary and before the first cycle is created
- **FR-012**: The salary split screen MUST have a clear "skip" option that proceeds without any savings allocation
- **FR-013**: System MUST show a warning when the user allocates the full salary to savings (balance will be 0)
- **FR-014**: The salary split savings deposit MUST be recorded separately from end-of-cycle automatic deposits in savings history
- **FR-015**: The salary split MUST work with the existing savings balance — the deposit adds to any existing savings
- **FR-016**: Once a salary split is confirmed, it MUST be final — no undo or modify option is provided. Users who need funds back can use the existing "pay from savings" withdrawal mechanism
- **FR-017**: Savings are lifetime — the savings balance MUST persist permanently across all cycles and MUST only decrease when the user explicitly pays an expense or debt from savings
- **FR-018**: The salary split screen MUST always default the savings allocation to 0, with no memory of previous cycle's split amount

### Key Entities

- **Salary Split**: A one-time allocation decision made at cycle start, defining how much of the salary goes to savings vs. current balance. Not a persistent setting — decided fresh each cycle.
- **Savings Deposit (split type)**: A savings history record created from a salary split, distinct from end-of-cycle deposits. Uses the existing savings history entity with a descriptive label.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can complete the salary split in under 30 seconds (simple input + confirm)
- **SC-002**: 100% of salary splits result in accurate balance calculation: cycle balance = salary - allocation, savings += allocation
- **SC-003**: Users who skip the split experience zero change to their existing workflow — no additional steps or delays
- **SC-004**: The split screen loads and responds to input changes within 500 milliseconds
- **SC-005**: Savings history correctly distinguishes salary split deposits from end-of-cycle deposits via description

## Assumptions

- The existing savings infrastructure (savings_history table, SavingsRepository, deposit/withdrawal records) is already in place and functional
- The salary split is a per-cycle decision, not a persistent preference — users choose fresh each time a new cycle starts
- The split only applies to the base salary amount, not to additional income added later in the cycle
- The salary split screen follows the same Arabic RTL design patterns and AppColors/AppTypography used throughout the app
- The split does not affect end-of-cycle automatic savings — at cycle end, the remaining balance (from the reduced cycle balance) is still deposited to savings as usual
- Savings are lifetime and never reset — they accumulate across cycles indefinitely and only decrease via explicit user-initiated withdrawals (paying expenses or debts from savings)
