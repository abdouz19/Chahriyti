# Custom Expense Categories — Implementation Plan

## Goal

Allow users to create, use, and delete their own expense categories alongside the 9 built-in ones.

---

## Current Architecture (Key Findings)

### DB Storage
- `expenses.category` → `TEXT` (stores enum name: `"essentials"`, `"clothing"`, etc.)
- `expenses.subcategory` → `TEXT` (stores subcategory enum name)
- No FK constraints — any string is valid

### Category Key Format
Built-ins use the Dart enum `.name` property as the key stored in DB.  
Custom categories will use: **`custom_<id>`** (e.g. `custom_3`).  
This fits the existing `String` column with zero schema changes to the `expenses` table.

### Enum Coupling (Risk Areas)

| File | Risk | Impact |
|------|------|--------|
| `core/constants/categories.dart` | `ExpenseCategory` enum drives all built-ins | Medium — custom categories bypass enum entirely |
| `category_l10n_extension.dart` | Switch on enum for localized label | Low — only called with enum values; custom categories never passed here |
| `category_grid.dart` | Iterates `ExpenseCategory.values` for icon switch | **High** — grid must also render custom cards |
| `category_breakdown_chart.dart:24-34` | Hardcoded `Map<String, Color>` with 9 enum-name keys | **High** — unknown key → null color → crash or invisible slice |
| `recent_expenses_list.dart:143` | `firstWhere(c => c.name == category)` → throws if not found | **High** — `custom_3` fails this lookup → crash |
| `expense_history_page.dart:41-44` | Same `String→Enum` pattern | **High** |
| `detect_financial_leaks_use_case.dart` | Groups by `expense.category` string | Low — grouping still works; display name needs mapping |
| `generate_spending_trends_use_case.dart` | Same grouping | Low |
| `trend_card.dart` / `leak_card.dart` | Heuristic Arabic text icon matching | Low — custom names may not match any pattern; falls back to default icon |
| `subcategory_chips.dart` | Reads `ExpenseCategory.subcategories` getter | Low — **custom categories will have no subcategories** |
| `expense_cubit.dart:65-74` | Calls `selectCategory(cat.name)` — passes string to cubit | Medium — cubit stores string, passes to DB. Works if we adapt the grid callback |
| `add_expense_page.dart` | `CategoryGrid` callback typed as `ValueChanged<ExpenseCategory>` | **High** — must change to `String`-based callback |

---

## Design Decisions

| Decision | Choice | Reason |
|----------|--------|--------|
| Custom category key format | `custom_<id>` | Fits existing TEXT column, no migration of expenses table |
| Subcategories for custom | ❌ None | Too complex; not needed for MVP |
| Icon for custom | Emoji (user picks from preset list) | Simple, no font dependency |
| Color for custom in stats | Auto-assigned from a palette pool | Avoids hardcoded map gaps |
| Can user edit category of an existing expense | ❌ No | Edit flow currently disabled; out of scope |
| Built-in categories editable/deletable | ❌ Never | Protected — only user-created custom categories can be edited or deleted |
| Insights (leaks/trends) | Custom categories appear as-is with emoji icon | Already string-grouped; just need fallback display |
| Delete custom category | ✅ Yes | Long-press on grid card or settings screen |
| Custom category limit | 20 max | Prevents grid overflow |

---

## Files to CREATE

### 1. DB Table
**`lib/infrastructure/database/tables/custom_categories_table.dart`**
```dart
@DataClassName('CustomCategoryRow')
class CustomCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get emoji => text().withLength(min: 1, max: 8)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
```

### 2. DAO
**`lib/infrastructure/database/daos/custom_categories_dao.dart`**
- `getAll()` → `List<CustomCategoryRow>`
- `insert(name, emoji)` → `int` (new id)
- `deleteById(int id)` → `void`
- Uses `@DriftAccessor(tables: [CustomCategories])`

### 3. Domain Entity
**`lib/domain/entities/custom_category_entity.dart`**
- Fields: `id`, `name`, `emoji`
- Computed: `categoryKey` → `'custom_$id'`

### 4. Repository Interface
**`lib/domain/repositories/custom_category_repository.dart`**
- `Future<List<CustomCategoryEntity>> getAll()`
- `Future<CustomCategoryEntity> create({required String name, required String emoji})`
- `Future<void> delete(int id)`

### 5. Repository Impl
**`lib/infrastructure/repositories/custom_category_repository_impl.dart`**
- Wraps `CustomCategoriesDao`, maps rows to entities

### 6. Use Cases
**`lib/application/use_cases/expense/manage_custom_categories_use_case.dart`**
- `GetCustomCategoriesUseCase`
- `CreateCustomCategoryUseCase` (validates: name not empty, limit ≤ 20)
- `DeleteCustomCategoryUseCase`

---

## Files to MODIFY

### A. `app_database.dart`
- Add `CustomCategories` to `@DriftDatabase(tables: [...])`
- Bump `schemaVersion` → **13**
- Add migration: `if (from < 13) { await m.create(customCategories); }`
- Add `resetFinancialData()` exclusion (custom categories survive a financial reset)

### B. `injection.dart`
- Add `CustomCategoriesDao _customCategoriesDao`
- Add `CustomCategoryRepository customCategoryRepository`
- Add `GetCustomCategoriesUseCase`, `CreateCustomCategoryUseCase`, `DeleteCustomCategoryUseCase`

