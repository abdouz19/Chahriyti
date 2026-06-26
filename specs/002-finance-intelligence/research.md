# Phase 0 Research: Advanced Financial Tools & Intelligence

**Date**: 2026-06-26  
**Status**: Complete  
**Focus**: Technology decisions, patterns, and best practices for financial features

## 1. Financial Visualization Library

### Decision: `fl_chart` (v0.68.0+)

**Rationale**:
- Lightweight Flutter chart library, proven stable across major Flutter versions
- Excellent Arabic/RTL support (critical for Algerian app)
- Minimal performance overhead; works well with Drift data
- Zero external dependencies (no web APIs, pure Dart/Flutter)
- Active maintenance and community

**Why Selected Over Alternatives**:
- **Custom charts** (rejected): Too much code for visualization; diverts focus from core logic
- **charts_flutter** (rejected): Google-maintained but heavier, less RTL-friendly
- **syncfusion_flutter_charts** (rejected): Overkill for our use case; adds unnecessary size

**Integration Pattern**:
- Charts displayed in widgets, receive data from Cubit state
- Data transformed to ChartData model in Presentation layer
- All heavy calculations (aggregations) done in Application layer

**Performance Impact**: Negligible; charts reuse existing expense data queries

---

## 2. Financial Classification Algorithm

### Decision: Savings Rate Percentage Calculation (End-of-Cycle)

**Rationale**:
- Savings Rate = (Total Income - Total Expenses) / Total Income × 100%
- Calculated once per cycle end (not real-time)
- Thresholds clearly defined: >30%, 15-30%, 5-15%, 0-5%, 0 to -5%, <-5%
- Simple, deterministic, easy to explain to users

**Why Selected Over Alternatives**:
- **Weekly calculation** (rejected): Too frequent, confusing for users; data often incomplete mid-week
- **Rolling 30-day** (rejected): Overly complex; app is cycle-based, not calendar-based
- **Machine learning** (rejected): Overkill, privacy concerns, adds unneeded complexity

**Algorithm Implementation**:
- Runs in `CalculateFinancialClassificationUseCase` at cycle end
- Reads final income and expense totals from database
- Returns classification enum (LegendarySaver, SmartSaver, etc.)
- Stored in User entity for quick retrieval

---

## 3. Financial Leak Detection Algorithm

### Decision: High-Frequency, Low-Cost Category Analysis

**Rationale**:
- Identifies categories where small individual purchases add up significantly
- Filters: >3 transactions, >500 DZD total in category, >5% of weekly spending
- Example: 6200 DZD on coffee (31 purchases × 200 DZD) = 12% of weekly budget
- Actionable: "Reduce to half for savings of 3100 DZD"

**Why Selected Over Alternatives**:
- **All-transactions analysis** (rejected): Too noisy; includes legitimate bulk purchases
- **ML anomaly detection** (rejected): Overly complex for a simple problem
- **Fixed category limits** (rejected): Inflexible; ignores user's actual spending patterns

**Algorithm Implementation**:
- Runs in `DetectFinancialLeaksUseCase` (triggered on insights page load)
- Queries expenses from current cycle, groups by category
- Filters: transactions > 3, total > 500 DZD, frequency analysis
- Returns list of Leak insights with category, total, frequency, suggestion

---

## 4. Spending Trend Detection

### Decision: Category Comparison (Current vs Previous Cycle)

**Rationale**:
- Compares same category spending across cycles (e.g., Restaurants: 8500 DZD → 11475 DZD = +35%)
- Shows both positive (cost reduction) and negative (cost increase) trends
- Paired with actionable suggestions (meal planning, etc.)

**Why Selected Over Alternatives**:
- **Moving averages** (rejected): Overly mathematical; hard to explain to non-technical users
- **Real-time trend alerts** (rejected): Confusing mid-cycle; cycle-based is clearer
- **Fixed category budgets** (rejected): Users may not have realistic budgets at start

**Algorithm Implementation**:
- Runs in `GenerateSpendingTrendsUseCase` (triggered on insights page load)
- Reads current and previous cycle totals per category
- Calculates percentage change: (Current - Previous) / Previous × 100
- Returns list of Trend insights with actionable suggestions

---

## 5. Challenge Generation Logic

### Decision: Optional Feature (User-Configurable) with Week-to-Date Rolling Averages

**Rationale**:
- Challenges are optional; users enable/disable from settings
- For new users (week 1), use rolling average of current week spending
- For subsequent weeks, use previous week's spending as baseline
- Challenge: "Spend less than [previous week/average] by 1000 DZD"
- Motivational, not punitive

