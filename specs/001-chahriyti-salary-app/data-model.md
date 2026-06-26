# Data Model: Chahriyti

**Date**: 2026-06-25  
**Spec**: [spec.md](./spec.md)

## Entity Relationship Diagram (Conceptual)

```
User (1) ──── (N) FinancialCycle
                    │
                    ├── (N) Expense
                    ├── (N) AdditionalIncome
                    └── (N) WeeklyChallenge

User (1) ──── (N) Debt
User (1) ──── (N) SavingsGoal
User (1) ──── (1) LicenseActivation
```

## Entities

### User

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| monthly_salary | Integer | > 0, in centimes | Store in centimes to avoid floating point |
| salary_day | Integer | 1–31 | Day of month salary is received |
| full_name | Text | Required | For activation message |
| phone_number | Text | Required | For activation message |
| wilaya_code | Integer | 1–58 | Algerian wilaya |
| is_activated | Boolean | Default: false | License validation status |
| created_at | DateTime | Auto-set | |

**Notes**:
- Single-user app: only one User row exists (id=1)
- All monetary values stored as integers in centimes (1 DZD = 100 centimes) to avoid floating-point issues
- `salary_day` determines cycle boundaries: cycle starts on salary_day of current month, ends day before salary_day of next month

### FinancialCycle

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| start_date | DateTime | Required | Salary reception date |
| end_date | DateTime | Required | Day before next salary |
| salary_amount | Integer | > 0, centimes | Snapshot of salary at cycle start |
| is_active | Boolean | Default: true | Only one active cycle at a time |

**State transitions**:
- `active` → `closed`: When a new cycle starts (next salary date arrives) or user resets
- Historical (closed) cycles are preserved for month-over-month comparison

**Derived fields** (calculated, not stored):
- `total_expenses`: SUM of expenses in this cycle
- `total_additional_income`: SUM of additional income in this cycle
- `total_debt_payments`: SUM of debt payments made during this cycle
- `current_balance`: salary_amount + total_additional_income - total_expenses - total_debt_payments
- `days_remaining`: end_date - today
- `daily_average`: total_expenses / days_elapsed
- `safe_daily_spending`: current_balance / days_remaining
- `consumption_percentage`: (total_expenses / (salary_amount + total_additional_income)) * 100

### Expense

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| cycle_id | Integer | FK → FinancialCycle | |
| category | Text | Enum: essentials, home_family, luxuries, other | Main category |
| subcategory | Text | Enum per category (see below) | |
| item_name | Text | Required, non-empty | What was purchased |
| amount | Integer | > 0, centimes | Price |
| notes | Text | Nullable | Optional notes |
| created_at | DateTime | Auto-set | Timestamp of recording |
| updated_at | DateTime | Auto-set on update | For edit tracking |

**Subcategory enums**:
- `essentials`: food, transport, bills, medicine
- `home_family`: household, children, gifts, other
- `luxuries`: restaurants, coffee, clothing, entertainment
- `other`: other

**Validation rules**:
- Editing/deleting only allowed when `cycle.is_active == true`
- Amount must be positive integer (in centimes)

### AdditionalIncome

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| cycle_id | Integer | FK → FinancialCycle | |
| description | Text | Required | Source description |
| amount | Integer | > 0, centimes | |
| created_at | DateTime | Auto-set | |

### Debt

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| creditor_name | Text | Required | Person owed to |
| total_amount | Integer | > 0, centimes | Original debt amount |
| paid_amount | Integer | >= 0, centimes | Running total of payments |
| is_fully_paid | Boolean | Default: false | |
| created_at | DateTime | Auto-set | |

**Derived fields**:
- `remaining_amount`: total_amount - paid_amount

**Validation rules**:
- Each payment: payment_amount <= user's current_balance
- Each payment: payment_amount <= remaining_amount
- When `paid_amount >= total_amount`: set `is_fully_paid = true`

