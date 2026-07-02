# Research: Lending Tracker (السلف)

**Date**: 2026-06-28
**Feature**: 005-lending-tracker

## Decision 1: Balance Formula Integration

**Decision**: Lending from balance is a separate deduction in the balance formula, not an expense record.

**Rationale**: The existing formula is `balance = salary - salarySplit + income - expenses - debtPayments`. Adding `- totalLendingsFromBalance` keeps lending data independent and avoids polluting expense reports. This mirrors how debt payments have their own `getTotalDebtPaymentsForCycle(cycleId)`.

**Alternatives considered**:
- Creating an expense record labeled "سلف": Rejected because it mixes lending with real expenses in reports and statistics.
- Not affecting balance at all: Rejected because the money physically leaves the user's hands.

**Implementation**: Add `LendingRepository.getTotalLendingsFromBalanceForCycle(cycleId)` returning the sum of `totalAmount` for non-savings lendings in the given cycle. Inject into `GetDashboardDataUseCase`.

## Decision 2: Dashboard Lending Display Scope

**Decision**: The dashboard "إجمالي الصرف" card shows all outstanding (uncollected remaining) lending amounts across all cycles.

**Rationale**: User clarification confirmed that lendings should remain visible in new cycles so the user is always aware of money owed to them. This differs from expenses/debts which are cycle-scoped in the spending card.

**Alternatives considered**:
- Current-cycle only: Rejected per user decision — would hide older outstanding lendings.
- Separate dashboard card for lendings: Rejected — user wants it in the spending breakdown.

**Implementation**: Add `LendingRepository.getTotalOutstandingLendingAmount()` returning the sum of `(totalAmount - collectedAmount)` for all non-fully-collected lendings. Pass to `ExpensesCard` as a new parameter.

## Decision 3: Fully Collected Lending Visibility

**Decision**: The lending list shows only active (uncollected) lendings by default, with a tab/toggle to view fully collected ones.

**Rationale**: User chose filtered view (option C) to keep the active list clean while still allowing access to history.

**Alternatives considered**:
- All together with status indicator: Simpler but clutters the list.
- Separated sections on same page: More complex layout.

**Implementation**: `LendingsListPage` with two tabs: "نشطة" (active) and "تم التحصيل" (collected). `GetLendingsUseCase` provides `getActiveLendings()` and `getCollectedLendings()`.

## Decision 4: Savings Withdrawal Linkage

**Decision**: Add `relatedLendingId` nullable column to `SavingsHistory` table and entity, following the existing `relatedExpenseId` / `relatedDebtPaymentId` pattern.

**Rationale**: The existing pattern links savings withdrawals back to their source via nullable foreign keys. Lending follows the same pattern for consistency and to support deletion cleanup.

**Alternatives considered**:
- Separate savings transaction type for lending: Rejected — withdrawal is withdrawal regardless of source, and the existing enum (`deposit`/`withdrawal`) is sufficient.

**Implementation**:
- Add `int? relatedLendingId` to `SavingsHistoryEntity`
- Add `IntColumn get relatedLendingId => integer().nullable()()` to `SavingsHistory` Drift table
- Add `lendingId` param to `SavingsRepository.createWithdrawal()`
- Add `deleteWithdrawalByLendingId()` and `updateWithdrawalAmountByLendingId()` to `SavingsRepository`
- Add `int? lendingId` param to `WithdrawSavingsUseCase.call()`
- Migration v5→v6: `m.addColumn(savingsHistory, savingsHistory.relatedLendingId)`

## Decision 5: Collection Does Not Affect Balance

**Decision**: Collections (money returned by borrower) are tracked within the lending record only and do NOT affect cycle balance or savings.

**Rationale**: Per FR-017, the money comes back as "cash in hand." The app tracks where money went, not physical cash. Collections update `collectedAmount` on the lending and create a `LendingCollection` history record.

**Alternatives considered**:
- Add collections as income: Rejected — it would inflate income figures and misrepresent earnings.
- Return money to savings: Rejected — the money was lent from balance/savings but comes back as cash.

## Decision 6: Lending Entity Tracks Funding Source and Cycle

**Decision**: The `LendingEntity` stores `fromSavings` (bool) and `cycleId` (int) to track the funding source and originating cycle.

**Rationale**: 
- `fromSavings`: Needed to know whether balance formula should deduct this lending (only non-savings lendings affect balance).
- `cycleId`: Needed for `getTotalLendingsFromBalanceForCycle(cycleId)` query. Also provides historical context.

## Decision 7: Navigation and Dashboard Section

**Decision**: Lending list is accessible from a dashboard section (below debts) and via routes `/lendings`, `/lending/add`, `/lending/:id`.

**Rationale**: Mirrors the debt navigation pattern. Dashboard section provides quick access and awareness of outstanding lendings. The section shows a `LendingSummaryCard` with total outstanding amount and count, tapping navigates to `/lendings`.

## Decision 8: UX Approach (User-Requested Priority)

**Decision**: Follow existing debt UI patterns exactly for consistency, with these UX enhancements:
- Clean, minimal forms with only essential fields (borrower name, amount, optional notes)
- PaymentSourceToggle for balance/savings choice (hidden when savings = 0)
- Progress bar on lending cards showing collection progress
- Tab-based active/collected filtering on list page
- Dialog-based collection recording on detail page
- Arabic RTL throughout with AppColors/AppTypography design system
- Confirmation dialog before deletion
- Empty state messages in Arabic