**Why Selected Over Alternatives**:
- **Fixed challenges** (rejected): Generic, not personalized
- **ML-based challenges** (rejected): Overly complex; simple baseline works
- **Disabled by default** (accepted): Avoids decision fatigue; users opt-in if interested

**Implementation**:
- User toggles challenges on/off in Settings
- If enabled, `GenerateWeeklyChallengeUseCase` runs every Monday 00:00
- Calculates baseline (previous week spending, or rolling average for week 1)
- Generates challenge with 1000 DZD target reduction

---

## 6. Notification Architecture

### Decision: Automatic, Non-Optional Notifications with Positive Tone

**Rationale**:
- Notifications sent automatically to maintain engagement
- No user control to disable (aligns with engagement-first philosophy)
- All notifications follow "positive, motivational, value-adding" principle
- Types: milestone celebrations, insights discoveries, tips

**Why Selected Over Alternatives**:
- **User-configurable notifications** (rejected): Users procrastinate on settings; engagement drops
- **Silent mode** (accepted): Respects system-level do-not-disturb, but app-level controls off
- **Scheduled notifications** (accepted): Delivered at 8am or user's preferred time (future enhancement)

**Implementation Pattern**:
- Notifications triggered by Cubit state changes (goal completed, debt paid, etc.)
- Message templates in constants/strings.dart (supports Arabic)
- Delivered via system notification API (no custom implementation needed for MVP)

---

## 7. Data Migration & Schema Versioning

### Decision: Drift Explicit Migrations with Version Tracking

**Rationale**:
- Existing app uses Drift migrations; extend same pattern
- Add 5 new Drift tables (Goals, Debts, DebtPayments, Challenges, Insights)
- Version increment: app_database.dart schema version +1
- Safe rollback: migrations are scripted, not auto-applied

**Why Selected Over Alternatives**:
- **Schema inference** (rejected): Unsafe; no rollback capability
- **Cloud migrations** (rejected): Violates offline-first principle

**Implementation**:
- Each table defined in `infrastructure/database/tables/*_table.dart`
- Drift generates DAO and schema automatically
- Migration documented in plan.md
- Backward compatibility: existing expense/income data untouched

---

## 8. Offline-First Data Consistency

### Decision: Client-Side Aggregations + Immutable Payment Records

**Rationale**:
- Goals and debts calculated from stored transaction data
- Goal progress = current savings (income - expenses) in cycle
- Debt remaining balance = total amount - sum of all payments (immutable)
- Insights calculated on demand, cached briefly (TTL: 1 hour)

**Why Selected Over Alternatives**:
- **Cloud sync** (rejected): Violates offline-first; adds complexity
- **Realtime WebSocket** (rejected): Not applicable; offline-first app
- **Eventual consistency** (rejected): User expects immediate feedback

**Implementation**:
- All calculations done in Application layer (use cases)
- Queries use Drift DAOs (no raw SQL)
- Transaction integrity: Drift handles atomicity
- Cache layer: Insights stored in database, refreshed on cycle events

---

## 9. Testing Strategy for Financial Features

### Decision: Unit Tests for Logic + Widget Tests for UI + Integration Tests for Workflows

**Rationale**:
- Classification logic: Unit tests with different savings rates
- Leak detection: Unit tests with various category distributions
- Goal progress: Widget tests for progress bar rendering
- End-to-end: Integration tests for "add goal → view → achieve" workflow

**Implementation**:
- Unit tests in `test/application/use_cases/`
- Widget tests in `test/presentation/goal/` (mirrors src structure)
- Integration tests in `test/integration/` for full workflows
- Target coverage: >80% for domain logic, >70% for presentation

---

## Summary of Decisions

| Area | Decision | Rationale |
|------|----------|-----------|
| Charts | fl_chart | Lightweight, RTL-friendly, stable |
| Classification | End-of-cycle savings rate | Simple, deterministic, cycle-aligned |
| Leaks | High-frequency category analysis | Actionable, real, user-relevant |
| Trends | Cycle-to-cycle comparison | Easy to understand, motivational |
| Challenges | Optional, user-configurable | Reduces decision fatigue, opt-in engagement |
| Notifications | Auto-send, no disable option | Maintains engagement, all positive tone |
| Storage | Drift + 5 new tables | Consistent with existing pattern, offline-safe |
| Testing | Unit + widget + integration | Comprehensive coverage, real-world validation |

**All decisions maintain alignment with Constitution Principles**: offline-first, clean architecture, performance engineering, data safety, testing mandatory.
