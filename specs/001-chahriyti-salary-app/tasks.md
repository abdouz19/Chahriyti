# Tasks: Chahriyti — Personal Salary & Expense Management App

**Input**: Design documents from `specs/001-chahriyti-salary-app/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ui-contracts.md
**Constitution**: `.specify/memory/constitution.md` — all principles enforced (Clean Architecture, testing, performance, data safety)

**Tests**: Included — constitution mandates testing as NON-NEGOTIABLE (Principle II).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

All source code lives under `chahriyti/lib/` following Clean Architecture:
- **Domain**: `chahriyti/lib/domain/` (entities, repositories, value objects)
- **Application**: `chahriyti/lib/application/use_cases/`
- **Infrastructure**: `chahriyti/lib/infrastructure/`
- **Presentation**: `chahriyti/lib/presentation/`
- **Tests**: `chahriyti/test/unit/`, `chahriyti/test/widget/`, `chahriyti/integration_test/`

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Configure the Flutter project with all dependencies, theme, and foundational structure

- [X] T001 Update pubspec.yaml with all required dependencies (drift, drift_dev, flutter_bloc, go_router, freezed, freezed_annotation, json_annotation, json_serializable, build_runner, google_fonts, lottie, flutter_svg, crypto, device_info_plus, flutter_secure_storage, url_launcher, smooth_page_indicator, path_provider, logger, flutter_localizations, intl) in `chahriyti/pubspec.yaml`
- [X] T002 [P] Create app color palette constants (Deep Teal #0D6E6E, Emerald Green #22C55E, Coral Red #EF4444, Warm White #F8F9FA, Charcoal #1A1A2E, Cool Gray #94A3B8) in `chahriyti/lib/core/theme/app_colors.dart`
- [X] T003 [P] Create Cairo Arabic typography styles (headings, body, labels, amounts — weights 400/600/700) in `chahriyti/lib/core/theme/app_typography.dart`
- [X] T004 [P] Create ThemeData assembly combining colors and typography with RTL defaults in `chahriyti/lib/core/theme/app_theme.dart`
- [X] T005 [P] Create expense category and subcategory enums with Arabic labels (Essentials/أكل,نقل,فواتير,دواء; Home&Family/مصروف البيت,الأولاد,الهدايا,أخرى; Luxuries/مطاعم,قهوة,ملابس,ترفيه; Other/أخرى) in `chahriyti/lib/core/constants/categories.dart`
- [X] T006 [P] Create 58 Algerian wilayas constant list (code + Arabic name) in `chahriyti/lib/core/constants/wilayas.dart`
- [X] T007 [P] Create Money value object (centimes storage, DZD formatting, arithmetic operations) in `chahriyti/lib/domain/value_objects/money.dart`
- [X] T008 [P] Create DeviceId value object (SHA-256 hashed device identifier wrapper) in `chahriyti/lib/domain/value_objects/device_id.dart`
- [X] T009 [P] Create money formatting extensions (centimes to DZD string with دج suffix, LTR wrapping) in `chahriyti/lib/core/extensions/money_extensions.dart`
- [X] T010 Create MaterialApp with Arabic locale (Locale('ar')), RTL directionality, Cairo font, ThemeData, and GoRouter in `chahriyti/lib/app.dart`
- [X] T011 Create dependency injection setup (service locator for database, repositories, use cases, cubits) in `chahriyti/lib/core/di/injection.dart`
- [X] T012 Update app entry point with DI initialization and App widget in `chahriyti/lib/main.dart`
- [X] T013 [P] Create reusable EmptyStateWidget (accepts SVG path, title, subtitle, optional CTA button) in `chahriyti/lib/presentation/shared/widgets/empty_state_widget.dart`
- [X] T014 [P] Create reusable MoneyText widget (LTR directionality wrapper for currency amounts with دج) in `chahriyti/lib/presentation/shared/widgets/money_text.dart`
- [X] T015 [P] Create reusable LoadingShimmer widget (skeleton loading placeholder for cards and lists) in `chahriyti/lib/presentation/shared/widgets/loading_shimmer.dart`
- [X] T016 [P] Create reusable ConfirmationDialog widget (title, message, confirm/cancel buttons) in `chahriyti/lib/presentation/shared/widgets/confirmation_dialog.dart`
- [X] T017 [P] Add placeholder SVG illustrations for empty states (empty_expenses, empty_debts, empty_goals, empty_history, empty_stats) in `chahriyti/assets/illustrations/`
- [X] T018 [P] Add placeholder Lottie animation files for onboarding (welcome.json, features.json, activate.json) in `chahriyti/assets/animations/`
- [X] T019 Register assets in pubspec.yaml (assets/illustrations/, assets/animations/) in `chahriyti/pubspec.yaml`

### Tests for Phase 1

- [X] T020 [P] Unit test Money value object (creation, arithmetic, formatting, edge cases: zero, max) in `chahriyti/test/unit/domain/value_objects/money_test.dart`
- [X] T021 [P] Unit test DeviceId value object (creation, hashing, equality) in `chahriyti/test/unit/domain/value_objects/device_id_test.dart`
- [X] T022 [P] Unit test money extensions (centimes to DZD conversion, formatting with thousands separator) in `chahriyti/test/unit/core/extensions/money_extensions_test.dart`
- [X] T023 [P] Widget test EmptyStateWidget (renders SVG, title, subtitle, CTA) in `chahriyti/test/widget/shared/empty_state_widget_test.dart`
- [X] T024 [P] Widget test MoneyText (renders LTR amount with دج) in `chahriyti/test/widget/shared/money_text_test.dart`
- [X] T025 Run `dart run build_runner build --delete-conflicting-outputs` and verify project compiles with `flutter analyze`

**Checkpoint**: Project scaffolding complete — theme, DI, shared widgets, assets, and core utilities ready.

---

## Phase 2: Foundational (Database & Core Infrastructure)

**Purpose**: Drift database, all tables, DAOs, domain entities, repository interfaces, and repository implementations. MUST complete before any user story.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### Database Schema

- [X] T026 Create Drift users table (id, monthly_salary, salary_day, full_name, phone_number, wilaya_code, is_activated, created_at) in `chahriyti/lib/infrastructure/database/tables/users_table.dart`
- [X] T027 [P] Create Drift financial_cycles table (id, start_date, end_date, salary_amount, is_active) in `chahriyti/lib/infrastructure/database/tables/financial_cycles_table.dart`
- [X] T028 [P] Create Drift expenses table (id, cycle_id FK, category, subcategory, item_name, amount, notes, created_at, updated_at) with index on (cycle_id, created_at DESC) and (cycle_id, category) in `chahriyti/lib/infrastructure/database/tables/expenses_table.dart`
- [X] T029 [P] Create Drift additional_incomes table (id, cycle_id FK, description, amount, created_at) with index on (cycle_id) in `chahriyti/lib/infrastructure/database/tables/additional_incomes_table.dart`
- [X] T030 [P] Create Drift debts table (id, creditor_name, total_amount, paid_amount, is_fully_paid, created_at) in `chahriyti/lib/infrastructure/database/tables/debts_table.dart`
- [X] T031 [P] Create Drift debt_payments table (id, debt_id FK, cycle_id FK, amount, created_at) with index on (debt_id) and (cycle_id) in `chahriyti/lib/infrastructure/database/tables/debt_payments_table.dart`
- [X] T032 [P] Create Drift savings_goals table (id, name, target_amount, saved_amount, is_achieved, created_at) in `chahriyti/lib/infrastructure/database/tables/savings_goals_table.dart`
- [X] T033 [P] Create Drift savings_contributions table (id, goal_id FK, cycle_id FK, amount, created_at) with index on (goal_id) and (cycle_id) in `chahriyti/lib/infrastructure/database/tables/savings_contributions_table.dart`
- [X] T034 [P] Create Drift weekly_challenges table (id, cycle_id FK, week_start, target_reduction, previous_week_spending, is_completed) in `chahriyti/lib/infrastructure/database/tables/weekly_challenges_table.dart`
- [X] T035 [P] Create Drift license_activations table (id, device_id, license_key, expiry_date, activated_at) in `chahriyti/lib/infrastructure/database/tables/license_activations_table.dart`
- [X] T036 Create AppDatabase (GeneratedDatabase) registering all tables, WAL journal mode in onOpen, MigrationStrategy with initial schema version 1 in `chahriyti/lib/infrastructure/database/app_database.dart`

### Domain Entities (Freezed)

- [X] T037 [P] Create UserEntity (Freezed immutable, all user fields) in `chahriyti/lib/domain/entities/user_entity.dart`
- [X] T038 [P] Create FinancialCycleEntity (Freezed, with derived field calculation methods for balance, days remaining, safe daily spending, consumption percentage) in `chahriyti/lib/domain/entities/financial_cycle_entity.dart`
- [X] T039 [P] Create ExpenseEntity (Freezed, with category/subcategory enums) in `chahriyti/lib/domain/entities/expense_entity.dart`
- [X] T040 [P] Create AdditionalIncomeEntity (Freezed) in `chahriyti/lib/domain/entities/additional_income_entity.dart`
- [X] T041 [P] Create DebtEntity (Freezed, with remaining_amount derived field) in `chahriyti/lib/domain/entities/debt_entity.dart`
- [X] T042 [P] Create SavingsGoalEntity (Freezed, with progress percentage derived field) in `chahriyti/lib/domain/entities/savings_goal_entity.dart`
- [X] T043 [P] Create WeeklyChallengeEntity (Freezed) in `chahriyti/lib/domain/entities/weekly_challenge_entity.dart`

### Repository Interfaces (Domain)

- [X] T044 [P] Create UserRepository interface (getUser, createUser, updateUser, isActivated) in `chahriyti/lib/domain/repositories/user_repository.dart`
- [X] T045 [P] Create CycleRepository interface (getActiveCycle, createCycle, closeCycle, getCycleHistory) in `chahriyti/lib/domain/repositories/cycle_repository.dart`
- [X] T046 [P] Create ExpenseRepository interface (addExpense, editExpense, deleteExpense, getExpenses paginated, getExpensesByCategory, getRecentExpenses, getTotalExpenses) in `chahriyti/lib/domain/repositories/expense_repository.dart`
- [X] T047 [P] Create DebtRepository interface (addDebt, makePayment, getDebts, getActiveDebts, getTotalDebtPaymentsForCycle) in `chahriyti/lib/domain/repositories/debt_repository.dart`
- [X] T048 [P] Create GoalRepository interface (createGoal, contribute, getGoals, getActiveGoals, getTotalContributionsForCycle) in `chahriyti/lib/domain/repositories/goal_repository.dart`
- [X] T049 [P] Create IncomeRepository interface (addIncome, getIncomesForCycle, getTotalIncomeForCycle) in `chahriyti/lib/domain/repositories/income_repository.dart`

### DAOs (Drift)

- [X] T050 [P] Create UsersDao (CRUD for users table, single-row operations) in `chahriyti/lib/infrastructure/database/daos/users_dao.dart`
- [X] T051 [P] Create CyclesDao (create, close, get active, get history with limit) in `chahriyti/lib/infrastructure/database/daos/cycles_dao.dart`
- [X] T052 [P] Create ExpensesDao (CRUD, paginated queries with limit/offset, category aggregation, recent list) in `chahriyti/lib/infrastructure/database/daos/expenses_dao.dart`
- [X] T053 [P] Create DebtsDao (CRUD, payment operations with transaction wrapping, active debts query) in `chahriyti/lib/infrastructure/database/daos/debts_dao.dart`
- [X] T054 [P] Create GoalsDao (CRUD, contribution operations, active goals query) in `chahriyti/lib/infrastructure/database/daos/goals_dao.dart`
- [X] T055 [P] Create IncomesDao (CRUD, sum query for cycle) in `chahriyti/lib/infrastructure/database/daos/incomes_dao.dart`

### Repository Implementations (Infrastructure)

- [X] T056 [P] Create UserRepositoryImpl mapping Drift rows to domain entities in `chahriyti/lib/infrastructure/repositories/user_repository_impl.dart`
- [X] T057 [P] Create CycleRepositoryImpl with cycle boundary calculations in `chahriyti/lib/infrastructure/repositories/cycle_repository_impl.dart`
- [X] T058 [P] Create ExpenseRepositoryImpl with paginated queries and category stats in `chahriyti/lib/infrastructure/repositories/expense_repository_impl.dart`
- [X] T059 [P] Create DebtRepositoryImpl with transaction-wrapped payments in `chahriyti/lib/infrastructure/repositories/debt_repository_impl.dart`
- [X] T060 [P] Create GoalRepositoryImpl with contribution tracking in `chahriyti/lib/infrastructure/repositories/goal_repository_impl.dart`
- [X] T061 [P] Create IncomeRepositoryImpl in `chahriyti/lib/infrastructure/repositories/income_repository_impl.dart`

### Infrastructure Services

- [X] T062 [P] Create DeviceInfoService (device_info_plus + flutter_secure_storage: get/persist device UUID, SHA-256 hash) in `chahriyti/lib/infrastructure/services/device_info_service.dart`
- [X] T063 [P] Create SecureStorageService (flutter_secure_storage wrapper for license key persistence) in `chahriyti/lib/infrastructure/services/secure_storage_service.dart`
- [X] T064 [P] Create LicenseService (HMAC-SHA256 validation: generate expected key from deviceId + expiry, compare with user input) in `chahriyti/lib/infrastructure/services/license_service.dart`

### Code Generation & Tests

- [X] T065 Run `dart run build_runner build --delete-conflicting-outputs` to generate Drift and Freezed code
- [X] T066 [P] Unit test FinancialCycleEntity derived fields (balance calculation, days remaining, safe daily spending, consumption percentage) in `chahriyti/test/unit/domain/entities/financial_cycle_entity_test.dart`
- [X] T067 [P] Unit test DebtEntity remaining_amount calculation in `chahriyti/test/unit/domain/entities/debt_entity_test.dart`
- [X] T068 [P] Unit test SavingsGoalEntity progress percentage in `chahriyti/test/unit/domain/entities/savings_goal_entity_test.dart`
- [X] T069 [P] Unit test LicenseService (valid key, invalid key, expired key, wrong device) in `chahriyti/test/unit/infrastructure/services/license_service_test.dart`
- [X] T070 [P] Unit test ExpensesDao (insert, paginated select, category aggregation, update, delete) using Drift's in-memory database in `chahriyti/test/unit/infrastructure/database/daos/expenses_dao_test.dart`
- [X] T071 [P] Unit test CyclesDao (create, close, get active) using Drift's in-memory database in `chahriyti/test/unit/infrastructure/database/daos/cycles_dao_test.dart`
- [X] T072 [P] Unit test DebtsDao (create, payment with transaction, balance check) using Drift's in-memory database in `chahriyti/test/unit/infrastructure/database/daos/debts_dao_test.dart`

**Checkpoint**: Foundation ready — database, entities, repositories, and infrastructure services all tested. User story implementation can now begin.

---

## Phase 3: User Story 1 — Onboarding & Account Setup (Priority: P1) 🎯 MVP

**Goal**: A new user can open the app, see the splash screen, enter their salary and date, optionally add extra income, view value proposition, and activate via WhatsApp license key flow.

**Independent Test**: Complete the onboarding flow end-to-end: splash → salary → income → value prop → activation → home screen.

### GoRouter Setup

- [X] T073 [US1] Create GoRouter configuration with all routes, redirect logic (first launch → onboarding, not activated → activation, activated → home) in `chahriyti/lib/presentation/shared/routing/app_router.dart`

### Use Cases

- [X] T074 [P] [US1] Create SetupSalaryUseCase (validate salary > 0, validate day 1-31, create user, create first financial cycle) in `chahriyti/lib/application/use_cases/onboarding/setup_salary_use_case.dart`
- [X] T075 [P] [US1] Create AddInitialIncomeUseCase (validate amount > 0, add income to current cycle) in `chahriyti/lib/application/use_cases/onboarding/add_initial_income_use_case.dart`
- [X] T076 [P] [US1] Create GetDeviceIdUseCase (get or generate device UUID via DeviceInfoService) in `chahriyti/lib/application/use_cases/activation/get_device_id_use_case.dart`
- [X] T077 [P] [US1] Create ValidateLicenseUseCase (validate HMAC key via LicenseService, persist activation status) in `chahriyti/lib/application/use_cases/activation/validate_license_use_case.dart`
- [X] T078 [P] [US1] Create ComposeWhatsappMessageUseCase (format message with name, phone, wilaya, device ID; generate wa.me URL) in `chahriyti/lib/application/use_cases/activation/compose_whatsapp_message_use_case.dart`

### Presentation — Onboarding Screens

- [X] T079 [US1] Create OnboardingCubit (states: initial, salaryInput, incomeInput, valueProposition, activation; manages flow transitions) in `chahriyti/lib/presentation/onboarding/cubits/onboarding_cubit.dart`
- [X] T080 [US1] Create SplashPage with Lottie welcome animation, app logo "شهريتي", tagline, and "ابدأ الآن" button with staggered entry animations (fade 200ms, slide 300ms, button 400ms) in `chahriyti/lib/presentation/onboarding/pages/splash_page.dart`
- [X] T081 [US1] Create SalarySetupPage with salary input field (numeric keyboard, DZD formatting), date picker (today/specific date), "I have additional income" checkbox, and validation in `chahriyti/lib/presentation/onboarding/pages/salary_setup_page.dart`
- [X] T082 [US1] Create AdditionalIncomePage with repeatable form (description + amount), add/remove rows, validate amounts > 0 in `chahriyti/lib/presentation/onboarding/pages/additional_income_page.dart`
- [X] T083 [US1] Create ValuePropositionPage with Lottie features animation, 7 benefit items with checkmarks, motivational quote, and proceed button in `chahriyti/lib/presentation/onboarding/pages/value_proposition_page.dart`
- [X] T084 [US1] Create OnboardingPageIndicator widget (smooth_page_indicator dots for onboarding flow progress) in `chahriyti/lib/presentation/onboarding/widgets/onboarding_page_indicator.dart`

### Presentation — Activation Screen

- [X] T085 [US1] Create ActivationCubit (states: loading, ready with deviceId, sending, validating, activated, error) in `chahriyti/lib/presentation/activation/cubits/activation_cubit.dart`
- [X] T086 [US1] Create ActivationPage with 3-step indicator, device ID display with copy button, full name/phone/wilaya form fields, "Send via WhatsApp" button, "I have a license key" button — follows the UI layout from contracts/ui-contracts.md in `chahriyti/lib/presentation/activation/pages/activation_page.dart`
- [X] T087 [US1] Create LicenseKeyDialog (modal with CHRY-XXXX-XXXX-XXXX input, activate/cancel buttons, error state) in `chahriyti/lib/presentation/activation/widgets/license_key_dialog.dart`

### Admin Tool

- [X] T088 [US1] Create license key generator CLI tool (takes --device-id and --expiry, outputs HMAC-SHA256 formatted key CHRY-XXXX-XXXX-XXXX) in `chahriyti/tools/generate_license.dart`

### Tests for US1

- [X] T089 [P] [US1] Unit test SetupSalaryUseCase (valid salary, invalid salary 0/negative, valid day, invalid day 0/32, creates user and cycle) in `chahriyti/test/unit/application/use_cases/onboarding/setup_salary_use_case_test.dart`
- [X] T090 [P] [US1] Unit test ValidateLicenseUseCase (valid key activates, invalid key rejects, expired key rejects) in `chahriyti/test/unit/application/use_cases/activation/validate_license_use_case_test.dart`
- [X] T091 [P] [US1] Unit test ComposeWhatsappMessageUseCase (generates correct wa.me URL with encoded Arabic text) in `chahriyti/test/unit/application/use_cases/activation/compose_whatsapp_message_use_case_test.dart`
- [X] T092 [P] [US1] Widget test SplashPage (renders logo, tagline, button, animations trigger) in `chahriyti/test/widget/onboarding/splash_page_test.dart`
- [X] T093 [P] [US1] Widget test SalarySetupPage (salary input validation, date picker, income checkbox toggle) in `chahriyti/test/widget/onboarding/salary_setup_page_test.dart`
- [X] T094 [P] [US1] Widget test ActivationPage (displays device ID, form fields, WhatsApp button, license key dialog) in `chahriyti/test/widget/activation/activation_page_test.dart`
- [X] T095 [US1] Integration test for full onboarding flow (splash → salary → value → activation → license entry → home redirect) in `chahriyti/integration_test/onboarding_flow_test.dart`

**Checkpoint**: User Story 1 complete — a new user can onboard, activate, and reach the home screen. MVP is functional.

---

## Phase 4: User Story 2 — Recording an Expense (Priority: P1)

**Goal**: An activated user can tap "Spend", select category/subcategory, enter item and price, save, and see the balance update immediately.

**Independent Test**: Record one expense and verify balance decreases on the home screen.

### Use Cases

- [X] T096 [P] [US2] Create AddExpenseUseCase (validate amount > 0, validate category/subcategory, create expense in active cycle, return updated balance) in `chahriyti/lib/application/use_cases/expense/add_expense_use_case.dart`
- [X] T097 [P] [US2] Create EditExpenseUseCase (verify expense in active cycle, validate new values, update, recalculate balance) in `chahriyti/lib/application/use_cases/expense/edit_expense_use_case.dart`
- [X] T098 [P] [US2] Create DeleteExpenseUseCase (verify expense in active cycle, delete, restore balance) in `chahriyti/lib/application/use_cases/expense/delete_expense_use_case.dart`

### Presentation

- [X] T099 [US2] Create ExpenseCubit (states: categorySelection, subcategorySelection, formInput, saving, saved, error) in `chahriyti/lib/presentation/expense/cubits/expense_cubit.dart`
- [X] T100 [US2] Create CategoryGrid widget (2x2 grid of the 4 main categories with Arabic labels and icons, clean card design with brand colors) in `chahriyti/lib/presentation/expense/widgets/category_grid.dart`
- [X] T101 [US2] Create SubcategoryChips widget (horizontal scrollable chips for subcategories of selected category) in `chahriyti/lib/presentation/expense/widgets/subcategory_chips.dart`
- [X] T102 [US2] Create ExpenseForm widget (item name text field, price numeric field with DZD formatting, optional notes field, large "حفظ" save button) in `chahriyti/lib/presentation/expense/widgets/expense_form.dart`
- [X] T103 [US2] Create AddExpensePage (category → subcategory → form flow, animated transitions between steps, returns to home on save) in `chahriyti/lib/presentation/expense/pages/add_expense_page.dart`
- [X] T104 [US2] Create EditExpensePage (pre-populated form with existing expense data, same layout as add, updates balance on save) in `chahriyti/lib/presentation/expense/pages/edit_expense_page.dart`

### Tests for US2

- [X] T105 [P] [US2] Unit test AddExpenseUseCase (valid expense, zero amount rejected, negative rejected, balance updated) in `chahriyti/test/unit/application/use_cases/expense/add_expense_use_case_test.dart`
- [X] T106 [P] [US2] Unit test EditExpenseUseCase (edit in active cycle, reject edit in closed cycle, balance recalculated) in `chahriyti/test/unit/application/use_cases/expense/edit_expense_use_case_test.dart`
- [X] T107 [P] [US2] Unit test DeleteExpenseUseCase (delete in active cycle, reject in closed cycle, balance restored) in `chahriyti/test/unit/application/use_cases/expense/delete_expense_use_case_test.dart`
- [X] T108 [P] [US2] Widget test CategoryGrid (renders 4 categories, tap selects category) in `chahriyti/test/widget/expense/category_grid_test.dart`
- [X] T109 [P] [US2] Widget test ExpenseForm (validates required fields, numeric input, saves correctly) in `chahriyti/test/widget/expense/expense_form_test.dart`
- [X] T110 [US2] Integration test for expense recording flow (home → add expense → select category → fill form → save → home with updated balance) in `chahriyti/integration_test/expense_flow_test.dart`

**Checkpoint**: User Story 2 complete — users can record, edit, and delete expenses with immediate balance updates.

---

## Phase 5: User Story 3 — Home Dashboard Overview (Priority: P1)

**Goal**: The home screen displays current balance, total expenses, days remaining, daily average, consumption bar, safe daily spending, goal progress, debts summary, and recent expenses list.

**Independent Test**: Verify all dashboard cards display correct calculations after salary setup and some recorded expenses.

### Use Cases

- [X] T111 [P] [US3] Create GetDashboardDataUseCase (aggregate: current balance, total expenses, days remaining, daily average, consumption %, safe daily spending — all from active cycle) in `chahriyti/lib/application/use_cases/dashboard/get_dashboard_data_use_case.dart`
- [X] T112 [P] [US3] Create GetSafeBalanceUseCase (remaining balance / remaining days, handle 0 days edge case) in `chahriyti/lib/application/use_cases/dashboard/get_safe_balance_use_case.dart`
- [X] T113 [P] [US3] Create GetExpensesUseCase (paginated: recent N expenses for home, full paginated list for history) in `chahriyti/lib/application/use_cases/expense/get_expenses_use_case.dart`

### Presentation — Dashboard

- [X] T114 [US3] Create DashboardCubit (states: loading with shimmer, loaded with DashboardData, error; refresh on return from expense/income/debt/goal screens) in `chahriyti/lib/presentation/home/cubits/dashboard_cubit.dart`
- [X] T115 [P] [US3] Create BalanceCard widget (green card, current balance with MoneyText, right-aligned for RTL) in `chahriyti/lib/presentation/home/widgets/balance_card.dart`
- [X] T116 [P] [US3] Create ExpensesCard widget (red card, total cycle expenses with MoneyText, left-aligned for RTL) in `chahriyti/lib/presentation/home/widgets/expenses_card.dart`
- [X] T117 [P] [US3] Create DaysRemainingWidget (days count + "يوم" label, "يوم الراتب!" when 0 days) in `chahriyti/lib/presentation/home/widgets/days_remaining_widget.dart`
- [X] T118 [P] [US3] Create DailyAverageWidget (average daily spending formatted as MoneyText) in `chahriyti/lib/presentation/home/widgets/daily_average_widget.dart`
- [X] T119 [P] [US3] Create ConsumptionBar widget (colored progress bar: green < 50%, yellow 50-75%, red > 75%; percentage label; RepaintBoundary wrapped) in `chahriyti/lib/presentation/home/widgets/consumption_bar.dart`
- [X] T120 [P] [US3] Create SafeBalanceCard widget (safe daily spending amount, descriptive text "يمكنك صرف X دج يومياً") in `chahriyti/lib/presentation/home/widgets/safe_balance_card.dart`
- [X] T121 [P] [US3] Create GoalProgressCard widget (goal name, target amount, progress bar with percentage, empty state if no goals) in `chahriyti/lib/presentation/home/widgets/goal_progress_card.dart`
- [X] T122 [P] [US3] Create DebtSummaryCard widget (list of active debts with creditor name and remaining amount, empty state if no debts) in `chahriyti/lib/presentation/home/widgets/debt_summary_card.dart`
- [X] T123 [US3] Create RecentExpensesList widget (last 5 expenses using ListView.builder, each row: item name, category icon, amount, relative date; tap to edit; "عرض الكل" link to history) in `chahriyti/lib/presentation/home/widgets/recent_expenses_list.dart`
- [X] T124 [US3] Create HomePage assembling all dashboard widgets in scrollable layout (CustomScrollView with slivers for performance), FAB "صرف" button, bottom statistics button — follows layout from contracts/ui-contracts.md in `chahriyti/lib/presentation/home/pages/home_page.dart`

### Presentation — Add Income (accessible from home)

- [X] T125 [P] [US3] Create AddIncomeUseCase (validate amount > 0, add to active cycle, return updated balance) in `chahriyti/lib/application/use_cases/income/add_income_use_case.dart`
- [X] T126 [P] [US3] Create IncomeCubit (states: form, saving, saved, error) in `chahriyti/lib/presentation/income/cubits/income_cubit.dart`
- [X] T127 [US3] Create AddIncomePage (description field, amount field, save button — simple form) in `chahriyti/lib/presentation/income/pages/add_income_page.dart`

### Tests for US3

- [X] T128 [P] [US3] Unit test GetDashboardDataUseCase (correct balance calculation, correct daily average, correct consumption %, correct safe spending, edge case 0 days remaining, edge case 0 expenses) in `chahriyti/test/unit/application/use_cases/dashboard/get_dashboard_data_use_case_test.dart`
- [X] T129 [P] [US3] Unit test GetSafeBalanceUseCase (normal division, 0 days returns 0, large remainder) in `chahriyti/test/unit/application/use_cases/dashboard/get_safe_balance_use_case_test.dart`
- [X] T130 [P] [US3] Widget test BalanceCard (renders correct amount, green color) in `chahriyti/test/widget/home/balance_card_test.dart`
- [X] T131 [P] [US3] Widget test ConsumptionBar (correct percentage, correct color thresholds) in `chahriyti/test/widget/home/consumption_bar_test.dart`
- [X] T132 [P] [US3] Widget test RecentExpensesList (renders items, empty state with illustration, tap navigates to edit) in `chahriyti/test/widget/home/recent_expenses_list_test.dart`
- [X] T133 [P] [US3] Widget test HomePage (all cards render in correct layout, FAB present) in `chahriyti/test/widget/home/home_page_test.dart`
- [X] T134 [P] [US3] Unit test AddIncomeUseCase (valid income, zero rejected, balance updated) in `chahriyti/test/unit/application/use_cases/income/add_income_use_case_test.dart`

**Checkpoint**: User Story 3 complete — the home dashboard shows a complete financial snapshot with all indicators, recent expenses, and add income functionality.

---

## Phase 6: User Story 4 — Statistics & Financial Analytics (Priority: P2)

**Goal**: Users can view expense distribution by category, top spending category, smart predictions, balance depletion forecast, month-over-month comparison, and financial behavior classification.

**Independent Test**: Record expenses across categories and verify all analytics display correct data.

### Use Cases

- [X] T135 [P] [US4] Create GetCategoryBreakdownUseCase (calculate percentage per category for active cycle) in `chahriyti/lib/application/use_cases/statistics/get_category_breakdown_use_case.dart`
- [X] T136 [P] [US4] Create GetPredictionsUseCase (predict end-of-cycle balance and depletion date based on current spending rate) in `chahriyti/lib/application/use_cases/statistics/get_predictions_use_case.dart`
- [X] T137 [P] [US4] Create GetMonthlyComparisonUseCase (compare total spending across last 6 closed cycles) in `chahriyti/lib/application/use_cases/statistics/get_monthly_comparison_use_case.dart`
- [X] T138 [P] [US4] Create GetFinancialClassificationUseCase (calculate savings ratio, return tier: Legendary/Smart/Balanced/Spender/Danger/EarlyBankrupt) in `chahriyti/lib/application/use_cases/statistics/get_financial_classification_use_case.dart`

### Presentation

- [X] T139 [US4] Create StatisticsCubit (states: loading, loaded with all analytics data, error; loads all use cases on init) in `chahriyti/lib/presentation/statistics/cubits/statistics_cubit.dart`
- [X] T140 [P] [US4] Create CategoryBreakdownChart widget (pie/donut chart with category colors and percentage labels, RepaintBoundary wrapped) in `chahriyti/lib/presentation/statistics/widgets/category_breakdown_chart.dart`
- [X] T141 [P] [US4] Create PredictionCard widget (end-of-cycle balance prediction, depletion date warning if applicable) in `chahriyti/lib/presentation/statistics/widgets/prediction_card.dart`
- [X] T142 [P] [US4] Create MonthlyComparisonChart widget (bar chart comparing last 6 months, handles < 2 months with empty state) in `chahriyti/lib/presentation/statistics/widgets/monthly_comparison_chart.dart`
- [X] T143 [P] [US4] Create ClassificationBadge widget (tier name in Arabic, emoji icon, colored background matching tier) in `chahriyti/lib/presentation/statistics/widgets/classification_badge.dart`
- [X] T144 [US4] Create StatisticsPage assembling all analytics widgets (scrollable, lazy-loaded sections, empty states for insufficient data) in `chahriyti/lib/presentation/statistics/pages/statistics_page.dart`

### Tests for US4

- [X] T145 [P] [US4] Unit test GetCategoryBreakdownUseCase (correct percentages, empty data returns empty map, single category 100%) in `chahriyti/test/unit/application/use_cases/statistics/get_category_breakdown_use_case_test.dart`
- [X] T146 [P] [US4] Unit test GetPredictionsUseCase (normal prediction, depletion before cycle end, surplus scenario) in `chahriyti/test/unit/application/use_cases/statistics/get_predictions_use_case_test.dart`
- [X] T147 [P] [US4] Unit test GetFinancialClassificationUseCase (each tier boundary: >30%, 15-30%, balanced, spender, danger, bankrupt) in `chahriyti/test/unit/application/use_cases/statistics/get_financial_classification_use_case_test.dart`
- [X] T148 [P] [US4] Unit test GetMonthlyComparisonUseCase (6 months data, < 2 months returns empty, correct ordering) in `chahriyti/test/unit/application/use_cases/statistics/get_monthly_comparison_use_case_test.dart`
- [X] T149 [P] [US4] Widget test ClassificationBadge (correct tier name, correct emoji, correct color) in `chahriyti/test/widget/statistics/classification_badge_test.dart`
- [X] T150 [P] [US4] Widget test StatisticsPage (all sections render, empty states for insufficient data) in `chahriyti/test/widget/statistics/statistics_page_test.dart`

**Checkpoint**: User Story 4 complete — users can view detailed analytics, predictions, and their financial classification.

---

## Phase 7: User Story 5 — Debt Management (Priority: P2)

**Goal**: Users can add debts, make partial payments (deducted from balance), track remaining amounts. No debt notifications.

**Independent Test**: Add a debt, make a partial payment, verify balance deduction and debt update.

### Use Cases

- [X] T151 [P] [US5] Create AddDebtUseCase (validate creditor name non-empty, total > 0, paid >= 0 and <= total) in `chahriyti/lib/application/use_cases/debt/add_debt_use_case.dart`
- [X] T152 [P] [US5] Create MakeDebtPaymentUseCase (validate payment <= remaining, validate payment <= current balance, transaction-wrap: update debt paid_amount + create DebtPayment record) in `chahriyti/lib/application/use_cases/debt/make_debt_payment_use_case.dart`
- [X] T153 [P] [US5] Create GetDebtsUseCase (get all debts, filter active/paid) in `chahriyti/lib/application/use_cases/debt/get_debts_use_case.dart`

### Presentation

- [X] T154 [US5] Create DebtCubit (states: loading, loaded with debts list, paymentForm, paying, error) in `chahriyti/lib/presentation/debt/cubits/debt_cubit.dart`
- [X] T155 [US5] Create AddDebtPage (creditor name, total amount, already paid amount fields, save button) in `chahriyti/lib/presentation/debt/pages/add_debt_page.dart`
- [X] T156 [US5] Create DebtDetailPage (creditor info, total/paid/remaining amounts, payment input field, "ادفع" pay button, payment history list) in `chahriyti/lib/presentation/debt/pages/debt_detail_page.dart`

### Tests for US5

- [X] T157 [P] [US5] Unit test AddDebtUseCase (valid debt, zero total rejected, paid > total rejected) in `chahriyti/test/unit/application/use_cases/debt/add_debt_use_case_test.dart`
- [X] T158 [P] [US5] Unit test MakeDebtPaymentUseCase (valid payment, exceeds remaining rejected, exceeds balance rejected, full payment marks paid, transaction integrity) in `chahriyti/test/unit/application/use_cases/debt/make_debt_payment_use_case_test.dart`
- [X] T159 [P] [US5] Widget test DebtDetailPage (displays amounts, payment input, pay button, handles errors) in `chahriyti/test/widget/debt/debt_detail_page_test.dart`

**Checkpoint**: User Story 5 complete — users can track and pay down debts with accurate balance impact.

---

## Phase 8: User Story 6 — Savings Goals (Priority: P2)

**Goal**: Users can create savings goals, contribute money (deducted from balance), track progress. Goals persist across cycles.

**Independent Test**: Create a goal, add savings, verify progress bar and balance deduction.

### Use Cases

- [X] T160 [P] [US6] Create CreateGoalUseCase (validate name non-empty, target > 0) in `chahriyti/lib/application/use_cases/goal/create_goal_use_case.dart`
- [X] T161 [P] [US6] Create ContributeToGoalUseCase (validate amount <= current balance, update saved_amount, mark achieved if >= target, create SavingsContribution record) in `chahriyti/lib/application/use_cases/goal/contribute_to_goal_use_case.dart`
- [X] T162 [P] [US6] Create GetGoalsUseCase (get all goals, filter active/achieved) in `chahriyti/lib/application/use_cases/goal/get_goals_use_case.dart`

### Presentation

- [X] T163 [US6] Create GoalCubit (states: loading, loaded with goals list, contributionForm, contributing, error) in `chahriyti/lib/presentation/goal/cubits/goal_cubit.dart`
- [X] T164 [US6] Create AddGoalPage (name field, target amount field, save button) in `chahriyti/lib/presentation/goal/pages/add_goal_page.dart`
- [X] T165 [US6] Create GoalDetailPage (goal info, progress bar with percentage, contribution input field, "ادخر" save button, contribution history, congratulatory message when achieved) in `chahriyti/lib/presentation/goal/pages/goal_detail_page.dart`

### Tests for US6

- [X] T166 [P] [US6] Unit test CreateGoalUseCase (valid goal, empty name rejected, zero target rejected) in `chahriyti/test/unit/application/use_cases/goal/create_goal_use_case_test.dart`
- [X] T167 [P] [US6] Unit test ContributeToGoalUseCase (valid contribution, exceeds balance rejected, reaches target marks achieved, cross-cycle persistence) in `chahriyti/test/unit/application/use_cases/goal/contribute_to_goal_use_case_test.dart`
- [X] T168 [P] [US6] Widget test GoalDetailPage (progress bar, contribution form, achieved state) in `chahriyti/test/widget/goal/goal_detail_page_test.dart`

**Checkpoint**: User Story 6 complete — users can save toward goals with visual progress tracking.

---

## Phase 9: User Story 7 — Smart Notifications (Priority: P3)

**Goal**: Send positive, motivational push notifications based on spending patterns. Separate messages for active vs. non-activated users. Never debt-related. Never negative/blaming.

**Independent Test**: Verify notification content matches tone guidelines at all trigger points.

### Use Cases & Service

- [X] T169 [P] [US7] Create notification content generator (message templates for: spending milestones, weekly progress, cycle completion, non-activated user value messages — all in Arabic, all positive) in `chahriyti/lib/application/use_cases/notification/generate_notification_use_case.dart`
- [X] T170 [P] [US7] Create local notification scheduling service (schedule daily check, weekly summary, milestone triggers) in `chahriyti/lib/infrastructure/services/notification_service.dart`

### Presentation

- [X] T171 [US7] Integrate notification triggers with DashboardCubit (check thresholds on dashboard load: 70%+ spent, 1 week remaining, excellent performance) in `chahriyti/lib/presentation/home/cubits/dashboard_cubit.dart` (update existing)

### Tests for US7

- [X] T172 [P] [US7] Unit test notification content generator (verify all message templates are positive, no negative words, no debt mentions, correct Arabic formatting) in `chahriyti/test/unit/application/use_cases/notification/generate_notification_use_case_test.dart`
- [X] T173 [P] [US7] Unit test notification trigger logic (70% threshold, 1 week threshold, excellent performance threshold) in `chahriyti/test/unit/infrastructure/services/notification_service_test.dart`

**Checkpoint**: User Story 7 complete — motivational notifications enhance user engagement.

---

## Phase 10: User Story 8 — Weekly Challenges (Priority: P3)

**Goal**: Generate weekly savings challenges based on previous week's spending. Gamification to build savings habits.

**Independent Test**: Complete a week of tracking, verify relevant challenge is generated.

### Use Cases

- [X] T174 [US8] Create GenerateWeeklyChallengeUseCase (calculate previous week spending, generate target reduction of 1,000 DZD less, handle first week with generic challenge, mark completed if target met) in `chahriyti/lib/application/use_cases/challenge/generate_weekly_challenge_use_case.dart`

### Presentation

- [X] T175 [US8] Create WeeklyChallengeCard widget (challenge description, target amount, progress indicator, completion badge) in `chahriyti/lib/presentation/home/widgets/weekly_challenge_card.dart`
- [X] T176 [US8] Add WeeklyChallengeCard to HomePage (below safe balance card, show current challenge or "no challenge yet" empty state) in `chahriyti/lib/presentation/home/pages/home_page.dart` (update existing)

### Tests for US8

- [X] T177 [P] [US8] Unit test GenerateWeeklyChallengeUseCase (challenge from previous week data, first week generic challenge, completion detection) in `chahriyti/test/unit/application/use_cases/challenge/generate_weekly_challenge_use_case_test.dart`
- [X] T178 [P] [US8] Widget test WeeklyChallengeCard (renders challenge text, progress, completion state) in `chahriyti/test/widget/home/weekly_challenge_card_test.dart`

**Checkpoint**: User Story 8 complete — weekly challenges gamify the savings experience.

---

## Phase 11: User Story 9 — Financial Leak Detection (Priority: P3)

**Goal**: Detect recurring small expenses that add up to significant amounts and suggest savings.

**Independent Test**: Record multiple small recurring expenses and verify leak detection message appears.

### Use Cases

- [X] T179 [US9] Create DetectFinancialLeaksUseCase (analyze expenses by subcategory, identify categories with 5+ transactions totaling > 2,000 DZD, calculate potential savings at 50% reduction, compare with previous month for % increase alerts) in `chahriyti/lib/application/use_cases/statistics/detect_financial_leaks_use_case.dart`

### Presentation

- [X] T180 [US9] Create FinancialLeakCard widget (leak description in Arabic, amount spent, potential savings, month-over-month % change if applicable) in `chahriyti/lib/presentation/statistics/widgets/financial_leak_card.dart`
- [X] T181 [US9] Add FinancialLeakCard to StatisticsPage (below category breakdown, only visible when leaks detected) in `chahriyti/lib/presentation/statistics/pages/statistics_page.dart` (update existing)

### Tests for US9

- [X] T182 [P] [US9] Unit test DetectFinancialLeaksUseCase (detects leak with 5+ transactions, ignores low-count categories, correct savings calculation, month comparison) in `chahriyti/test/unit/application/use_cases/statistics/detect_financial_leaks_use_case_test.dart`
- [X] T183 [P] [US9] Widget test FinancialLeakCard (renders leak info, hidden when no leaks) in `chahriyti/test/widget/statistics/financial_leak_card_test.dart`

**Checkpoint**: User Story 9 complete — users discover hidden spending patterns.

---

## Phase 12: User Story 10 — Cycle Reset & Settings (Priority: P3)

**Goal**: Users can reset their financial cycle with motivational confirmation, and manage account settings.

**Independent Test**: Reset cycle, verify data cleared, new cycle started, historical data preserved.

### Use Cases

- [X] T184 [US10] Create ResetCycleUseCase (close current cycle, preserve in history, create new cycle from today, clear current cycle expenses but keep debts/goals) in `chahriyti/lib/application/use_cases/cycle/reset_cycle_use_case.dart`

### Presentation

- [X] T185 [US10] Create SettingsCubit (states: loaded, resetting, resetComplete, error) in `chahriyti/lib/presentation/settings/cubits/settings_cubit.dart`
- [X] T186 [US10] Create SettingsPage (reset cycle button with motivational confirmation dialog, salary display, activation status, app version) in `chahriyti/lib/presentation/settings/pages/settings_page.dart`

### Tests for US10

- [X] T187 [P] [US10] Unit test ResetCycleUseCase (current cycle closed, new cycle created, expenses cleared, goals preserved, debts preserved, historical cycles preserved for comparison) in `chahriyti/test/unit/application/use_cases/cycle/reset_cycle_use_case_test.dart`
- [X] T188 [P] [US10] Widget test SettingsPage (reset button triggers confirmation, confirm resets, cancel does nothing) in `chahriyti/test/widget/settings/settings_page_test.dart`

**Checkpoint**: User Story 10 complete — users can manage settings and reset cycles.

---

## Phase 13: User Story — Expense History (Supplementary to US2/US3)

**Goal**: Dedicated full history screen with paginated chronological list of all expenses, edit/delete for current cycle.

**Independent Test**: Navigate to history, browse paginated list, edit/delete an expense.

### Presentation

- [X] T189 [US3] Create HistoryCubit (states: loading, loaded with paginated expenses, loadingMore, error; handles pagination with limit/offset) in `chahriyti/lib/presentation/history/cubits/history_cubit.dart`
- [X] T190 [US3] Create ExpenseHistoryPage (paginated ListView.builder, each row: date, item, category icon, amount, swipe-to-delete for current cycle items, tap to edit, "load more" on scroll; empty state with illustration) in `chahriyti/lib/presentation/history/pages/expense_history_page.dart`

### Tests

- [X] T191 [P] [US3] Widget test ExpenseHistoryPage (renders paginated list, load more on scroll, empty state, edit/delete actions only for current cycle) in `chahriyti/test/widget/history/expense_history_page_test.dart`

**Checkpoint**: Full expense history with pagination complete.

---

## Phase 14: Polish & Cross-Cutting Concerns

**Purpose**: Performance optimization, final integration, cross-cutting quality improvements

### Performance Optimization

- [X] T192 [P] Audit all list widgets for ListView.builder usage (no ListView(children:[]) anywhere), verify pagination in ExpenseHistoryPage, RecentExpensesList, DebtSummaryCard, GoalProgressCard in all list widgets
- [X] T193 [P] Add RepaintBoundary to expensive widgets (ConsumptionBar, CategoryBreakdownChart, MonthlyComparisonChart, GoalProgressCard progress bars) in respective widget files
- [X] T194 [P] Verify all widgets use const constructors where possible, run `flutter analyze` for const suggestions across `chahriyti/lib/presentation/`
- [X] T195 [P] Verify no database calls or heavy computation in any build() method across `chahriyti/lib/presentation/`
- [X] T196 [P] Verify all BlocBuilder widgets use buildWhen for granular rebuilds (no full-screen rebuilds for partial state changes) across all cubit files

### Animation Polish

- [X] T197 [P] Polish onboarding page transitions (staggered entry: illustration 200ms, title 300ms, subtitle 400ms, button 500ms) in splash, salary setup, value proposition pages
- [X] T198 [P] Add subtle AnimatedContainer transitions for dashboard card value changes (balance, expenses, consumption bar) in home widgets

### Integration & Validation

- [X] T199 Verify GoRouter redirect logic handles all states correctly (first launch, activated, not activated, deep links) in `chahriyti/lib/presentation/shared/routing/app_router.dart`
- [X] T200 Verify DI injection registers all repositories, use cases, and cubits correctly in `chahriyti/lib/core/di/injection.dart`
- [X] T201 Run full test suite (`flutter test`) and verify all tests pass
- [X] T202 Run `flutter analyze` and fix all warnings/errors
- [X] T203 Build release APK with obfuscation (`flutter build apk --release --obfuscate --split-debug-info=build/debug-info`) and verify it runs
- [X] T204 Validate quickstart.md instructions by following them from scratch on a clean checkout

**Checkpoint**: All user stories complete, tested, optimized, and release-ready.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 completion — BLOCKS all user stories
- **US1 Onboarding (Phase 3)**: Depends on Phase 2 — first story, creates user and cycle
- **US2 Expense Recording (Phase 4)**: Depends on Phase 2 — needs active cycle from US1 in practice
- **US3 Dashboard (Phase 5)**: Depends on Phase 2 — benefits from US1 + US2 being complete for meaningful data
- **US4 Statistics (Phase 6)**: Depends on Phase 2 — needs expense data to be meaningful
- **US5 Debts (Phase 7)**: Depends on Phase 2 — independent of other stories
- **US6 Goals (Phase 8)**: Depends on Phase 2 — independent of other stories
- **US7 Notifications (Phase 9)**: Depends on US3 (dashboard triggers)
- **US8 Challenges (Phase 10)**: Depends on Phase 2 — needs expense data
- **US9 Leak Detection (Phase 11)**: Depends on US4 (statistics page)
- **US10 Settings (Phase 12)**: Depends on Phase 2 — independent
- **Expense History (Phase 13)**: Depends on US2 (expense data)
- **Polish (Phase 14)**: Depends on all desired user stories being complete

### User Story Dependencies

```
Phase 1: Setup
    │
