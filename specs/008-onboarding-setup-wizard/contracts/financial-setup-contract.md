# UI Contract: Financial Setup Wizard

**Branch**: `008-onboarding-setup-wizard` | **Date**: 2026-07-06

## Screen Flow

```
/financial-setup (route)
├── WelcomeStep         → "Set Up Your Finances"
├── BalanceStep          → "How much money do you have right now?"
├── SavingsStep          → "Money saved for future?"
├── DebtsStep            → "Who do you owe money to?"
├── LendingsStep         → "Who owes you money?"
└── SummaryStep          → Review all values → Confirm
```

## Cubit ↔ UI Contract

### States (sealed class hierarchy)

```
FinancialSetupState
├── FinancialSetupWelcome
├── FinancialSetupBalance(double? currentBalance)
├── FinancialSetupSavings(double? currentSavings)
├── FinancialSetupDebts(List<DebtEntry> debts)
├── FinancialSetupLendings(List<LendingEntry> lendings)
├── FinancialSetupSummary(SetupSummaryData data)
├── FinancialSetupCompleted
├── FinancialSetupError(String message)
└── FinancialSetupLoading
```

### Cubit Methods

| Method | Input | Effect | Emits |
|--------|-------|--------|-------|
| `start()` | — | Initialize wizard | `FinancialSetupBalance` |
| `setBalance(double)` | amount >= 0 | Save balance to user | `FinancialSetupSavings` |
| `setSavings(double)` | amount >= 0 | Create savings deposit | `FinancialSetupDebts` |
| `skipSavings()` | — | No deposit created | `FinancialSetupDebts` |
| `addDebt(String, double)` | name, amount | Create debt entity | `FinancialSetupDebts` (updated list) |
| `editDebt(int, String, double)` | id, name, amount | Update debt entity | `FinancialSetupDebts` (updated list) |
| `deleteDebt(int)` | id | Remove debt entity | `FinancialSetupDebts` (updated list) |
| `nextFromDebts()` | — | Proceed past debts | `FinancialSetupLendings` |
| `addLending(String, double)` | name, amount | Create lending entity | `FinancialSetupLendings` (updated list) |
| `editLending(int, String, double)` | id, name, amount | Update lending entity | `FinancialSetupLendings` (updated list) |
| `deleteLending(int)` | id | Remove lending entity | `FinancialSetupLendings` (updated list) |
| `nextFromLendings()` | — | Proceed past lendings | `FinancialSetupSummary` |
| `goBack()` | — | Previous step | Previous state with preserved data |
| `editFromSummary(int step)` | step number | Jump to specific step | That step's state with current data |
| `confirm()` | — | Finalize setup | `FinancialSetupCompleted` |

### Data Transfer Objects

```
SetupSummaryData {
  double balance;
  double savings;
  List<DebtEntry> debts;
  List<LendingEntry> lendings;
}

DebtEntry {
  int? id;          // null if not yet saved
  String name;
  double amount;
}

LendingEntry {
  int? id;          // null if not yet saved
  String name;
  double amount;
}
```

## Widget Structure

```
FinancialSetupPage (BlocProvider + BlocBuilder)
├── WelcomeStepWidget
│   ├── Title text
│   ├── Subtitle text
│   └── StartButton
├── BalanceStepWidget
│   ├── ProgressBar (2/6)
│   ├── Prompt text + help text
│   ├── AmountInputField (currency-formatted)
│   └── NextButton
├── SavingsStepWidget
│   ├── ProgressBar (3/6)
│   ├── Prompt text + help text
│   ├── AmountInputField
│   └── SkipButton | NextButton
├── DebtsStepWidget
│   ├── ProgressBar (4/6)
│   ├── Prompt text
│   ├── DebtCardList (scrollable)
│   │   └── DebtCard (name + amount, tap to edit)
│   ├── AddDebtButton → DebtFormBottomSheet(name, amount)
│   └── SkipButton | NextButton
├── LendingsStepWidget
│   ├── ProgressBar (5/6)
│   ├── Prompt text
│   ├── LendingCardList (scrollable)
│   │   └── LendingCard (name + amount, tap to edit)
│   ├── AddLendingButton → LendingFormBottomSheet(name, amount)
│   └── SkipButton | NextButton
└── SummaryStepWidget
    ├── ProgressBar (6/6)
    ├── BalanceSummaryCard (with edit button)
    ├── SavingsSummaryCard (with edit button)
    ├── DebtsSummaryCard (list, with edit button)
    ├── LendingsSummaryCard (list, with edit button)
    └── ConfirmButton
```

## Navigation Contract

| From | Action | To | Route |
|------|--------|----|-------|
| Activation complete | Auto-redirect (router guard) | `/financial-setup` | Guard: `!hasCompletedFinancialSetup` |
| Financial setup complete | Auto-redirect | `/onboarding` (salary) | Existing flow |
| App restart mid-wizard | Auto-redirect + resume | `/financial-setup` (resume step) | `financialSetupStep` field |

## Validation UX

| Field | Validation | Error Message |
|-------|-----------|---------------|
| Balance | >= 0, required | "Please enter your current balance" |
| Savings | >= 0 | "Please enter a valid amount" |
| Debt name | Non-empty | "Please enter a name" |
| Debt amount | > 0 | "Amount must be greater than 0" |
| Lending name | Non-empty | "Please enter a name" |
| Lending amount | > 0 | "Amount must be greater than 0" |
