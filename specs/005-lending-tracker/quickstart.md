# Quickstart: Lending Tracker (السلف)

**Date**: 2026-06-28
**Feature**: 005-lending-tracker

## Integration Test Scenarios

### Scenario 1: Create Lending from Balance

**Setup**: Active cycle with salary 60,000 DZD, no expenses/debts/lendings, salarySplit 0.

**Steps**:
1. Create lending: borrowerName="أحمد", totalAmount=10,000, fromSavings=false
2. Query active lendings
3. Query dashboard data

**Expected**:
- Lending appears in active lendings list with collectedAmount=0, remainingAmount=10,000
- Dashboard balance = 60,000 - 10,000 = 50,000
- Dashboard spending card shows "سلف" = 10,000

### Scenario 2: Create Lending from Savings

**Setup**: Active cycle, savings balance = 50,000 DZD.

**Steps**:
1. Create lending: borrowerName="سارة", totalAmount=15,000, fromSavings=true
2. Query savings balance
3. Query savings history

**Expected**:
- Lending created with fromSavings=true
- Savings balance reduced by 15,000 (now 35,000)
- Savings history contains a withdrawal record linked to the lending (relatedLendingId set)
- Cycle balance is NOT affected (lending from savings doesn't touch balance formula)

### Scenario 3: Partial Collection

**Setup**: Existing lending of 20,000 DZD, collectedAmount=0.

**Steps**:
1. Record collection of 8,000 DZD on the lending
2. Query lending detail
3. Query collection history

**Expected**:
- Lending shows collectedAmount=8,000, remainingAmount=12,000, isFullyCollected=false
- Collection history contains 1 entry: amount=8,000

### Scenario 4: Full Collection

**Setup**: Existing lending of 20,000 DZD, collectedAmount=12,000.

**Steps**:
1. Record collection of 8,000 DZD (remaining amount)
2. Query lending detail

**Expected**:
- Lending shows collectedAmount=20,000, remainingAmount=0, isFullyCollected=true
- Lending moves from active to collected list

### Scenario 5: Collection Exceeds Remaining

**Setup**: Existing lending with remainingAmount=5,000.

**Steps**:
1. Attempt to record collection of 10,000 DZD

**Expected**:
- Operation fails with validation error
- Lending remains unchanged

### Scenario 6: Insufficient Balance for Lending

**Setup**: Active cycle with available balance = 5,000 DZD.

**Steps**:
1. Attempt to create lending of 10,000 DZD from balance

**Expected**:
- Operation fails with insufficient balance error
- No lending created, balance unchanged

### Scenario 7: Delete Lending

**Setup**: Existing lending of 10,000 DZD from balance, with 3,000 collected.

**Steps**:
1. Delete the lending
2. Query active lendings
3. Query dashboard balance

**Expected**:
- Lending removed from list
- Balance is NOT restored (money was physically given)
- Dashboard no longer includes this lending in outstanding total

### Scenario 8: Delete Lending from Savings

**Setup**: Existing lending of 15,000 DZD from savings.

**Steps**:
1. Delete the lending
2. Query savings history

**Expected**:
- Lending removed from list
- Savings withdrawal record remains (money was physically given)

### Scenario 9: Lending Persists Across Cycle Reset

**Setup**: Lending of 20,000 DZD created in cycle 1, with 5,000 collected.

**Steps**:
1. Reset cycle (start cycle 2)
2. Query active lendings
3. Query dashboard

**Expected**:
- Lending still appears in active lendings (it's a lifetime record)
- Dashboard spending card shows outstanding lending amount (15,000)
- New cycle's balance is NOT affected by the old lending

### Scenario 10: Balance Formula with Lending

**Setup**: Cycle with salary=60,000, salarySplit=10,000, income=5,000, expenses=15,000, debtPayments=5,000, lendingsFromBalance=8,000.

**Steps**:
1. Query dashboard data

**Expected**:
- totalIn = 60,000 - 10,000 + 5,000 = 55,000
- currentBalance = 55,000 - 15,000 - 5,000 - 8,000 = 27,000
- Spending card breakdown: مصاريف=15,000, ديون=5,000, سلف=outstanding amount

### Scenario 11: Tab Filtering on List Page

**Setup**: 3 active lendings, 2 fully collected lendings.

**Steps**:
1. Load lending list (default: active tab)
2. Switch to collected tab

**Expected**:
- Active tab shows 3 lendings
- Collected tab shows 2 lendings
- Each lending card shows borrowerName, totalAmount, collectedAmount, remainingAmount, progress bar
