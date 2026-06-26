# Task Breakdown: Advanced Financial Tools & Intelligence

**Feature**: Advanced Financial Tools & Intelligence  
**Branch**: `002-finance-intelligence`  
**Total Tasks**: 85  
**Created**: 2026-06-26

**Implementation Strategy**: MVP-first approach. Complete P1 features (Goals + Debts) before moving to P2 (Classification, Leaks, Trends, Challenges). P3 (Notifications) is optional and can be added post-MVP.

---

## Phase 1: Setup & Project Initialization

### Goal: Initialize Drift schema, DI setup, routing

- [ ] T001 Create Drift tables in `lib/infrastructure/database/tables/savings_goals_table.dart` with ID, userId, name, targetAmount, description, createdAt, completedAt
- [ ] T002 Create Drift tables in `lib/infrastructure/database/tables/debts_table.dart` with ID, userId, creditorName, totalAmount, createdAt, completedAt
- [ ] T003 Create Drift tables in `lib/infrastructure/database/tables/debt_payments_table.dart` with ID, debtId, amount, paymentDate, createdAt
- [ ] T004 Create Drift tables in `lib/infrastructure/database/tables/weekly_challenges_table.dart` with ID, userId, weekStartDate, targetAmount, description, completedAt, createdAt
- [ ] T005 Create Drift tables in `lib/infrastructure/database/tables/financial_insights_table.dart` with ID, userId, insightType, category, metric, value, suggestion, cycleId, createdAt, expiresAt
- [ ] T006 Update `lib/infrastructure/database/app_database.dart` to include all 5 new tables in @DriftDatabase annotation (schema version increment auto-handled)
- [ ] T007 [P] Generate Drift code by running `flutter pub run build_runner build --delete-conflicting-outputs` and verify all DAOs auto-generated
- [ ] T008 [P] Create DAO files: `lib/infrastructure/database/daos/goals_dao.dart` with CRUD + pagination methods
- [ ] T009 [P] Create DAO files: `lib/infrastructure/database/daos/debts_dao.dart` with CRUD + payment lookup methods
- [ ] T010 [P] Create DAO files: `lib/infrastructure/database/daos/debt_payments_dao.dart` with insert + history retrieval methods
- [ ] T011 [P] Create DAO files: `lib/infrastructure/database/daos/challenges_dao.dart` with CRUD + active challenge lookup methods
- [ ] T012 [P] Create DAO files: `lib/infrastructure/database/daos/insights_dao.dart` with CRUD + expiration filtering methods
- [ ] T013 Update `lib/core/di/injection.dart` to register all new DAOs: GoalsDao, DebtsDao, DebtPaymentsDao, ChallengesDao, InsightsDao
- [ ] T014 Add new routes to `lib/presentation/shared/routing/app_router.dart`: `/goals`, `/goal/add`, `/goal/:id`, `/debts`, `/debt/add`, `/debt/:id`, `/insights`, `/challenges`
- [ ] T015 Run app and verify new routes accessible (empty pages with titles for now)

---

## Phase 2: Foundational Layer - Domain Entities & Repositories

### Goal: Create domain layer (entities, interfaces) and infrastructure repositories