### DebtPayment

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| debt_id | Integer | FK → Debt | |
| cycle_id | Integer | FK → FinancialCycle | Track which cycle |
| amount | Integer | > 0, centimes | |
| created_at | DateTime | Auto-set | |

**Notes**: Separate table to track payment history and deduct from cycle balance.

### SavingsGoal

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| name | Text | Required | Goal description |
| target_amount | Integer | > 0, centimes | |
| saved_amount | Integer | >= 0, centimes | Running total |
| is_achieved | Boolean | Default: false | |
| created_at | DateTime | Auto-set | |

**Lifecycle**:
- Goals persist across financial cycles (never reset)
- When `saved_amount >= target_amount`: set `is_achieved = true`
- Each contribution: contribution_amount <= user's current_balance
- Contributions deduct from cycle balance (treated like an expense)

### SavingsContribution

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| goal_id | Integer | FK → SavingsGoal | |
| cycle_id | Integer | FK → FinancialCycle | Track which cycle |
| amount | Integer | > 0, centimes | |
| created_at | DateTime | Auto-set | |

### LicenseActivation

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| device_id | Text | Required, unique | SHA-256 of platform device ID |
| license_key | Text | Nullable | Entered by user |
| expiry_date | Text | Nullable | YYYYMM format |
| activated_at | DateTime | Nullable | When activation succeeded |

### WeeklyChallenge

| Field | Type | Constraints | Notes |
|-------|------|-------------|-------|
| id | Integer | PK, auto-increment | |
| cycle_id | Integer | FK → FinancialCycle | |
| week_start | DateTime | Required | Monday of the challenge week |
| target_reduction | Integer | > 0, centimes | Target savings vs. previous week |
| previous_week_spending | Integer | > 0, centimes | Reference baseline |
| is_completed | Boolean | Default: false | Did user meet the target? |

## Category Reference

```
Categories (fixed, not stored in DB — defined as Dart enums):

Essentials (الضروريات)
  ├── Food (أكل)
  ├── Transport (نقل)
  ├── Bills (فواتير)
  └── Medicine (دواء)

Home & Family (المنزل والعائلة)
  ├── Household (مصروف البيت)
  ├── Children (الأولاد)
  ├── Gifts (الهدايا)
  └── Other (أخرى)

Luxuries (الكماليات)
  ├── Restaurants (مطاعم)
  ├── Coffee (قهوة)
  ├── Clothing (ملابس)
  └── Entertainment (ترفيه)

Other (أخرى)
  └── Other (أخرى)
```

## Financial Classification Tiers (Computed)

| Tier | Arabic | Condition |
|------|--------|-----------|
| Legendary Saver | المدخر الأسطوري | savings_ratio > 30% |
| Smart Saver | المدخر الذكي | 15% < savings_ratio <= 30% |
| Balanced | المتوازن | Healthy spending pattern |
| Spender | المبذر | High spending rate |
| Danger | الخطر | Balance likely to reach 0 before cycle end |
| Early Bankrupt | المفلس المبكر | Balance already 0 before cycle end |

`savings_ratio = (salary_amount + total_additional_income - total_expenses) / (salary_amount + total_additional_income) * 100`

## Indexing Strategy

| Table | Index | Purpose |
|-------|-------|---------|
| Expense | `(cycle_id, created_at DESC)` | Paginated expense list per cycle |
| Expense | `(cycle_id, category)` | Category statistics |
| AdditionalIncome | `(cycle_id)` | Sum income per cycle |
| DebtPayment | `(debt_id)` | Payment history per debt |
| DebtPayment | `(cycle_id)` | Cycle balance calculation |
| SavingsContribution | `(goal_id)` | Goal progress |
| SavingsContribution | `(cycle_id)` | Cycle balance calculation |
| FinancialCycle | `(is_active)` | Find active cycle quickly |

## Monetary Value Convention

All monetary values are stored as **integers in centimes** (1 DZD = 100 centimes). This avoids floating-point precision issues in financial calculations. Display layer converts to DZD with proper formatting (e.g., `45,000 دج`).
