# Feature Specification: Lending Tracker (السلف)

**Feature Branch**: `005-lending-tracker`
**Created**: 2026-06-28
**Status**: Draft
**Input**: User description: "we add a feature of the user will give debt to people, so he can track this type of his money, he can borrow his money from the balance or from the savings, and we can see it it here like we did with the debts"

## Clarifications

### Session 2026-06-28

- Q: Can the user partially collect a lending? → A: Yes — borrowers can repay in installments (partial collections). Users record each payment individually, and the collection history shows every installment.
- Q: Does lending from balance reduce the current cycle balance? → A: Yes — lending from balance works like an expense: it reduces the current cycle balance. Lending from savings works like "pay from savings": it withdraws from savings.
- Q: Should the dashboard show only current-cycle lendings or all outstanding? → A: All outstanding (uncollected) lendings appear on the dashboard regardless of which cycle they were created in, so the user is always aware of money owed to them.
- Q: How should fully collected lendings appear in the list? → A: Filtered — only active (uncollected) lendings shown by default, with a toggle/tab to see fully collected ones.
- Q: Should lending from balance be a separate balance formula category or an expense? → A: Separate category — lending gets its own deduction in the balance formula (like debts have totalDebtPayments), not recorded as an expense.

## User Scenarios & Testing

### User Story 1 - Create a New Lending (Priority: P1)

A user lends money to someone and wants to track it. They go to a lending section, tap "add lending", enter the borrower's name, the amount, and optionally a note. They choose whether to lend from their current balance or from savings. The lending is recorded, and the appropriate source (balance or savings) is reduced.

**Why this priority**: This is the core feature — without the ability to create a lending, nothing else works. It transforms untracked informal loans into visible, managed financial records.

**Independent Test**: User navigates to the lending section, taps add, enters "أحمد" as borrower, 10,000 DZD as amount, selects "from balance". After confirmation, the lending appears in the list, and the dashboard balance is reduced by 10,000 DZD.

**Acceptance Scenarios**:

1. **Given** a user has a cycle balance of 40,000 DZD, **When** they create a lending of 10,000 DZD from balance to "أحمد", **Then** the lending is recorded, the cycle balance decreases to 30,000 DZD, and the lending appears in the lending list
2. **Given** a user has savings of 50,000 DZD, **When** they create a lending of 15,000 DZD from savings to "سارة", **Then** the lending is recorded, savings decrease by 15,000 DZD, and a savings withdrawal is created
3. **Given** a user has a cycle balance of 5,000 DZD, **When** they try to create a lending of 10,000 DZD from balance, **Then** the system prevents the lending and shows an insufficient balance message
4. **Given** a user is creating a lending, **When** they enter 0 or a negative amount, **Then** the system prevents submission and shows a validation error

---

### User Story 2 - View Lending List and Details (Priority: P2)

The user can see all their active lendings in a dedicated list page, similar to the existing debts page. Each lending shows the borrower's name, total amount, amount collected back, and remaining amount. The user can tap a lending to see its full details and collection history.

**Why this priority**: After creating lendings, users need to see and manage them. This is the primary way users monitor their outstanding loans.

**Independent Test**: User has 3 lendings recorded. They navigate to the lending list and see all 3 with borrower names, amounts, and status. Tapping one shows the detail page with collection history.

**Acceptance Scenarios**:

1. **Given** a user has multiple active lendings, **When** they navigate to the lending list, **Then** only active (uncollected) lendings are displayed by default with borrower name, total amount, amount collected, and remaining amount
2. **Given** a user taps on a specific lending, **When** the detail page loads, **Then** it shows the borrower name, total amount, collected amount, remaining amount, creation date, notes, and collection history
3. **Given** a user has no active lendings, **When** they navigate to the lending list, **Then** an empty state message is shown (e.g., "لا توجد سلف حالياً")
4. **Given** a user has fully collected lendings, **When** they toggle to the "collected" view, **Then** the fully collected lendings are displayed

---

### User Story 3 - Collect a Lending Payment (Priority: P3)

When a borrower returns money (partially or fully), the user records a collection. They enter the amount returned. The collection is recorded in the lending's history. When the full amount is collected, the lending is marked as fully collected.

**Why this priority**: Collections complete the lending lifecycle. Without this, lendings would stay open forever and the feature loses its tracking value.

**Independent Test**: User has a lending of 20,000 DZD. They record a collection of 8,000 DZD. The lending now shows 8,000 collected, 12,000 remaining. They record another 12,000. The lending is marked as fully collected.

**Acceptance Scenarios**:

1. **Given** a lending of 20,000 DZD with 0 collected, **When** the user records a collection of 8,000 DZD, **Then** the lending shows 8,000 collected and 12,000 remaining
2. **Given** a lending with 12,000 remaining, **When** the user records a collection of 12,000 DZD, **Then** the lending is marked as fully collected
3. **Given** a lending with 5,000 remaining, **When** the user tries to record a collection of 10,000 DZD, **Then** the system prevents it and shows the maximum collectible amount
4. **Given** a collection is recorded, **When** the user views the lending detail, **Then** the collection appears in the collection history with amount and date

---

### User Story 4 - Dashboard Visibility (Priority: P4)

The total outstanding lending amount is visible on the dashboard, in the "إجمالي الصرف" (Total Spending) card, as a new breakdown line alongside "مصاريف" (expenses) and "ديون" (debts). This gives users a complete picture of where their money has gone.

**Why this priority**: Dashboard visibility is important but depends on the lending data existing first (US1-US3). It adds awareness without requiring new navigation.

