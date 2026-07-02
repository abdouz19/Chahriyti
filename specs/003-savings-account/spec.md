# Feature Specification: Savings Account (المدخرات)

**Feature Branch**: `003-savings-account`  
**Created**: 2026-06-26  
**Status**: Draft  
**Input**: Two "accounts" — current balance from salary cycle and accumulated savings from previous cycles, with ability to pay expenses/debts from either account.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automatic Savings on Cycle End (Priority: P1)

When a salary cycle ends and a new one begins, the system automatically calculates the unspent balance from the ending cycle. If the remaining balance is positive, it is deposited into the user's savings account. The user sees this reflected in their savings total without any manual action.

**Why this priority**: This is the foundation of the entire savings feature. Without automatic deposits, there are no savings to spend from or view. Every other story depends on savings existing.

**Independent Test**: Can be fully tested by completing a salary cycle with unspent balance and verifying a deposit record appears in savings history with the correct amount.

**Acceptance Scenarios**:

1. **Given** a cycle ends with a positive balance of 4,400 DZD, **When** the new cycle begins, **Then** a savings deposit of 4,400 DZD is automatically created and the savings total increases by 4,400 DZD.
2. **Given** a cycle ends with a zero balance, **When** the new cycle begins, **Then** no savings deposit is created.
3. **Given** a cycle ends with a negative balance (expenses exceeded income), **When** the new cycle begins, **Then** no savings deposit is created (balance treated as 0, no negative deposit).
4. **Given** a cycle ends with a positive balance, **When** the deposit is created, **Then** the savings history shows a deposit entry with the cycle name, date, and amount.

---

### User Story 2 - Pay Expense from Savings (Priority: P2)

When recording an expense, the user can choose to pay from their savings instead of the current cycle balance. A simple toggle shows "ادفع من" with two options: "الرصيد الحالي" (default) and "المدخرات". Each option displays the available amount.

**Why this priority**: This is the primary use case for savings — allowing users to tap into saved money for expenses without affecting their current cycle budget. It delivers the core "two accounts" experience.

**Independent Test**: Can be tested by having savings > 0, adding an expense with "from savings" selected, and verifying the expense is recorded, savings balance decreases, and current cycle balance remains unchanged.

**Acceptance Scenarios**:

1. **Given** the user has 10,000 DZD in savings and is adding an expense of 2,000 DZD, **When** they select "المدخرات" as the payment source, **Then** the expense is recorded, a savings withdrawal of 2,000 DZD is created, and the current cycle balance is unchanged.
2. **Given** the user has 500 DZD in savings and tries to pay an expense of 1,000 DZD from savings, **When** they select "المدخرات", **Then** the system prevents the payment and shows the available savings amount.
3. **Given** the user pays an expense from savings, **When** they view the expense history, **Then** the expense appears normally in the list (statistics and history stay accurate).
4. **Given** the user is adding an expense, **When** the payment source toggle appears, **Then** each option shows the available amount (current balance or savings balance).
5. **Given** the user has 0 DZD in savings and is adding an expense, **When** the expense form loads, **Then** the payment source toggle is not shown (expense is charged to current balance by default).

---

### User Story 3 - Pay Debt from Savings (Priority: P3)

When making a debt payment, the user can choose to pay from savings using the same toggle mechanism as expenses. This allows users to use saved money to pay down debts.

**Why this priority**: Same mechanism as expense payment but applied to debts. Lower priority because debt payments are less frequent than expenses, and the toggle mechanism is already established in P2.

**Independent Test**: Can be tested by having savings > 0 and an active debt, making a payment with "from savings" selected, and verifying the debt balance decreases, savings decrease, and cycle balance is unchanged.

**Acceptance Scenarios**:

1. **Given** the user has 5,000 DZD in savings and a debt of 3,000 DZD, **When** they make a full payment from savings, **Then** the debt is marked as paid, savings decrease by 3,000 DZD, and current cycle balance is unchanged.
2. **Given** the user has 1,000 DZD in savings and tries to pay a debt of 2,000 DZD from savings, **When** they attempt the payment, **Then** the system prevents it and shows the available savings amount.
3. **Given** the user pays a debt from savings, **When** they view the debt history, **Then** the payment appears normally (debt tracking stays accurate).

---

### User Story 4 - View Savings History (Priority: P4)

The user can access a savings screen from Settings (الإعدادات > المدخرات) that shows their total savings amount at the top and a chronological history of all deposits and withdrawals below.

**Why this priority**: This is a visibility/transparency feature. The savings system works without it (users can see totals elsewhere), but it builds trust by showing where money came from and went.

**Independent Test**: Can be tested by navigating to Settings > المدخرات and verifying the total is displayed correctly with deposit entries (green) and withdrawal entries (red) showing dates and descriptions.

**Acceptance Scenarios**:

1. **Given** the user has savings history with deposits and withdrawals, **When** they navigate to Settings > المدخرات, **Then** they see the total savings amount prominently displayed at the top.
2. **Given** the savings history contains entries, **When** the user views the history list, **Then** deposits appear in green with positive amounts and withdrawals appear in red with negative amounts, each with date and description.
3. **Given** the user has no savings history, **When** they navigate to the savings screen, **Then** they see 0 DZD total and an empty state message.