Phase 2: Foundation (BLOCKS ALL)
    │
    ├── Phase 3: US1 Onboarding (P1) 🎯 MVP
    │       │
    ├── Phase 4: US2 Expenses (P1) ←── needs active cycle
    │       │
    ├── Phase 5: US3 Dashboard (P1) ←── benefits from US1 + US2
    │       │
    │   ┌───┴───────────────────┐
    │   │                       │
    ├── Phase 6: US4 Stats (P2) Phase 13: History
    │       │
    │   Phase 11: US9 Leaks (P3)
    │
    ├── Phase 7: US5 Debts (P2) — independent
    ├── Phase 8: US6 Goals (P2) — independent
    ├── Phase 9: US7 Notifications (P3) ←── needs US3
    ├── Phase 10: US8 Challenges (P3) — independent
    ├── Phase 12: US10 Settings (P3) — independent
    │
Phase 14: Polish
```

### Within Each User Story

1. Use cases (domain logic) first
2. Cubits (state management) second
3. Widgets (UI components) third — parallelizable
4. Pages (assembly) fourth
5. Tests throughout — unit tests parallel with use cases, widget tests after widgets

### Parallel Opportunities

- All Phase 1 tasks marked [P] can run in parallel (T002-T009, T013-T018, T020-T024)
- All Phase 2 table definitions (T027-T035) can run in parallel
- All Phase 2 entities (T037-T043) can run in parallel
- All Phase 2 repository interfaces (T044-T049) can run in parallel
- All Phase 2 DAOs (T050-T055) can run in parallel
- All Phase 2 repository impls (T056-T061) can run in parallel
- After Phase 2: US5 Debts, US6 Goals, US8 Challenges, US10 Settings can all run in parallel
- Within any story: widgets marked [P] can run in parallel

---

## Parallel Example: Phase 2 (Foundation)

```
# Batch 1 — All tables in parallel:
T027: financial_cycles_table.dart
T028: expenses_table.dart
T029: additional_incomes_table.dart
T030: debts_table.dart
T031: debt_payments_table.dart
T032: savings_goals_table.dart
T033: savings_contributions_table.dart
T034: weekly_challenges_table.dart
T035: license_activations_table.dart

