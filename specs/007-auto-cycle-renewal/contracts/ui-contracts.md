# UI Contracts: Automatic Monthly Cycle Renewal

## Contract 1: App Launch Cycle Gate

**Trigger**: Every app launch (GoRouter redirect fires)  
**Actor**: System (automatic)

### Flow
```
App opens
  → Check user exists + activated (existing)
  → CheckAndStartCycleUseCase.call()
    → returns null     → continue to requested route (no change)
    → returns newCycle → redirect to /salary-split (cycle ID stored in Injection.pendingCycleForSplit)
```

### States exposed to UI
| State | User sees |
|-------|-----------|
| No cycle renewal needed | Normal home screen |
| New cycle created, split pending | Salary split screen (blocking) |

---

## Contract 2: Salary Split Screen (Auto-Cycle Entry)

**Route**: `/salary-split`  
**Entry source**: Auto (router redirect) OR manual (post-onboarding)

### Input
- `cycleId`: int — from `Injection.pendingCycleForSplit` or `state.extra`
- `salaryAmount`: int — from cycle entity
- `onComplete`: `VoidCallback` — navigates to `/home` after split

### States
| State | Display |
|-------|---------|
| Initial | Salary amount shown; balance/savings sliders at default split |
| Validating | Balance + Savings must equal salary; error shown if not |
| Confirmed | Savings updated, cycle.salarySplitAmount written, navigate to home |
| Skipped (if allowed) | salarySplitAmount stays 0; home shown |

### Blocking behaviour
- Navigation back or away is BLOCKED until split is confirmed  
- Back button on this screen is disabled

---

## Contract 3: Settings — Salary Day Change

**Route**: `/settings` → salary day edit  
**Actor**: User

### New Behaviour
- Changing salary day calls `UpdateSalaryDayUseCase`
- The use case updates `user.salaryDay` only (never touches active cycle)
- Settings page shows informational message:
  - If today >= this month's salary day: "سيُطبَّق هذا التغيير ابتداءً من دورة [next month name]"
  - If today < this month's salary day: "سيُطبَّق هذا التغيير في دورتك القادمة هذا الشهر"

### Removed
- "إعادة تعيين الدورة" button → removed entirely

---

## Contract 4: Home Screen — No Active Cycle Guard

**Trigger**: If the user somehow reaches home with no active cycle  
**Display**: Show a prompt to open the app tomorrow (cycle will auto-start on salary day)  
**Fallback**: This state should not occur if Contract 1 is correctly implemented

---

## Contract 5: Cycle History Page

**Unchanged** — displays closed + active cycles in reverse chronological order.  
No changes to this screen.