### C. `category_grid.dart` ← **Major rewrite**
- Convert to `StatefulWidget` — loads custom categories on init
- Accept `void Function(String categoryKey)` callback instead of `ValueChanged<ExpenseCategory>`
- Render built-in cards → same as now (but emit `cat.name` string)
- Render custom cards → show emoji + name, long-press → delete confirmation (built-in cards have NO long-press / delete option)
- Render "+" card at end → opens `_AddCustomCategorySheet` bottom sheet
- Bottom sheet: name field + emoji picker (grid of ~20 preset emojis)

### D. `add_expense_page.dart`
- Change `_CategoryStep.onCategorySelected` from `ValueChanged<ExpenseCategory>` to `void Function(String categoryKey)`
- When custom category selected: `cubit.selectCategory("custom_3")` — already works
- Remove subcategory chips display when `categoryKey.startsWith("custom_")` (custom has no subcategories)

### E. `expense_cubit.dart`
- `selectCategory(String category)` already accepts strings — **no change needed**
- `selectSubcategory()` — guard: if `state.category.startsWith('custom_')`, subcategory defaults to empty string, don't show chips

### F. `category_breakdown_chart.dart`
- `_categoryColors` map: change from hardcoded 9-entry map to dynamic lookup
- Unknown key (custom category) → pick color from a rotating palette (e.g. 10-color pool by index)
- `_localizedCategoryLabel()`: if no enum match found → return the raw string (it's already the user's label... wait, we store `custom_3` not the name)
- **Problem**: chart only has the key `custom_3`, not the display name
- **Solution**: chart must receive a `Map<String, String> categoryNames` param to resolve custom keys to display names
- `GetCategoryBreakdownUseCase` must also return display names, not just the key

### G. `recent_expenses_list.dart`
- `_categoryFromString()`: wrap `firstWhere` in try/catch or use `firstWhereOrNull`
- When category is `custom_*`: return `null` (or a sentinel)
- `_categoryIcon()`: when null → show a generic tag icon
- `localizedLabel()` fallback: when null → use expense `itemName` or raw category name

### H. `expense_history_page.dart`
- `_categoryLabel()`: same `firstWhereOrNull` fix
- When `custom_*`: strip `custom_` prefix, look up name from custom categories list (needs to be passed down or loaded separately)

### I. `detect_financial_leaks_use_case.dart` / `generate_spending_trends_use_case.dart`
- Grouping by `expense.category` string already works — no change needed
- Insight suggestion messages: hardcoded per category — custom categories won't get personalized suggestions. Accept as MVP limitation.

### J. `trend_card.dart` / `leak_card.dart`
- `_getCategoryIcon()` heuristic: add final `else` branch returning `Icons.label_outline` for unrecognized (already exists? verify)
- Custom categories with emoji → `Text(emoji)` widget instead of `Icon`... or just use `Icons.label_outline` as fallback

### K. `expense_form.dart`
- `hintForCategory()`: already has `default` case — custom categories fall through correctly

---

## DB Migration Summary

```
v12 → v13: CREATE TABLE custom_categories (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
)
```

**No change to `expenses` table.** Existing expenses with built-in category strings remain valid.  
`resetFinancialData()` must NOT delete `custom_categories` (they are user preferences, not financial data).

---

## Breakdown Chart — Name Resolution Problem

Current flow:
```
DB GROUP BY category → Map<String, int> { "essentials": 5000, "custom_3": 1200 }
```

Chart needs display names. Two options:

**Option A** — Resolve in use case (preferred):
- `GetCategoryBreakdownUseCase` also fetches custom categories list
- Returns `Map<CategoryBreakdownItem, double>` where `CategoryBreakdownItem` has `key`, `displayName`, `isCustom`, `emoji?`
- Chart uses `displayName` for labels
- Slightly wider change but clean

**Option B** — Resolve in widget:
- Widget also reads `customCategoryRepository.getAll()` and builds lookup map
- Messier: UI knows about repositories

**→ Use Option A.**

---

## Emoji Preset List (for picker)

```
🍔 🍕 🛒 👕 💊 🚗 📚 ☕ 🎮 🏠 💰 ✈️ 🎁 💻 🐾 ⚽ 🎵 💇 🛠️ 📱
```

20 emojis. User taps one to select. Name field is free text (AR/FR/EN).

---

## Implementation Order

1. Table + DAO + entity + repository (run `build_runner` after this step)
2. Injection wiring
3. Fix `_categoryFromString` crashes in `recent_expenses_list` and `expense_history_page`
4. Adapt `category_breakdown_chart` + `GetCategoryBreakdownUseCase` (Option A)
5. Rewrite `category_grid.dart` with custom card + add sheet
6. Adapt `add_expense_page.dart` callback
7. Test end-to-end (add custom → expense → see in stats)

---

## Out of Scope (MVP)

- Editing/deleting built-in categories (الضروريات, الملابس, etc.) — permanently protected
- Editing a custom category's name/emoji after creation (delete + recreate)
- Custom subcategories
- Reordering categories in grid
- Changing category of an existing expense
- Syncing custom categories across devices
- Personalized insights for custom categories
