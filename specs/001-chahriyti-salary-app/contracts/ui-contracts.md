# UI Contracts: Chahriyti

**Date**: 2026-06-25

## Screen Inventory

| Screen | Route | Access | Priority |
|--------|-------|--------|----------|
| Splash | `/` | All | P1 |
| Salary Setup | `/onboarding/salary` | First launch | P1 |
| Additional Income | `/onboarding/income` | First launch | P1 |
| Value Proposition | `/onboarding/value` | Pre-activation | P1 |
| Activation | `/activation` | Non-activated | P1 |
| Home Dashboard | `/home` | Activated | P1 |
| Add Expense | `/expense/add` | Activated | P1 |
| Edit Expense | `/expense/edit/:id` | Activated | P1 |
| Expense History | `/history` | Activated | P2 |
| Statistics | `/statistics` | Activated | P2 |
| Add Debt | `/debt/add` | Activated | P2 |
| Debt Detail | `/debt/:id` | Activated | P2 |
| Add Goal | `/goal/add` | Activated | P2 |
| Goal Detail | `/goal/:id` | Activated | P2 |
| Add Income | `/income/add` | Activated | P2 |
| Settings | `/settings` | Activated | P3 |

## Navigation Structure

```
GoRouter:
  /                          → SplashPage (redirect logic)
  /onboarding
    /salary                  → SalarySetupPage
    /income                  → AdditionalIncomePage
    /value                   → ValuePropositionPage
  /activation                → ActivationPage
  /home                      → HomePage (shell route)
  /expense
    /add                     → AddExpensePage
    /edit/:id                → EditExpensePage
  /history                   → ExpenseHistoryPage
  /statistics                → StatisticsPage
  /debt
    /add                     → AddDebtPage
    /:id                     → DebtDetailPage
  /goal
    /add                     → AddGoalPage
    /:id                     → GoalDetailPage
  /income/add                → AddIncomePage
  /settings                  → SettingsPage
```

## Redirect Rules

| Condition | Redirect To |
|-----------|-------------|
| First launch (no user data) | `/onboarding/salary` |
| User data exists but not activated | `/activation` |
| Activated | `/home` |

## Home Dashboard Layout (RTL)

```
┌──────────────────────────────────┐
│        شهريتي (App Bar)          │
├────────────────┬─────────────────┤
│  مصاريف الدورة │   الرصيد الحالي │
│    (Red Card)  │   (Green Card)  │
├────────────────┴─────────────────┤
│  Days Remaining  │  Daily Average │
├──────────────────────────────────┤
│  ████████████░░░░  63% consumed  │
│  Consumption Bar                 │
├──────────────────────────────────┤
│  الرصيد الآمن: 2,000 دج يومياً   │
│  Safe Balance Card               │
├──────────────────────────────────┤
│  الهدف: شراء هاتف  ████░░ 35%   │
│  Goal Progress                   │
├──────────────────────────────────┤
│  الديون (Debts Summary)          │
│  أحمد: 8,000 دج متبقي           │
├──────────────────────────────────┤
│  آخر المصاريف (Recent Expenses)  │
│  ┌─────────────────────────────┐ │
│  │ خبز  │ أكل │ 100 دج │ اليوم│ │
│  │ بنزين │ نقل │ 500 دج │ أمس  │ │
│  └─────────────────────────────┘ │
├──────────────────────────────────┤
│  [📊 إحصائيات]    [➕ صرف]      │
│                    (FAB/Primary) │
└──────────────────────────────────┘
```

## Expense Flow Layout

```
Step 1: Category Selection
┌──────────────────────────────────┐
│  ┌──────────┐  ┌──────────────┐  │
│  │الضروريات │  │المنزل والعائلة│ │
│  └──────────┘  └──────────────┘  │
│  ┌──────────┐  ┌──────────────┐  │
│  │الكماليات │  │    أخرى      │  │
│  └──────────┘  └──────────────┘  │
└──────────────────────────────────┘

Step 2: Subcategory (grid of chips)

Step 3: Input Form
┌──────────────────────────────────┐
│  ماذا اشتريت؟  [_______________]│
│  السعر          [_______________]│
│  ملاحظات        [_______________]│
│                                  │
│  ┌──────────────────────────────┐│
│  │         حفظ                  ││
│  └──────────────────────────────┘│
└──────────────────────────────────┘
```

## Activation Flow Layout

```
┌──────────────────────────────────┐
│        تفعيل التطبيق             │
│     مرحباً بك في شهريتي          │
├──────────────────────────────────┤
│  ① أدخل معلوماتك                │
│  ② أرسل لنا عبر واتساب          │
│  ③ أدخل مفتاح التفعيل           │
├──────────────────────────────────┤
│  رقم شهريتي الخاص بك            │
│  ┌──────────────────────────┐    │
│  │  68E18238-2174-4E2F...  📋│    │
│  └──────────────────────────┘    │
├──────────────────────────────────┤
│  الاسم الكامل  [_______________] │
│  رقم الهاتف   [_______________] │
│  الولاية      [▼ dropdown      ]│
├──────────────────────────────────┤
│  ┌──────────────────────────┐    │
│  │  📱 أرسل عبر واتساب      │    │
│  └──────────────────────────┘    │
│              أو                  │
│  ┌──────────────────────────┐    │
│  │  🔑 لدي مفتاح تفعيل      │    │
│  └──────────────────────────┘    │
└──────────────────────────────────┘

License Key Dialog:
┌──────────────────────────────────┐
│     أدخل مفتاح التفعيل          │
│  الصق مفتاح التفعيل الذي        │
│  أرسلناه لك عبر واتساب          │
│  ┌──────────────────────────┐    │
│  │ CHRY-XXXX-XXXX-XXXX      │    │
│  └──────────────────────────┘    │
│  ┌────────┐  ┌──────────┐       │
│  │ تفعيل  │  │  إلغاء   │       │
│  └────────┘  └──────────┘       │
└──────────────────────────────────┘
```

## Widget State Contracts

### Dashboard Cards

Each card emits one of three states:

| State | Display |
|-------|---------|
| Loading | Shimmer placeholder |
| Loaded | Data with formatted value |
| Empty | Illustration + prompt text |

### Lists (Expenses, Debts, Goals)

| State | Display |
|-------|---------|
| Loading | Skeleton list items |
| Loaded (data) | Paginated list items |
| Loaded (empty) | SVG illustration + title + subtitle + optional CTA |
| Error | Error illustration + retry button |

### Empty State Content

| Screen | Illustration | Title | Subtitle |
|--------|-------------|-------|----------|
| No expenses | Money/wallet illustration | لا توجد مصاريف بعد | ابدأ بتسجيل أول مصروف لك |
| No debts | Checkmark/freedom illustration | لا توجد ديون | أحسنت! أنت خالٍ من الديون |
| No goals | Target illustration | لا توجد أهداف بعد | أنشئ هدفاً مالياً للبدء في الادخار |
| No history | Calendar illustration | لا توجد سجلات | ستظهر هنا مصاريفك المسجلة |
| No stats | Chart illustration | لا توجد بيانات كافية | سجل مصاريفك لمدة أسبوع لرؤية الإحصائيات |