---

### Edge Cases

- What happens when the user has exactly enough savings to cover a payment? — Payment proceeds normally, savings balance becomes 0.
- What happens if multiple withdrawals occur rapidly? — Each withdrawal checks the current savings balance before proceeding; insufficient funds are rejected.
- What happens when a cycle ends but there are pending debt payments from savings in that cycle? — All transactions are finalized before the cycle-end savings calculation; only the truly unspent amount is deposited.
- What happens if the app is closed during cycle transition? — The savings deposit is calculated and created the next time the app detects the cycle has ended.
- What happens when a savings-funded expense or debt payment is deleted or edited? — The corresponding savings withdrawal is automatically reversed, restoring the amount to the savings balance.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST automatically calculate the remaining balance when a salary cycle ends.
- **FR-002**: System MUST create a savings deposit record when a cycle ends with a positive remaining balance.
- **FR-003**: System MUST NOT create a savings deposit when the cycle ends with zero or negative remaining balance.
- **FR-004**: System MUST track the total savings balance as the sum of all deposits minus all withdrawals.
- **FR-005**: System MUST display a payment source toggle ("ادفع من") when the user is recording an expense, only if the savings balance is greater than 0.
- **FR-006**: System MUST display a payment source toggle ("ادفع من") when the user is making a debt payment, only if the savings balance is greater than 0.
- **FR-007**: The payment source toggle MUST show two options: "الرصيد الحالي" (default) and "المدخرات".
- **FR-008**: Each payment source option MUST display the currently available amount.
- **FR-009**: System MUST prevent payments from savings that exceed the available savings balance.
- **FR-010**: When an expense is paid from savings, the system MUST record the expense normally for statistics and history.
- **FR-011**: When an expense is paid from savings, the system MUST create a withdrawal record in savings history.
- **FR-012**: When an expense is paid from savings, the system MUST exclude that expense from the current cycle balance calculation.
- **FR-013**: When a debt payment is made from savings, the system MUST record the payment normally for debt tracking.
- **FR-014**: When a debt payment is made from savings, the system MUST create a withdrawal record in savings history.
- **FR-015**: When a debt payment is made from savings, the system MUST exclude that payment from the current cycle balance calculation.
- **FR-016**: Current balance formula MUST be: salary + income - expenses(not from savings) - debt payments(not from savings).
- **FR-017**: Savings balance formula MUST be: sum(cycle-end deposits) - sum(withdrawals).
- **FR-018**: System MUST provide a savings screen accessible from Settings showing total savings and history.
- **FR-019**: Savings history MUST display deposits (green, positive) and withdrawals (red, negative) with dates and descriptions.
- **FR-020**: System MUST NOT allow manual deposit or withdrawal — all savings transactions occur automatically through normal app flow.
- **FR-021**: When a savings-funded expense or debt payment is deleted, the system MUST automatically reverse the corresponding savings withdrawal, restoring the amount to the savings balance.
- **FR-022**: When a savings-funded expense or debt payment is edited (amount changed), the system MUST adjust the corresponding savings withdrawal to match the new amount.

### Key Entities

- **Savings History Record**: Represents a single savings transaction. Key attributes: type (deposit or withdrawal), amount, date, description (e.g., cycle name for deposits, expense/debt description for withdrawals), and a reference to the related cycle or expense/debt payment.
- **Expense / Debt Payment (extended)**: Existing entities gain a "from savings" flag indicating the payment source. This flag determines whether the transaction affects the current cycle balance or the savings balance.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can view their savings balance within 1 tap from the settings screen.
- **SC-002**: 100% of cycle-end positive balances result in automatic savings deposits with no user intervention.
- **SC-003**: Users can switch payment source (current balance vs. savings) in under 2 seconds during expense or debt payment entry.
- **SC-004**: All expenses and debt payments paid from savings appear correctly in statistics and history, maintaining data accuracy.
- **SC-005**: Users cannot overdraw their savings — 100% of overpayment attempts from savings are blocked with a clear message.
- **SC-006**: Savings history screen loads and displays all records within 1 second.
- **SC-007**: Current cycle balance calculation excludes all savings-funded transactions, ensuring the two "accounts" remain independent.

## Clarifications

### Session 2026-06-26

- Q: What happens when a user deletes or edits an expense/debt payment that was paid from savings? → A: Automatically restore savings — the corresponding withdrawal is reversed when the transaction is deleted or edited.
- Q: Should the payment source toggle appear when savings balance is 0? → A: Hide the toggle entirely when savings is 0; it appears only once savings > 0.
- Q: How should savings balance appear on the home dashboard? → A: No home dashboard display — savings is accessible only via Settings > المدخرات.

## Assumptions

- The existing cycle management system handles cycle-end detection; the savings deposit hooks into this existing mechanism.
- Savings are stored locally on-device, consistent with the app's current offline-first architecture.
- There is no interest, profit, or growth applied to savings — it is a simple balance of deposits and withdrawals.
- The savings total is not displayed on the home dashboard; it is accessible exclusively via Settings > المدخرات.
- Currency is always DZD (Algerian Dinar) with no decimal places, consistent with existing app behavior.
- The "from savings" flag is a simple boolean on expense/debt payment records — no partial payments (split between current balance and savings) in the initial version.