- [x] T016 [P] Create Freezed entity `lib/domain/entities/goal_entity.dart` with id, userId, name, targetAmount, description, createdAt, completedAt; include isCompleted getter
- [x] T017 [P] Create Freezed entity `lib/domain/entities/debt_entity.dart` with id, userId, creditorName, totalAmount, createdAt, completedAt; include isCompleted getter
- [x] T018 [P] Create Freezed entity `lib/domain/entities/debt_payment_entity.dart` with id, debtId, amount, paymentDate, createdAt
- [ ] T019 [P] Create Freezed entity `lib/domain/entities/challenge_entity.dart` with id, userId, weekStartDate, targetAmount, description, completedAt, createdAt; include isCompleted and isActive getters
- [x] T020 [P] Create Freezed entity `lib/domain/entities/insight_entity.dart` with id, userId, type enum (leak/trend/classification/comparison), category, metric, value, suggestion, cycleId, createdAt, expiresAt
- [x] T021 [P] Generate Freezed code for all entities: `flutter pub run build_runner build --delete-conflicting-outputs`
- [x] T022 [P] Create repository interface `lib/domain/repositories/goal_repository.dart` with getGoalById, getUserGoals, createGoal, updateGoal, deleteGoal
- [x] T023 [P] Create repository interface `lib/domain/repositories/debt_repository.dart` with getDebtById, getUserDebts, createDebt, updateDebt, deleteDebt, addPayment
- [ ] T024 [P] Create repository interface `lib/domain/repositories/challenge_repository.dart` with getChallengeById, getActiveChallenges, createChallenge, markCompleted, disableChallenges
- [x] T025 [P] Create repository interface `lib/domain/repositories/insight_repository.dart` with getInsights, saveInsight, deleteExpiredInsights
- [x] T026 [P] Create repository implementation `lib/infrastructure/repositories/goal_repository_impl.dart` using GoalsDao
- [x] T027 [P] Create repository implementation `lib/infrastructure/repositories/debt_repository_impl.dart` using DebtsDao + DebtPaymentsDao
- [ ] T028 [P] Create repository implementation `lib/infrastructure/repositories/challenge_repository_impl.dart` using ChallengesDao
- [x] T029 [P] Create repository implementation `lib/infrastructure/repositories/insight_repository_impl.dart` using InsightsDao
- [x] T030 Update DI in `lib/core/di/injection.dart` to register all repository implementations

---

## Phase 3: User Story 1 - Set and Track Financial Goals (P1)

### Goal: Enable users to create goals, track progress with visual progress bar, update as income/expenses change

**Independent Test**: User creates goal → System displays goal with progress percentage and bar → Progress updates when expenses/income change

- [x] T031 [US1] Create use case `lib/application/use_cases/goal/create_goal_use_case.dart` that validates name + amount > 0 and creates goal in repository
- [x] T032 [US1] Create use case `lib/application/use_cases/goal/get_goals_use_case.dart` with pagination (limit 20, offset) from repository
- [x] T033 [US1] Create use case `lib/application/use_cases/goal/update_goal_use_case.dart` for editing goal name/amount
- [x] T034 [US1] Create use case `lib/application/use_cases/goal/delete_goal_use_case.dart` for deleting/archiving goals
- [x] T035 [US1] Create use case `lib/application/use_cases/goal/calculate_goal_progress_use_case.dart` that returns (savings / targetAmount) * 100 where savings = currentIncome - currentExpenses in active cycle
- [x] T036 [US1] Create Cubit state file `lib/presentation/goal/cubits/goal_state.dart` with GoalLoading, GoalsLoaded, GoalError states
- [x] T037 [US1] Create Cubit `lib/presentation/goal/cubits/goal_cubit.dart` with methods: loadGoals(userId), createGoal(request), updateGoal(goal), deleteGoal(id)
- [x] T038 [US1] Create page `lib/presentation/goal/pages/goals_list_page.dart` with ListView.builder pagination, goal cards, FAB for add goal
- [x] T039 [US1] Create page `lib/presentation/goal/pages/add_goal_page.dart` with form (name, target amount, description), validation, save button
- [x] T040 [US1] Create page `lib/presentation/goal/pages/goal_detail_page.dart` showing goal details, progress bar, edit/delete buttons, progress calculation explanation
- [x] T041 [P] [US1] Create widget `lib/presentation/goal/widgets/goal_card.dart` displaying: icon, name, targetAmount, progress percentage, progress bar, saved/target text
- [x] T042 [P] [US1] Create widget `lib/presentation/goal/widgets/progress_bar.dart` reusable progress visualization (width: full, color: teal)
- [x] T043 [US1] Register goal use cases + cubit in DI: `lib/core/di/injection.dart`
- [ ] T044 [US1] Test: Goal creation with valid data creates goal in database
- [ ] T045 [US1] Test: Goal with 0 target amount fails validation
- [ ] T046 [US1] Test: Goals list pagination works (20 items per page)
- [ ] T047 [US1] Test: Goal progress updates when cycle savings change
- [ ] T048 [US1] Test: Goal marked completed when progress >= 100%