# Batch 2 — All entities in parallel:
T037-T043: All 7 Freezed entities

# Batch 3 — All repo interfaces + DAOs in parallel:
T044-T049: 6 repository interfaces
T050-T055: 6 DAOs

# Batch 4 — All repo impls + services in parallel:
T056-T061: 6 repository implementations
T062-T064: 3 infrastructure services
```

## Parallel Example: User Story 3 (Dashboard)

```
# Batch 1 — Use cases in parallel:
T111: GetDashboardDataUseCase
T112: GetSafeBalanceUseCase
T113: GetExpensesUseCase
T125: AddIncomeUseCase

# Batch 2 — All widgets in parallel:
T115: BalanceCard
T116: ExpensesCard
T117: DaysRemainingWidget
T118: DailyAverageWidget
T119: ConsumptionBar
T120: SafeBalanceCard
T121: GoalProgressCard
T122: DebtSummaryCard

# Batch 3 — Assembly (sequential):
T123: RecentExpensesList
T124: HomePage
```

---

## Implementation Strategy

### MVP First (User Stories 1-3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundation (CRITICAL — blocks all stories)
3. Complete Phase 3: US1 Onboarding + Activation
4. **STOP and VALIDATE**: Test onboarding flow end-to-end
5. Complete Phase 4: US2 Expense Recording
6. Complete Phase 5: US3 Dashboard
7. **STOP and VALIDATE**: Full MVP is usable — users can onboard, record expenses, and see dashboard
8. Deploy MVP for testing

### Incremental Delivery

1. **MVP** (Phases 1-5): Onboarding + Expenses + Dashboard → Core value delivered
2. **Analytics** (Phase 6): Statistics + Classification → Deeper insights
3. **Financial Tools** (Phases 7-8): Debts + Goals → Complete financial management
4. **Engagement** (Phases 9-11): Notifications + Challenges + Leaks → Retention & behavioral change
5. **Utilities** (Phases 12-13): Settings + History → Quality of life
6. **Ship** (Phase 14): Polish + Performance audit → Release ready

### Single Developer Strategy (Recommended)

Follow phases sequentially in priority order:
1. Setup → Foundation → US1 → US2 → US3 (MVP)
2. US4 → US5 → US6 (Core features)
3. US7 → US8 → US9 → US10 → History (Polish)
4. Final polish phase

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [Story] label maps task to specific user story for traceability
- Each user story is independently completable and testable
- All monetary values in centimes — use Money value object everywhere
- All UI text in Arabic — use TextAlign.start, never .left/.right
- All lists MUST use ListView.builder with pagination (Constitution VII)
- No print() in production — use logger (Constitution VII)
- Every use case = one business operation (Constitution V)
- Widgets MUST NOT contain business logic (Constitution VI)
- Commit after each task or logical group
- Run `dart run build_runner build` after modifying Drift/Freezed files
- Run `flutter test` and `flutter analyze` regularly
