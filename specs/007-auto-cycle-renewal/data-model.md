# Data Model: Automatic Monthly Cycle Renewal

## Existing Entities (Unchanged)

### FinancialCycleEntity
```
id            int         PK
startDate     DateTime    Salary day this month (cycle open date)
endDate       DateTime    Day before next salary day (cycle close date)
salaryAmount  int         Gross salary for this cycle
salarySplitAmount int     Amount sent to savings at cycle start (0 until split done)
isActive      bool        True for the one currently-open cycle
```

**Invariants**:
- Exactly one active cycle at any point in time (`isActive = true`)
- Exactly one cycle per calendar month (startDate's year+month is unique)
- `salarySplitAmount = 0` means the salary split has not been done yet for this cycle
- `salarySplitAmount > 0` means the user already completed the split

### UserEntity (field used by this feature)
```
salaryDay  int   Day of month salary arrives (1–31, clamped to month's actual days)
```

---

## New Query: getCycleForMonth

Not a schema change — a DAO query addition.

**Input**: `year: int`, `month: int`  
**Output**: `FinancialCycleRow?`  
**Logic**: Returns the cycle whose `startDate` falls within the given calendar month.  
**Used by**: `CheckAndStartCycleUseCase`

---

## Derived Values (computed, not stored)

### Effective Salary Day
```
effectiveSalaryDay(salaryDay, year, month) =
  min(salaryDay, lastDayOfMonth(year, month))
```
Where `lastDayOfMonth(year, month) = DateTime(year, month+1, 0).day`

Applied when computing `startDate` and `endDate` for new cycles.

### Cycle Start Date for a given (year, month, salaryDay)
```
startDate = DateTime(year, month, effectiveSalaryDay(salaryDay, year, month))
```

### Cycle End Date
```
endDate = startDate of next cycle - 1 day
       = DateTime(year, month+1, effectiveSalaryDay(salaryDay, year, month+1)) - 1 day
```

### New Cycle Needed?
```
today >= effectiveSalaryDate(this month) 
  AND getCycleForMonth(this year, this month) IS NULL
```

---

## State Transitions

```
[No cycle / cycle for prev month]
        │
        │ App launch on or after salary day
        ▼
[New cycle created, salarySplitAmount = 0]
        │
        │ User completes salary split
        ▼
[Cycle active, salarySplitAmount > 0]
        │
        │ App launch on next salary day
        ▼
[Previous cycle closed (isActive = false), new cycle created]
        │ (loop)
```

---

## Cross-Cycle Persistence

These entities are NOT scoped to a cycle and persist unchanged:

| Entity | Persists across cycles |
|--------|----------------------|
| Debts | Yes — linked by debtId, not cycleId |
| DebtPayments | Yes — linked to Debts |
| Lendings | Yes — linked by lendingId |
| LendingCollections | Yes — linked to Lendings |
| SavingsGoals | Yes — not cycle-scoped |
| SavingsContributions | Yes — cumulative |

These entities ARE cycle-scoped and reset with each new cycle:

| Entity | Scoped to cycle |
|--------|----------------|
| Expenses | Yes — filtered by cycleId |
| AdditionalIncomes | Yes — filtered by cycleId |
| WeeklyChallenges | Yes — week-based, implicitly cycle-aligned |