**Independent Test**: User has active lendings totaling 30,000 DZD. On the dashboard, the spending card shows the lending total as a separate line item labeled "سلف" alongside expenses and debt payments.

**Acceptance Scenarios**:

1. **Given** a user has active lendings totaling 30,000 DZD, **When** they view the dashboard, **Then** the "إجمالي الصرف" card shows a "سلف" breakdown line with 30,000 DZD
2. **Given** a user has no lendings, **When** they view the dashboard, **Then** no lending line appears in the spending breakdown
3. **Given** a user has lendings, expenses, and debts, **When** they view the dashboard, **Then** all three are shown as breakdown lines and the total reflects all three

---

### User Story 5 - Delete a Lending (Priority: P5)

The user can delete a lending if it was created by mistake. Deleting a lending does not reverse the balance/savings deduction — the money was physically given and cannot be "un-given" via the app. The lending simply stops being tracked.

**Why this priority**: Error correction is necessary but rare. Most users will create lendings correctly. This is a safety net.

**Independent Test**: User has a lending of 10,000 DZD. They delete it. The lending is removed from the list. The balance is not restored (the money was already given).

**Acceptance Scenarios**:

1. **Given** a user has a lending, **When** they choose to delete it and confirm, **Then** the lending is removed from the list
2. **Given** a user attempts to delete a lending, **When** a confirmation dialog appears, **Then** the user must confirm before deletion proceeds
3. **Given** a lending that was funded from savings, **When** it is deleted, **Then** the savings withdrawal record remains (the money was physically given)

---

### Edge Cases

- What happens if the user tries to lend more than their current balance?
  - The system prevents the lending and shows an insufficient balance message, just like expenses
- What happens if the user tries to lend more than their savings balance?
  - The system prevents the lending and shows an insufficient savings message
- What happens if a lending collection amount exceeds the remaining amount?
  - The system prevents it and caps at the remaining amount
- What happens at cycle reset — do active lendings carry over?
  - Yes — lendings are lifetime records, independent of cycles. They persist until fully collected or deleted. The balance deduction happened in the cycle when the lending was created.
- What happens if the user lends from savings but has no savings?
  - The "from savings" option is disabled or grayed out when savings balance is 0, matching the existing expense behavior

## Requirements

### Functional Requirements

- **FR-001**: System MUST provide a lending list page accessible from the main navigation, showing active (uncollected) lendings by default, with a toggle or tab to view fully collected lendings
- **FR-002**: Users MUST be able to create a new lending by specifying: borrower name (required), amount (required, positive integer), and optional notes
- **FR-003**: When creating a lending, users MUST choose the funding source: current cycle balance or savings
- **FR-004**: When a lending is funded from the current balance, the system MUST deduct the amount from the cycle balance as a separate category in the balance formula (like debt payments), not as an expense record
- **FR-005**: When a lending is funded from savings, the system MUST create a savings withdrawal record linked to the lending
- **FR-006**: System MUST validate that the lending amount does not exceed the available balance of the chosen source
- **FR-007**: System MUST provide a lending detail page showing borrower name, total amount, collected amount, remaining amount, creation date, notes, and collection history
- **FR-008**: Users MUST be able to record a collection (money returned by borrower) on a lending, specifying the amount collected
- **FR-009**: System MUST validate that collection amounts do not exceed the remaining lending amount
- **FR-010**: When a lending's collected amount equals its total amount, the system MUST mark it as fully collected
- **FR-011**: The dashboard "إجمالي الصرف" card MUST include a "سلف" (lending) breakdown line showing the total of all outstanding (uncollected) lending amounts, regardless of which cycle they were created in
- **FR-012**: Users MUST be able to delete a lending with a confirmation dialog
- **FR-013**: Deleting a lending MUST NOT reverse the original balance or savings deduction
- **FR-014**: Lendings MUST persist across cycle resets — they are lifetime records, not tied to a specific cycle
- **FR-015**: The lending list MUST show each lending's borrower name, total amount, collected amount, and remaining balance
- **FR-016**: The lending creation form MUST show the "from savings" toggle only when savings balance is greater than 0, matching existing expense/debt payment patterns
- **FR-017**: Collections recorded on a lending MUST NOT affect the cycle balance or savings — they represent money received back and are tracked within the lending only

### Key Entities

- **Lending**: A record of money lent to someone. Key attributes: borrower name, total amount, collected amount, whether fully collected, funding source (balance or savings), creation date, optional notes. Linked to the cycle it was created in.
- **Lending Collection**: A record of money returned by a borrower. Key attributes: amount, date, linked lending ID.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Users can create a lending in under 30 seconds (simple form: name + amount + source + confirm)
- **SC-002**: 100% of lendings from balance result in accurate balance reduction; 100% of lendings from savings result in accurate savings withdrawal
- **SC-003**: The lending list loads and displays all records within 500 milliseconds
- **SC-004**: Dashboard spending card correctly includes lending amounts in the total and breakdown
- **SC-005**: Collection recording correctly updates the remaining amount and marks lendings as fully collected when appropriate

## Assumptions

- The existing savings withdrawal infrastructure (SavingsRepository, WithdrawSavingsUseCase) can be reused for lendings funded from savings
- The lending feature follows the same Arabic RTL design patterns, AppColors, and AppTypography used throughout the app
- Lendings are independent of cycles for persistence, but the balance deduction at creation time is cycle-specific
- The lending list follows the same navigation pattern as the debts list (accessible from dashboard or settings)
- Collections do not go back into the cycle balance or savings — they are tracked within the lending record only (the money comes back as cash in hand, not through the app's balance tracking)
- The "from savings" toggle reuses the existing `PaymentSourceToggle` widget pattern from expenses and debt payments