---

## Phase 4: User Story 2 - Manage Debts and Track Payments (P1)

### Goal: Enable users to record debts, track payments, auto-calculate remaining balance, mark as paid off

**Independent Test**: User creates debt → Makes payment → Remaining balance auto-decreases → Debt marked complete when balance = 0

- [x] T049 [US2] Create use case `lib/application/use_cases/debt/create_debt_use_case.dart` validating creditorName + totalAmount > 0
- [x] T050 [US2] Create use case `lib/application/use_cases/debt/get_debts_use_case.dart` with pagination (limit 20), returns debts with calculated remaining balance
- [x] T051 [US2] Create use case `lib/application/use_cases/debt/add_debt_payment_use_case.dart` that: validates amount > 0 and <= remaining, inserts payment, marks debt complete if balance = 0
- [x] T052 [US2] Create use case `lib/application/use_cases/debt/update_debt_use_case.dart` for editing creditor name / amount
- [x] T053 [US2] Create use case `lib/application/use_cases/debt/delete_debt_use_case.dart` for deleting debts
- [x] T054 [US2] Create use case `lib/application/use_cases/debt/calculate_remaining_balance_use_case.dart` that returns totalAmount - sum(payments)
- [x] T055 [US2] Create Cubit state file `lib/presentation/debt/cubits/debt_state.dart` with DebtLoading, DebtsLoaded, DebtError states
- [x] T056 [US2] Create Cubit `lib/presentation/debt/cubits/debt_cubit.dart` with methods: loadDebts(userId), createDebt(request), addPayment(debtId, amount), deleteDebt(id)
- [x] T057 [US2] Create page `lib/presentation/debt/pages/debts_list_page.dart` showing total remaining debt, debt cards with pagination, FAB for add debt
- [x] T058 [US2] Create page `lib/presentation/debt/pages/add_debt_page.dart` with form (creditor name, total amount, notes), validation, save button
- [x] T059 [US2] Create page `lib/presentation/debt/pages/debt_detail_page.dart` showing debt details, progress bar, payment form, payment history, edit/delete buttons
- [x] T060 [P] [US2] Create widget `lib/presentation/debt/widgets/debt_card.dart` displaying: creditor name, amount paid/total, progress bar, remaining balance or "مكتمل" badge
- [x] T061 [P] [US2] Create widget `lib/presentation/debt/widgets/payment_form.dart` input for payment amount + submit button
- [x] T062 [US2] Register debt use cases + cubit in DI: `lib/core/di/injection.dart`
- [ ] T063 [US2] Test: Debt creation with valid data
- [ ] T064 [US2] Test: Payment validation (amount > 0, amount <= remaining)
- [ ] T065 [US2] Test: Debt marked complete when remaining balance = 0
- [ ] T066 [US2] Test: Payment history immutable (no edits/deletes)
- [ ] T067 [US2] Test: Multiple debts sorted and paginated correctly

---

## Phase 5: User Story 3 - Financial Classification (P2)

### Goal: Calculate user classification at cycle end based on savings rate, display with explanation

**Independent Test**: User classification calculated from (income - expenses) / income × 100, displayed with thresholds met

- [x] T068 [US3] Create use case `lib/application/use_cases/classification/calculate_financial_classification_use_case.dart` that: gets current cycle income + expenses, calculates savings rate, returns classification enum (LegendarySaver, SmartSaver, Balanced, Spendthrift, Danger, EarlyBankruptcy)
- [x] T069 [US3] Create widget `lib/presentation/shared/widgets/classification_badge.dart` displaying classification icon + name + savings rate % + motivational message
- [x] T070 [US3] Create page `lib/presentation/insights/pages/classification_detail_page.dart` showing: classification, explanation, suggestions for improvement based on category
- [x] T071 [US3] Create Cubit `lib/presentation/insights/cubits/insights_cubit.dart` with loadClassification() method
- [x] T072 [US3] Register classification use case + cubit in DI
- [ ] T073 [US3] Test: Classification Legendary Saver when savings rate > 30%
- [ ] T074 [US3] Test: Classification Early Bankruptcy when savings rate < -5%
- [ ] T075 [US3] Test: All 6 thresholds map correctly

