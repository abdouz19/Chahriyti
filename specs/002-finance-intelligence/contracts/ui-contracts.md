# Phase 1 UI/UX Contracts: Screen Layouts & Navigation

**Date**: 2026-06-26  
**Purpose**: Define screen layouts, interactions, and visual patterns for financial intelligence features

---

## Design System Reference

All screens follow the established Chahriyti design:

**Color Palette**:
- Primary: Teal (#008B8B)
- Success: Green (#4CAF50)
- Warning: Orange (#FF9800)
- Danger: Red (#F44336)
- Background: White (#FFFFFF)
- Text Primary: Charcoal (#333333)
- Text Secondary: Gray (#666666)
- Divider: Light Gray (#EEEEEE)

**Typography**:
- Headlines: Cairo font, 20px, bold
- Body: Cairo font, 14px, regular
- Labels: Cairo font, 12px, medium

**Spacing**: 4px, 8px, 12px, 16px, 20px, 24px (8px base unit)

**Corner Radius**: 12px (medium cards), 8px (small elements), 16px (large containers)

---

## Navigation Structure

```
Home Screen
├── Goals Section (3 items preview)
├── Debts Section (total + closest due)
└── Classification Badge

Main Navigation (Bottom Tab)
├── Home
├── Statistics
├── Insights (NEW)
├── Settings
└── More

Settings Screen
├── Profile
├── Goals & Debts Section (NEW)
├── Weekly Challenges Toggle (NEW)
└── Other settings
```

---

## Screen Contracts

### 1. Home Screen - Goals Section (Integration)

**Location**: Home page, below Recent Expenses section  
**State**: Loading | Loaded | Empty | Error

**Layout (Loaded State)**:
```
┌─────────────────────────────────┐
│ الأهداف المالية                 │ (Goals)
│ ────────────────────────────────│
│                                 │
│ ┌────────────────────────────┐ │
│ │ [Icon] شراء هاتف جديد        │ │
│ │       80,000 دج              │ │
│ │ ████████░░░░░░░░░ 35%      │ │ (Progress bar)
│ │ 28,000 دج من 80,000         │ │
│ └────────────────────────────┘ │
│                                 │
│ ┌────────────────────────────┐ │
│ │ [Icon] رحلة العطلة          │ │
│ │       150,000 دج             │ │
│ │ ██░░░░░░░░░░░░░░░░ 8%      │ │
│ │ 12,000 دج من 150,000        │ │
│ └────────────────────────────┘ │
│                                 │
│ [عرض جميع الأهداف]              │ (View all link)
└─────────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────────┐
│ الأهداف المالية                 │
│ ────────────────────────────────│
│                                 │
│          📊                      │
│    لا توجد أهداف بعد            │
│    (No goals yet)                │
│                                 │
│     [+ أضف هدفاً جديداً]         │
│     (+ Add Goal)                 │
│                                 │
└─────────────────────────────────┘
```

**Interactions**:
- Tap goal card → Navigate to `/goal/:id`
- Tap "عرض جميع الأهداف" → Navigate to `/goals`
- Tap "+ أضف هدفاً" → Navigate to `/goal/add`
- Swipe right (in list) → Delete goal (with confirmation)

**Data Binding**:
- Goal card displays: icon, name, target amount, progress bar, progress percentage, saved amount
- Progress bar color: Teal (primary)
- Progress text: "28,000 من 80,000" (formatted as Money)

---

### 2. Home Screen - Debts Section (Integration)

**Location**: Home page, below Goals section  
**State**: Loading | Loaded | Empty | Error

**Layout (Loaded State)**:
```
┌─────────────────────────────────┐
│ الديون والالتزامات              │ (Debts)
│ ────────────────────────────────│
│ إجمالي الديون: 150,000 دج       │ (Total debt)
│ ────────────────────────────────│
│                                 │
│ ┌────────────────────────────┐ │
│ │ أحمد                        │ │
│ │ 50,000 دج / 50,000 دج      │ │ (Amount paid / Total)
│ │ ███████████████████ 100%   │ │
│ │ مكتمل ✓                     │ │
│ └────────────────────────────┘ │
│                                 │
│ ┌────────────────────────────┐ │
│ │ البنك                        │ │
│ │ 25,000 دج / 100,000 دج     │ │
│ │ █████░░░░░░░░░░░░░░░ 25%  │ │
│ │ متبقي: 75,000 دج            │ │
│ └────────────────────────────┘ │
│                                 │
│ [عرض جميع الديون]               │
│                                 │
└─────────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────────┐
│ الديون والالتزامات              │
│ ────────────────────────────────│
│                                 │
│          💳                      │
│    لا توجد ديون حالياً           │
│    (No debts)                    │
│                                 │
│     [+ سجل ديناً جديداً]         │
│     (+ Add Debt)                 │
│                                 │
└─────────────────────────────────┘
```

**Interactions**:
- Tap debt card → Navigate to `/debt/:id` (detail with payment history)
- Tap "عرض جميع الديون" → Navigate to `/debts`
- Tap "+ سجل ديناً" → Navigate to `/debt/add`

**Data Binding**:
- Debt card: creditor name, amount paid / total, progress bar, status badge
- Completed debts: show green checkmark, "مكتمل" (completed)
- Active debts: show remaining amount

---

### 3. Home Screen - Classification Badge (Integration)

**Location**: Home page, below Debts section (or in header)  
**State**: Loading | Loaded | Error

**Layout**:
```
┌─────────────────────────────────┐
│ تصنيفك المالي                   │ (Your Financial Classification)
│ ────────────────────────────────│
│                                 │
│        ⭐ مدخر ذكي              │ (Icon + Classification)
│                                 │
│    معدل الادخار: 22.5%         │ (Savings rate)
│                                 │
│  أنت تحتفظ بـ ربع دخلك تقريباً   │ (Description)
│  استمر على هذا الحال! 👏         │ (Motivational message)
│                                 │
│ ────────────────────────────────│
│ آخر حساب: 2026-06-25          │ (Last calculated)
│                                 │
└─────────────────────────────────┘
```

**Classifications** (with icons/colors):
- 🏆 المدخر الأسطوري (Legendary Saver) — >30%, teal
- ⭐ المدخر الذكي (Smart Saver) — 15-30%, teal
- ⚖️ المتوازن (Balanced) — 5-15%, blue
- 💸 المبذر (Spendthrift) — 0-5%, orange
- ⚠️ خطر (Danger) — 0 to -5%, orange (darker)
- 🔴 المفلس المبكر (Early Bankruptcy) — <-5%, red

**Interactions**:
- Tap badge → Navigate to `/insights` (show detailed classification + suggestions)

**Data Binding**:
- Icon determined by classification
- Color coded by classification
- Savings rate calculated from (income - expenses) / income
- Description generated from classification (motivational tone)

---

### 4. Goals List Page (`/goals`)

**Navigation**: Home → Goals (tab or button)  
**State**: Loading | Loaded | Empty | Error

**Layout**:
```
┌─────────────────────────────────┐
│  الأهداف المالية        [+]       │ (Title + Add button)
├─────────────────────────────────┤
│                                 │
│ [Filter/Sort] ▼                 │ (Optional: Active | Completed)
│                                 │
│ ┌────────────────────────────┐ │
│ │ [Icon] شراء هاتف جديد        │ │
│ │        80,000 دج             │ │
│ │ ████████░░░░░░░░░░ 35%      │ │
│ │ 28,000 من 80,000 دج         │ │
│ │ تم الإنشاء: 2026-06-15      │ │
│ └────────────────────────────┘ │
│                                 │
│ ┌────────────────────────────┐ │
│ │ [Icon] رحلة العطلة          │ │
│ │        150,000 دج            │ │
│ │ ██░░░░░░░░░░░░░░░░░░ 8%    │ │
│ │ 12,000 من 150,000 دج        │ │
│ │ تم الإنشاء: 2026-05-20      │ │
│ └────────────────────────────┘ │
│                                 │
│ [تحميل المزيد...]               │ (Pagination trigger)
│                                 │
└─────────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────────┐
│  الأهداف المالية        [+]       │
├─────────────────────────────────┤
│                                 │
│          📊                      │
│    لا توجد أهداف بعد            │
│                                 │
│   ابدأ بحلم مالي الآن!           │
│   (Start a financial dream)      │
│                                 │
│   [+ أضف هدفاً جديداً]           │
│                                 │
└─────────────────────────────────┘
```

**Components**:
- Goal card (reusable widget)
  - Icon (auto-selected or user-chosen)
  - Name (bold, 14px)
  - Target amount (teal, bold)
  - Progress bar (Teal, 100% width)
  - Progress percentage (right-aligned)
  - Saved/target text (gray, small)
  - Created date (gray, small)

**Interactions**:
- Tap card → Navigate to `/goal/:id` (detail view with edit/delete options)
- Tap "+" FAB → Navigate to `/goal/add`
- Swipe left → Delete goal (with confirmation)
- Pull to refresh → Reload goals

**Data Binding**:
- Goals paginated: 20 per page
- Sorted by: most recent first (or user preference)
- Filter options: Show completed / Hide completed

---

### 5. Add Goal Page (`/goal/add`)

**Navigation**: Home → Goals → Add Goal  
**State**: Idle | Loading | Success | Error

**Layout**:
```
┌─────────────────────────────────┐
│  إضافة هدف جديد        [X]       │
├─────────────────────────────────┤
│                                 │
│ اسم الهدف                        │
│ ┌─────────────────────────────┐ │
│ │ مثال: شراء هاتف جديد         │
│ │ [                           ] │ (Text field, RTL)
│ └─────────────────────────────┘ │
│                                 │
│ المبلغ المستهدف                 │
│ ┌─────────────────────────────┐ │
│ │ مثال: 80000                  │
│ │ [                      ] دج  │ (Number field)
│ └─────────────────────────────┘ │
│                                 │
│ وصف إضافي (اختياري)             │
│ ┌─────────────────────────────┐ │
│ │ أضف ملاحظات...               │
│ │                             │ │
│ │ [                           ] │ (Multi-line)
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │  [أضف الهدف]                │ │ (Save button)
│ └─────────────────────────────┘ │
│ ┌─────────────────────────────┐ │
│ │  [إلغاء]                    │ │ (Cancel button)
│ └─────────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

**Validation**:
- Name: required, max 100 chars
- Amount: required, > 0, max 9,999,999 DZD
- Description: optional, max 500 chars

**Error States**:
```
Name field error:  "الاسم مطلوب" (Name required)
Amount field error: "يجب أن يكون المبلغ أكبر من صفر" (Amount must be > 0)
```

**Interactions**:
- Type name → Enable amount field
- Type amount → Enable save button
- Save button → Validate → Create goal → Navigate back to `/goals`
- Cancel button → Navigate back

---

### 6. Goal Detail Page (`/goal/:id`)

**Navigation**: Goals → Goal detail  
**State**: Loading | Loaded | Editing | Error

**Layout (View Mode)**:
```
┌─────────────────────────────────┐
│  شراء هاتف جديد       [≡]        │ (Title + Menu)
├─────────────────────────────────┤
│                                 │
│ ┌────────────────────────────┐ │
│ │        📱                   │ │
│ │    شراء هاتف جديد           │ │
│ │    80,000 دج                │ │
│ │                             │ │
│ │ ████████░░░░░░░░░░ 35%     │ │
│ │ 28,000 دج من 80,000         │ │
│ │                             │ │
│ │ تم الإنشاء: 2026-06-15      │ │
│ │ آخر تحديث: 2026-06-25       │ │
│ └────────────────────────────┘ │
│                                 │
│ ────────────────────────────────│
│ كيف يتم حساب التقدم؟            │ (Explanation)
│                                 │
│ التقدم = (الدخل - المصاريف)     │
│         ÷ المبلغ المستهدف       │
│                                 │
│ هذا الشهر: 28,000 دج           │ (Current progress)
│                                 │
│ ────────────────────────────────│
│ [تعديل الهدف]  [حذف الهدف]      │
│                                 │
└─────────────────────────────────┘
```

**Menu Options** (Tap [≡]):
- Edit Goal (navigate to edit form)
- Delete Goal (with confirmation)
- Share (optional, future feature)

**Interactions**:
- Tap Edit → Edit form appears
- Tap Delete → Confirmation dialog → Delete → Navigate back
- Tap Share → Share to contacts (future)

---

### 7. Debts List Page (`/debts`)

**Navigation**: Home → Debts (tab or button)  
**State**: Loading | Loaded | Empty | Error

**Layout**:
```
┌─────────────────────────────────┐
│  الديون والالتزامات    [+]       │
├─────────────────────────────────┤
│                                 │
│ إجمالي الديون: 150,000 دج       │ (Summary)
│ ────────────────────────────────│
│                                 │
│ ┌────────────────────────────┐ │
│ │ أحمد                        │ │
│ │ 50,000 دج / 50,000 دج      │ │
│ │ ███████████████████ 100%   │ │
│ │ مكتمل ✓                     │ │ (Paid in full)
│ └────────────────────────────┘ │
│                                 │
│ ┌────────────────────────────┐ │
│ │ البنك                        │ │
│ │ 25,000 دج / 100,000 دج     │ │
│ │ █████░░░░░░░░░░░░░░░ 25%  │ │
│ │ متبقي: 75,000 دج            │ │ (Remaining)
│ └────────────────────────────┘ │
│                                 │
│ [تحميل المزيد...]               │ (Pagination)
│                                 │
└─────────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────────┐
│  الديون والالتزامات    [+]       │
├─────────────────────────────────┤
│                                 │
│          💳                      │
│    لا توجد ديون حالياً           │
│                                 │
│   أنت خالي من الديون! 🎉         │
│   (You're debt-free!)            │
│                                 │
│   [+ سجل ديناً جديداً]           │
│                                 │
└─────────────────────────────────┘
```

**Components**:
- Debt card (reusable)
  - Creditor name (bold, 14px)
  - Amount paid / Total (format as Money)
  - Progress bar (Teal → Green if 100%)
  - Status badge (Completed or Remaining amount)

---

### 8. Add Debt & Payment Page (`/debt/add`, `/debt/:id`)

**Add Debt Form** (`/debt/add`):
```
┌─────────────────────────────────┐
│  إضافة دين جديد        [X]       │
├─────────────────────────────────┤
│                                 │
│ اسم الدائن                       │
│ ┌─────────────────────────────┐ │
│ │ مثال: البنك / أحمد / المتجر  │
│ │ [                           ] │
│ └─────────────────────────────┘ │
│                                 │
│ المبلغ الكلي                      │
│ ┌─────────────────────────────┐ │
│ │ مثال: 100000                 │
│ │ [                      ] دج  │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │  [أضف الدين]               │ │
│ └─────────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

**Debt Detail & Payment** (`/debt/:id`):
```
┌─────────────────────────────────┐
│  البنك               [≡]         │
├─────────────────────────────────┤
│                                 │
│ المبلغ الكلي: 100,000 دج         │
│ المبلغ المدفوع: 25,000 دج        │
│ المتبقي: 75,000 دج               │
│ ────────────────────────────────│
│ █████░░░░░░░░░░░░░░░ 25%      │
│                                 │
│ ────────────────────────────────│
│ سجل دفعة جديدة                   │ (Add Payment)
│ ┌─────────────────────────────┐ │
│ │ المبلغ                       │
│ │ [                      ] دج  │ (Payment amount)
│ │                             │
│ │ [سجل الدفعة]                 │ (Submit)
│ └─────────────────────────────┘ │
│                                 │
│ ────────────────────────────────│
│ سجل الدفعات                      │ (Payment History)
│ ────────────────────────────────│
│                                 │
│ 15,000 دج  •  2026-06-20      │
│ 10,000 دج  •  2026-06-10      │
│                                 │
└─────────────────────────────────┘
```

---

### 9. Insights Page (`/insights`)

**Navigation**: Bottom tab → Insights  
**State**: Loading | Loaded | Empty | Error

**Layout**:
```
┌─────────────────────────────────┐
│  الرؤى المالية                   │ (Financial Insights)
│ ────────────────────────────────│
│                                 │
│ تصنيفك المالي                    │ (Classification Section)
│ ⭐ مدخر ذكي                      │
│ معدل الادخار: 22.5%             │
│                                 │
│ ════════════════════════════════│
│                                 │
│ اكتشفنا تسريباً مالياً            │ (Leak Detection)
│ ┌────────────────────────────┐ │
│ │ ☕ القهوة والمشروبات        │ │
│ │ 6,200 دج هذا الشهر          │ │
│ │ 31 عملية شراء               │ │
│ │                             │ │
│ │ لو خفضتها للنصف لادخرت:     │ │
│ │ 3,100 دج 💡                 │ │
│ └────────────────────────────┘ │
│                                 │
│ ════════════════════════════════│
│                                 │
│ اتجاهاتك المالية                 │ (Spending Trends)
│ ┌────────────────────────────┐ │
│ │ 📈 المطاعم                  │ │
│ │ ارتفع بنسبة 35%            │ │
│ │ 8,500 دج → 11,475 دج      │ │
│ │                             │ │
│ │ 💡 جرّب التخطيط للوجبات     │ │
│ └────────────────────────────┘ │
│                                 │
│ [تحميل المزيد...]               │
│                                 │
└─────────────────────────────────┘
```

**Empty State**:
```
┌─────────────────────────────────┐
│  الرؤى المالية                   │
│ ────────────────────────────────│
│                                 │
│          🔍                      │
│    لا توجد رؤى متاحة حالياً      │
│                                 │
│  ابدأ بتسجيل مصاريفك أولاً       │
│  (Start tracking expenses)       │
│                                 │
└─────────────────────────────────┘
```

**Components**:
- Classification card (shows badge, rate, description)
- Leak card (category, amount, frequency, suggestion)
- Trend card (category, percentage change, old → new amount, suggestion)

**Interactions**:
- Tap leak card → Expand to show transactions in that category
- Tap trend card → Expand to show comparison details
- Pull to refresh → Recalculate insights

---

## Loading & Error States

**Loading Indicator** (all pages):
```
┌─────────────────────────────────┐
│                                 │
│          [Circular Progress]     │
│      جاري التحميل...             │
│                                 │
└─────────────────────────────────┘
```

**Error State**:
```
┌─────────────────────────────────┐
│  ⚠️ حدث خطأ                      │
│                                 │
│  فشل تحميل الأهداف              │
│  (Failed to load goals)          │
│                                 │
│  [إعادة محاولة]   [عودة]        │
│                                 │
└─────────────────────────────────┘
```

---

## Animations & Transitions

**Page Navigation**:
- Forward navigation: Slide right → left (RTL)
- Back navigation: Slide left → right (RTL)
- Duration: 300ms, Curve: easeInOut

**Progress Bar**:
- Animated on amount change: 300ms transition
- Color: Teal (primary)

**Goal Completion**:
- Confetti animation (optional, celebratory)
- Success message: Slide in from top, 2s display

**Button Interactions**:
- Ripple effect on tap
- Scale animation: 0.95x → 1.0x on tap (implicit)

---

## Accessibility

**RTL Support**:
- All text right-aligned
- All icons flipped (if directional)
- All spacing reversed

**Text Sizes**:
- Minimum 14px for body text
- High contrast (WCAG AAA preferred)
- Arabic font (Cairo) optimized for readability

**Touch Targets**:
- Minimum 48x48 pt for tappable elements
- Generous spacing between buttons

---

## Summary

| Screen | Route | Purpose | MVP |
|--------|-------|---------|-----|
| Goals List | `/goals` | Browse all goals | Yes |
| Add Goal | `/goal/add` | Create new goal | Yes |
| Goal Detail | `/goal/:id` | View & edit goal | Yes |
| Debts List | `/debts` | Browse all debts | Yes |
| Add Debt | `/debt/add` | Create new debt | Yes |
| Debt Detail | `/debt/:id` | View & add payments | Yes |
| Insights | `/insights` | Financial analysis | P2 |
| Home Integration | `/home` | Goals/Debts summary | Yes |

**Total New Screens**: 7 + 3 home integrations = 10 screens

**Design System Compliance**: 100%  
**Offline-Ready**: Yes  
**RTL Support**: Full  
**Performance Target**: <100ms load per screen

---

**UI Contract Version**: 1.0  
**Last Updated**: 2026-06-26
