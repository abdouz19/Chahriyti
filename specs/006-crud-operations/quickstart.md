# Quickstart: Full CRUD Operations Integration Scenarios

**Feature**: `006-crud-operations` | **Date**: 2026-06-29

## Scenario 1: Edit an Expense

**Pre-condition**: At least one expense in the current cycle exists.

**Flow**:
1. Home page → Recent Expenses list → long-press expense item
2. Context menu appears: "تعديل" / "حذف"
3. Tap "تعديل" → `EditExpensePage` opens with form pre-filled
4. Change amount from 500 to 450 → tap "حفظ"
5. Home page balance updates from (income - 500) to (income - 450)

**Verification**: Expense in recent list shows 450. Dashboard total expenses decreases by 50.

---

## Scenario 2: Delete an Expense (funded from savings)

**Pre-condition**: One expense with `fromSavings=true` exists.

**Flow**:
1. Home page → Recent Expenses → long-press the savings-funded expense
2. Tap "حذف" → ConfirmationDialog appears ("هل تريد حذف هذا المصروف؟")
3. Tap "نعم" → expense deleted + savings withdrawal reversed
4. Dashboard: savings balance increases by deleted amount; expense total decreases

**Verification**: Savings history no longer shows the withdrawal. Savings balance restored.

---

## Scenario 3: Edit a Debt

**Pre-condition**: At least one active debt exists.

**Flow**:
1. Debts list → tap debt card → Debt Detail page
2. Tap edit icon (AppBar trailing action)
3. `AddDebtPage` opens in edit mode with current values pre-filled
4. Change `totalAmount` from 10000 to 12000 → tap "حفظ"
5. Debt detail page reloads: remaining balance = 12000 - payments made

**Verification**: Debt card shows new total. Remaining balance recalculates correctly.

---

## Scenario 4: Delete a Debt (with payments)

**Pre-condition**: One debt has 2 payment records (one from savings).

**Flow**:
1. Debt Detail → tap "حذف" button
2. ConfirmationDialog: "سيتم حذف الدين وجميع المدفوعات المرتبطة به. هل تريد المتابعة؟"
3. Tap "نعم"
4. Debt + payments cascade-deleted. Savings withdrawal for savings-funded payment is reversed.

**Verification**: Debt gone from list. Savings balance restored for any savings-funded payments.

---

## Scenario 5: Edit a Lending

**Pre-condition**: One active lending with borrowerName "أحمد".

**Flow**:
1. Lendings list → tap lending card → Lending Detail page
2. Tap edit icon in AppBar
3. `AddLendingPage` opens in edit mode with "أحمد" pre-filled
4. Change notes, tap "حفظ"
5. Lending detail refreshes with updated notes

**Verification**: Lending card shows updated notes. Amount unchanged.

---

## Scenario 6: Edit a Goal

**Pre-condition**: One savings goal "سيارة" with target 500,000.

**Flow**:
1. Goals list → tap goal card → Goal Detail page
2. Tap edit icon
3. `AddGoalPage` opens in edit mode, "سيارة" and 500,000 pre-filled
4. Change target to 600,000 → tap "حفظ"
5. Goal progress bar recalculates: contributed / 600,000

**Verification**: Goal card shows new target. Progress percentage decreases.

---

## Scenario 7: Delete Additional Income

**Pre-condition**: Additional income entry "مكافأة" with `toSavings=false` exists.

**Flow**:
1. Income list (accessible via settings or income page) → long-press "مكافأة"
2. Tap "حذف" → ConfirmationDialog
3. Tap "نعم" → income deleted
4. Dashboard: total cycle income decreases by income amount

**Verification**: Income no longer in list. Available cycle balance decreases.

---

## Scenario 8: Delete Additional Income blocked (toSavings=true)

**Pre-condition**: Additional income with `toSavings=true` exists.

**Flow**:
1. Long-press income → tap "حذف"
2. System shows error snackbar: "لا يمكن حذف دخل محوّل للمدخرات. قم بسحب المبلغ من المدخرات يدوياً."
3. Income remains unchanged.

**Verification**: Income still in list. No change to savings or cycle balance.

---

## Cancel Flows (all entities)

| Scenario | Action | Result |
|----------|--------|--------|
| Edit form → tap Cancel | Back button or "إلغاء" | No changes saved, previous screen restored |
| Delete confirmation → tap "إلغاء" | ConfirmationDialog cancel button | Record unchanged, dialog dismissed |
| Edit form → tap Back | Android back / iOS swipe | Same as Cancel — no changes saved |

---

## Error Flows

| Error | User sees |
|-------|-----------|
| Edit expense from closed cycle | Snackbar: "لا يمكن تعديل مصروف من دورة سابقة" |
| Edit lending with reduced totalAmount < collectedAmount | Snackbar: "المبلغ الجديد أقل من المبلغ المسترد" |
| Delete income with toSavings=true | Snackbar: "لا يمكن حذف دخل محوّل للمدخرات" |
| Any storage failure mid-save | Snackbar: "حدث خطأ. لم يتم حفظ التغييرات." |