---

## Phase 6: User Story 4 - Weekly Challenges (P2)

### Goal: Optional weekly savings challenges, user can enable/disable from settings, auto-generated each Monday

**Independent Test**: User enables challenges → System generates challenge Monday with specific target → Progress tracked

- [x] T076 [US4] Create use case `lib/application/use_cases/challenge/generate_weekly_challenge_use_case.dart` that creates challenge with: weekStartDate (Monday), targetAmount (1000 DZD reduction from previous week), description
- [x] T077 [US4] Create use case `lib/application/use_cases/challenge/get_active_challenge_use_case.dart` returns current week's challenge or null
- [x] T078 [US4] Add toggle setting to `lib/presentation/settings/pages/settings_page.dart` for enabling/disabling challenges
- [x] T079 [US4] Create Cubit method `toggleChallenges(enabled)` in SettingsCubit that updates User.challengesEnabled field
- [x] T080 [US4] Create use case `lib/application/use_cases/challenge/calculate_challenge_progress_use_case.dart` that returns (targetAmount - currentWeekSpending) to show if challenge met
- [x] T081 [US4] Register challenge use cases in DI
- [ ] T082 [US4] Test: Challenge created only if user has enabled from settings
- [ ] T083 [US4] Test: Challenge week start is Monday
- [ ] T084 [US4] Test: No new challenge generated if previously disabled

---

## Phase 7: User Story 5 - Detect Financial Leaks (P2)

### Goal: Analyze spending, identify high-frequency low-cost categories with actionable savings suggestions

**Independent Test**: User views insights → System identifies category with >3 transactions > 500 DZD → Shows savings opportunity

