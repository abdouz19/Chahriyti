# Data Model: Onboarding Financial Setup Wizard

**Branch**: `008-onboarding-setup-wizard` | **Date**: 2026-07-06

## Entity Changes

### UserEntity (modified)

Existing entity with new fields for financial setup tracking.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| id | int | Yes | Primary key (existing) |
| fullName | String | Yes | User's name (existing) |
| phoneNumber | String | Yes | Phone (existing) |
| wilayaCode | String | Yes | Location code (existing) |
| salary | double | Yes | Monthly salary (existing) |
| isActivated | bool | Yes | License verified (existing) |
| **initialBalance** | **double?** | **No** | **Money user has at onboarding (bank + cash). Null until wizard balance step completed.** |
| **hasCompletedFinancialSetup** | **bool** | **Yes** | **Defaults false. True after wizard confirmation. Controls routing.** |
| **financialSetupStep** | **int?** | **No** | **Last completed wizard step (0-5). Null = not started. Used for resume on app restart.** |

### DebtEntity (unchanged)

Used as-is. Wizard creates entries via existing repository.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Primary key |
| creditorName | String | Who user owes |
| totalAmount | double | Total debt |
| paidAmount | double | Initialized to 0 during wizard |
| isFullyPaid | bool | false during wizard |
| createdAt | DateTime | Set when added in wizard |
| notes | String? | Optional |

### LendingEntity (unchanged)

Used as-is. Wizard creates entries via existing repository.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Primary key |
| borrowerName | String | Who owes user |
| totalAmount | double | Total lent |
| collectedAmount | double | Initialized to 0 during wizard |
| isFullyCollected | bool | false during wizard |
| fromSavings | bool | false during wizard |
| savingsAmount | double | 0 during wizard |
| createdAt | DateTime | Set when added in wizard |
| notes | String? | Optional |

### SavingsHistoryEntity (unchanged)

Used as-is. Wizard creates an initial deposit entry.

| Field | Type | Description |
|-------|------|-------------|
| id | int | Primary key |
| type | SavingsTransactionType | "deposit" for wizard entry |
| amount | double | Initial savings amount |
| createdAt | DateTime | Set during wizard |
| relatedCycleId | int? | Null initially — linked when first cycle created |

## Database Schema Changes

### Users Table (Drift migration)

```
ALTER TABLE users ADD COLUMN initial_balance REAL;
ALTER TABLE users ADD COLUMN has_completed_financial_setup INTEGER NOT NULL DEFAULT 0;
ALTER TABLE users ADD COLUMN financial_setup_step INTEGER;
```

## State Transitions

### Wizard Step Flow

```
Step 0: Welcome        → User taps "Start"
Step 1: Balance Input   → User enters amount, taps "Next"
Step 2: Savings Input   → User enters amount or taps "Skip"
Step 3: Debts Input     → User adds debts or taps "Skip"
Step 4: Lendings Input  → User adds lendings or taps "Skip"
Step 5: Summary         → User reviews and taps "Confirm"
→ hasCompletedFinancialSetup = true
→ financialSetupStep = null (cleanup)
→ Redirect to salary onboarding
```

### Progress Save Points

Each step saves `financialSetupStep` to database on completion:
- Step 0 completed → `financialSetupStep = 1` (resume at balance)
- Step 1 completed → `financialSetupStep = 2` (resume at savings)
- Step 2 completed → `financialSetupStep = 3` (resume at debts)
- Step 3 completed → `financialSetupStep = 4` (resume at lendings)
- Step 4 completed → `financialSetupStep = 5` (resume at summary)
- Step 5 confirmed → `hasCompletedFinancialSetup = true`, `financialSetupStep = null`

## Relationships

```
User (1) ──── (0..n) Debt         [existing relationship, populated during wizard]
User (1) ──── (0..n) Lending      [existing relationship, populated during wizard]
User (1) ──── (0..n) SavingsHistory [existing relationship, initial deposit from wizard]
```

## Validation Rules

| Entity | Field | Rule |
|--------|-------|------|
| User | initialBalance | Must be >= 0. Null only before wizard. |
| Debt | creditorName | Non-empty string, trimmed |
| Debt | totalAmount | Must be > 0 |
| Lending | borrowerName | Non-empty string, trimmed |
| Lending | totalAmount | Must be > 0 |
| SavingsHistory | amount | Must be > 0 (skip creates no entry) |