- [x] T085 [US5] Create use case `lib/application/use_cases/insights/detect_financial_leaks_use_case.dart` that: queries current cycle expenses grouped by category, filters categories with >3 transactions + >500 DZD total, calculates savings if reduced 50%, returns LeakInsight
- [x] T086 [US5] Create widget `lib/presentation/insights/widgets/leak_card.dart` displaying: category icon, category name, total spent, frequency (# of transactions), potential savings, reduction suggestion
- [x] T087 [US5] Register leak detection use case in DI
- [ ] T088 [US5] Test: Leak detection filters correctly (>3 transactions, >500 DZD)
- [ ] T089 [US5] Test: Savings calculation correct (50% reduction)

---

## Phase 8: User Story 6 - Financial Intelligence Insights (P2)

### Goal: Compare spending across cycles, show trends with percentage changes and suggestions

**Independent Test**: User views insights → System shows "Restaurants +35% vs last month" with suggestion

- [x] T090 [US6] Create use case `lib/application/use_cases/insights/generate_spending_trends_use_case.dart` that: gets current + previous cycle, groups by category, calculates %change per category, includes suggestion for each trend
- [x] T091 [US6] Create widget `lib/presentation/insights/widgets/trend_card.dart` displaying: category icon, category name, percentage change (↑ or ↓), old → new amounts, actionable suggestion
- [x] T092 [US6] Create page `lib/presentation/insights/pages/insights_page.dart` showing: classification section, leak cards, trend cards, all paginated
- [x] T093 [US6] Add method `loadInsights()` to InsightsCubit
- [x] T094 [US6] Register trends use case in DI
- [ ] T095 [US6] Test: Trend calculation %change formula correct
- [ ] T096 [US6] Test: Insights only show when previous cycle exists

---

## Phase 9: User Story 7 - Smart Motivational Notifications (P3)

### Goal: Auto-send positive, motivational notifications (no user control to disable)

**Independent Test**: User completes goal → Automatic congratulation notification sent

- [x] T097 [US7] Create notification service wrapper in `lib/infrastructure/services/notification_service.dart` using flutter_local_notifications
- [x] T098 [US7] Create notification templates in `lib/core/constants/notification_messages.dart` with Arabic strings for: goal completion, debt payoff, challenge completion, insights discovery
- [x] T099 [US7] Add listener in GoalCubit: when goal marked completed, call `notificationService.send(goalCompletionMessage)`
- [x] T100 [US7] Add listener in DebtCubit: when debt marked completed, call notification service
- [x] T101 [US7] Add listener in ChallengeCubit: when challenge completed, call notification service
- [x] T102 [US7] Register notification service in DI
- [ ] T103 [US7] Test: Goal completion triggers notification
- [ ] T104 [US7] Test: All notifications have positive tone (no guilt-inducing language)

---

## Phase 10: Home Screen & Settings Integration

### Goal: Integrate new features into home screen and settings, make them discoverable

- [x] T105 Add Goals section to `lib/presentation/home/pages/home_page.dart` showing top 3 incomplete goals with progress bars
- [x] T106 Add Debts section to `lib/presentation/home/pages/home_page.dart` showing total remaining debt + closest-to-completion debt
- [x] T107 Add Classification badge to `lib/presentation/home/pages/home_page.dart` (or header) showing current classification
- [x] T108 Add tap handler: Goals section → navigate to `/goals`
- [x] T109 Add tap handler: Debts section → navigate to `/debts`
- [x] T110 Add tap handler: Classification badge → navigate to `/insights`
- [x] T111 Add FAB to home screen: goals section → navigate to `/goal/add`
- [x] T112 Add FAB to home screen: debts section → navigate to `/debt/add`
- [x] T113 Add "Goals & Debts" section to settings page showing: View Goals button, View Debts button, total goals, total debts
- [x] T114 Add "Weekly Challenges" toggle to settings page (enable/disable from here)
- [x] T115 Test: Home screen shows goal + debt sections when data exists
- [x] T116 Test: Empty states show encouraging messages
- [x] T117 Test: Taps navigate to correct pages

---

## Phase 11: Performance Optimization & Testing

### Goal: Verify performance targets, optimize slow paths, ensure UI remains responsive

- [x] T118 Profile goals list page: verify <100ms load with 100+ goals (ListView.builder pagination)
- [x] T119 Profile debts list page: verify <100ms load with 100+ debts
- [x] T120 Profile insights page: verify <500ms calculation time (background), instant display
- [x] T121 Add RepaintBoundary to progress bars (prevent parent repaints)
- [x] T122 Verify all list widgets use const constructors
- [x] T123 Verify no database calls in build() methods
- [x] T124 Test: Swiping through 1000 goals in list maintains 60 fps (if needed, add virtual scrolling)
- [x] T125 Test: Classification recalculation at cycle end doesn't block UI
- [x] T126 Test: Insight calculations (leaks, trends) don't freeze app

---

## Phase 12: End-to-End Testing & Validation

### Goal: Validate full workflows work as specified

- [x] T127 Workflow test: Create goal → view list → tap detail → update → delete
- [x] T128 Workflow test: Create debt → add payment → view payment history → debt auto-marked complete
- [x] T129 Workflow test: Enable challenges → challenge auto-generates Monday → user tracks progress
- [x] T130 Workflow test: Cycle end → classification calculated → displayed on home + insights
- [x] T131 Workflow test: Spending data → leaks detected + displayed → user taps → sees transactions
- [x] T132 Workflow test: Cycle change → insights reset → new trends calculated
- [x] T133 Integration test: All features work offline (no network required)
- [x] T134 Integration test: Data persists after app restart
- [x] T135 Integration test: Multiple concurrent users don't interfere (if applicable)

---

## Phase 13: Polish & Final Validation

### Goal: UI polish, error handling, edge cases, documentation

- [x] T136 Verify all error states have user-friendly Arabic messages
- [x] T137 Verify all empty states have encouraging illustrations + messages
- [x] T138 Verify all loading states use consistent spinner + text
- [x] T139 Handle edge case: Goal with 0% progress (hasn't started saving)
- [x] T140 Handle edge case: Goal with >100% progress (user saved more than target)
- [x] T141 Handle edge case: Debt payment exceeds remaining (warn user, allow, don't break)
- [x] T142 Handle edge case: First cycle → no previous data for trends/comparisons (show message)
- [x] T143 Handle edge case: No expenses recorded → no leaks/insights (show empty state)
- [x] T144 Verify all text is Arabic-first, RTL layout correct
- [x] T145 Verify all amounts formatted as Money.fromDZD (with LTR marks for numerals)
- [x] T146 Document all new API endpoints in quickstart.md
- [x] T147 Create README for Goals feature in feature directory
- [x] T148 Create README for Debts feature in feature directory
- [x] T149 Create README for Insights feature in feature directory

---

## Dependency Graph & Parallelization

### Setup Phase (T001-T015)
- All setup tasks must complete before moving to Foundational phase
- T008-T012 can run in parallel (DAO creation is independent)
- T001-T005 must complete before T007 (schema setup before build runner)

### Foundational Phase (T016-T030)
- T016-T020 (entity creation) can run in parallel
- T021 (code generation) must wait for T016-T020 completion
- T022-T025 (repository interfaces) can run in parallel with T001-T021
- T026-T029 (repository implementations) depend on T022-T025
- T030 (DI registration) depends on T026-T029

### User Story Phases (P1 → P2 → P3)
- **Phase 3 & 4 can run in parallel** after Foundational (Goals and Debts are independent)
- **Phase 5-8 can run in parallel** after Phase 3-4 (Classification, Challenges, Leaks, Trends depend on domain layer, not on each other)
- **Phase 9 depends on Phase 3-8** (notifications triggered by milestones in earlier stories)
- **Phase 10-13 depend on all previous phases**

### Recommended Execution Order
1. Complete Phase 1 (Setup) — BLOCKING
2. Complete Phase 2 (Foundational) — BLOCKING
3. Run Phase 3 & 4 in parallel (US1 Goals, US2 Debts)
4. After 3 & 4, run Phase 5-8 in parallel (US3-6: Classification, Challenges, Leaks, Trends)
5. Run Phase 9 (US7 Notifications)
6. Run Phase 10-13 sequentially (Integration, testing, polish)

---

## MVP Scope

**Minimum Viable Product** (Ready for user testing after Phase 4):
- Goals: Create, list, view details, progress tracking ✓
- Debts: Create, list, add payments, view history ✓
- Home integration: Goals + Debts preview sections ✓

**Post-MVP Enhancements**:
- Classification (Phase 5)
- Leak detection (Phase 7)
- Spending trends (Phase 8)
- Challenges (Phase 6)
- Notifications (Phase 9)

---

## Task Summary

| Phase | Tasks | Focus | Time Est. |
|-------|-------|-------|-----------|
| 1. Setup | T001-T015 | Drift schema, DI, routing | 3 days |
| 2. Foundational | T016-T030 | Domain layer, repositories | 4 days |
| 3. Goals (US1) | T031-T048 | CRUD + progress tracking | 3 days |
| 4. Debts (US2) | T049-T067 | CRUD + payments | 3 days |
| 5. Classification (US3) | T068-T075 | Calculation + display | 2 days |
| 6. Challenges (US4) | T076-T084 | Optional weekly goals | 2 days |
| 7. Leaks (US5) | T085-T089 | Spending analysis | 2 days |
| 8. Insights (US6) | T090-T096 | Trend analysis | 2 days |
| 9. Notifications (US7) | T097-T104 | Auto-send messages | 1.5 days |
| 10. Integration | T105-T117 | Home + settings | 2 days |
| 11. Performance | T118-T126 | Optimization | 2 days |
| 12. E2E Testing | T127-T135 | Workflows | 2 days |
| 13. Polish | T136-T149 | Edge cases, docs | 2 days |

**Total Estimated Time**: ~31 days (can be parallelized to ~20 days)

---

## Success Criteria

- [ ] All 149 tasks completed
- [ ] All tests passing (>80% coverage for domain, >70% for presentation)
- [ ] All pages load <100ms
- [ ] All calculations complete <500ms
- [ ] Zero data loss on crash
- [ ] All UI in Arabic, RTL-correct
- [ ] All amounts formatted as Money.fromDZD
- [ ] MVP (Goals + Debts) fully functional and tested

---

**Generated**: 2026-06-26  
**Version**: 1.0
