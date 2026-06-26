# Feature Specification: Chahriyti — Personal Salary & Expense Management App

**Feature Branch**: `001-chahriyti-salary-app`  
**Created**: 2026-06-25  
**Status**: Draft  
**Input**: User description: "Chahriyti is a personal financial coach app for salaried employees in Algeria. It helps users understand where their salary goes, track expenses by category, set savings goals, manage debts, and receive smart motivational insights — all through a clean, simple, and visually appealing Arabic-first UI."

## Clarifications

### Session 2026-06-25

- Q: How does the activation workflow work if all data is stored locally with no backend? → A: Device-based licensing via WhatsApp. The app generates a unique device ID, the user sends it with their info (name, phone, wilaya) via WhatsApp to the developer, who runs a script to generate a license key tied to that device ID. The user enters the key in the app to activate. No backend required.
- Q: Can users edit or delete expenses after recording them? → A: Yes, users can edit or delete expenses within the current financial cycle only. Once a cycle ends, historical expenses become read-only.
- Q: Do savings goals persist across financial cycles or reset with each new salary? → A: Savings goals persist across cycles. Accumulated savings carry over indefinitely — goals are independent of financial cycles.
- Q: Can users add additional income only during onboarding or anytime during a cycle? → A: Anytime during a cycle. Users can add new income sources whenever they arrive (freelance, gifts, bonuses), and the balance updates immediately.
- Q: Can users see a chronological list of their individual expenses? → A: Both — a short list of recent expenses on the home screen for quick access, plus a dedicated full history screen for browsing all transactions. Edit/delete actions are accessible from both views (current cycle only).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Onboarding & Account Setup (Priority: P1)

A new user downloads the app and wants to start managing their salary. They see a welcoming splash screen with the tagline *"Before asking for a raise, you need to know where your salary goes."* They tap "Start Now", enter their monthly salary in Algerian Dinars, set their salary reception date (today or a specific date), and optionally add extra income sources. They then view the value proposition page showcasing the app's benefits. To activate, they proceed to the activation screen which displays their unique device ID and a 3-step process: (1) fill in their info (full name, phone number, wilaya), (2) send the info along with their device ID to the developer via WhatsApp, (3) receive a license key and enter it to unlock the app. Users who already have a license key can skip directly to step 3.

**Why this priority**: This is the entry point — without onboarding, no user can access the app. It also sets the financial cycle baseline (salary amount + date) which all calculations depend on.

**Independent Test**: Can be fully tested by going through the onboarding flow end-to-end. A user should be able to install the app, complete all onboarding steps, send the activation message, enter a valid license key, and access the home screen — delivering the value of setting up their financial profile.

**Acceptance Scenarios**:

1. **Given** a first-time user opens the app, **When** they tap "Start Now", **Then** they see the salary input screen with fields for monthly salary and salary date.
2. **Given** a user is on the salary input screen, **When** they enter a valid salary amount and select "Today" as the salary date, **Then** the app accepts the input and moves to the next step.
3. **Given** a user is on the salary input screen, **When** they enter a salary amount and choose a specific date, **Then** the app saves that date as the start of their financial cycle.
4. **Given** a user has entered their salary, **When** they check "I have additional income" and add an income source with description and amount, **Then** the additional income is saved and reflected in their total income.
5. **Given** a user has completed salary setup, **When** they view the value proposition page, **Then** they see all listed benefits clearly and a prominent button to proceed to activation.
6. **Given** a user is on the activation screen, **When** they view the screen, **Then** they see their unique device ID (copyable), input fields for full name, phone number, and wilaya (dropdown of Algerian wilayas), and a "Send via WhatsApp" button.
7. **Given** a user fills in their info and taps "Send via WhatsApp", **When** the message is composed, **Then** WhatsApp opens with a pre-formatted message containing the user's name, phone number, wilaya, and device ID sent to the developer's number.
8. **Given** a user has received a license key from the developer, **When** they tap "I have a license key" and enter the key in the dialog, **Then** the app validates the key against the device ID and unlocks full access if valid.
9. **Given** a user enters an invalid license key, **When** they tap "Activate", **Then** the app shows an error message and allows them to retry.
10. **Given** a user who already has a valid license key, **When** they tap "I have a license key" directly, **Then** they can skip the WhatsApp step and enter their key immediately.

---

### User Story 2 - Recording an Expense (Priority: P1)

A user wants to log an expense they just made. From the home screen, they tap the prominent "Spend" button, choose one of four categories (Essentials, Home & Family, Luxuries, Other), select a subcategory, enter what they bought, the price, and an optional note. After saving, they return to the home screen where their balance is immediately updated.

**Why this priority**: Expense recording is the core action of the app — every other feature (analytics, safe balance, predictions) depends on having expense data. Without this, the app has no value.

**Independent Test**: Can be fully tested by recording a single expense and verifying the balance updates. Delivers immediate value by letting the user track a purchase.

**Acceptance Scenarios**:

1. **Given** an activated user is on the home screen, **When** they tap the "Spend" button, **Then** they see four expense categories displayed clearly.
2. **Given** a user has selected the "Essentials" category, **When** they see the subcategories, **Then** they can choose from: Food, Transport, Bills, Medicine.
3. **Given** a user has selected a subcategory, **When** they see the input form, **Then** they see fields for "What did you buy?", "Price", and an optional "Notes" field, plus a large, clear "Save" button.
4. **Given** a user fills in "Bread" as the item and "100" as the price and taps Save, **When** the expense is saved, **Then** the app returns to the home screen and the current balance decreases by 100 DZD.
5. **Given** a user enters an expense, **When** they leave the "Notes" field empty, **Then** the expense is saved without issues — notes are optional.
6. **Given** a user views a recorded expense in the current cycle, **When** they choose to edit it, **Then** they can modify the item name, price, notes, or category, and the balance updates accordingly.
7. **Given** a user views a recorded expense in the current cycle, **When** they choose to delete it, **Then** the expense is removed and the balance is restored by the deleted amount.
8. **Given** a user views an expense from a previous (closed) cycle, **When** they attempt to edit or delete it, **Then** the option is not available — historical expenses are read-only.

---

### User Story 3 - Home Dashboard Overview (Priority: P1)

A user opens the app and wants to instantly understand their financial situation. The home screen displays their current balance (salary + extra income - expenses - paid debts) on the right and total cycle expenses on the left. Below, they see the number of days until next salary, their daily spending average, a colored consumption bar showing how much of their salary they've used, their safe daily spending amount, their savings goal progress, and their debts summary.

**Why this priority**: The dashboard is the primary screen users interact with daily. It must provide an instant financial snapshot without requiring the user to read complex statistics.

**Independent Test**: Can be tested by verifying all dashboard cards display correct calculations after salary setup and some recorded expenses. Delivers value by giving instant financial awareness.

**Acceptance Scenarios**:

1. **Given** a user with salary 50,000 DZD and 5,000 DZD in expenses, **When** they view the home screen, **Then** the current balance shows 45,000 DZD (green) and expenses show 5,000 DZD (red).
2. **Given** a user received salary on June 1 and today is June 15 (next salary July 1), **When** they view the dashboard, **Then** it shows 16 days remaining until next salary.
3. **Given** a user has spent 15,000 DZD over 10 days, **When** they view the dashboard, **Then** the daily spending average shows 1,500 DZD.
4. **Given** a user has spent 63% of their salary, **When** they view the consumption bar, **Then** it shows "You've consumed 63% of your salary — 37% remaining" with appropriate color coding.
5. **Given** a user has 35,000 DZD remaining and 15 days until next salary, **When** they view the safe balance section, **Then** it shows approximately 2,333 DZD as their safe daily spending limit.
6. **Given** a user has a savings goal "Buy a phone — 80,000 DZD" with 28,000 DZD saved, **When** they view the goal section, **Then** it shows the goal name, target, and a progress bar at 35%.
7. **Given** an activated user with a current balance of 40,000 DZD, **When** they add an additional income of 5,000 DZD (e.g., freelance payment) from the home screen, **Then** the balance immediately updates to 45,000 DZD and the income is recorded in the current cycle.
8. **Given** a user has recorded several expenses, **When** they view the home screen, **Then** they see a short list of their most recent expenses (date, item, category, amount) below the dashboard cards.
9. **Given** a user wants to browse all transactions, **When** they navigate to the full history screen, **Then** they see a complete chronological list of all expenses in the current cycle with the ability to edit or delete any entry.

---

### User Story 4 - Statistics & Financial Analytics (Priority: P2)

A user wants to understand their spending patterns. They navigate to the statistics page to see a breakdown of expenses by category (as percentages), identify their highest spending category, see their remaining salary percentage, view a smart prediction of their end-of-cycle balance, see when their balance might run out at the current rate, compare spending across the last 6 months, and receive a financial behavior classification (from "Legendary Saver" to "Early Bankrupt").

**Why this priority**: Analytics provide the deeper insights that drive behavioral change — the core mission of the app. However, they require accumulated expense data to be meaningful, so they depend on P1 stories being complete.

**Independent Test**: Can be tested by recording several expenses across categories and verifying that all analytics indicators display correct data. Delivers value by revealing spending patterns and predictions.

**Acceptance Scenarios**:

1. **Given** a user has recorded expenses: 4,500 DZD on food, 2,000 DZD on transport, 1,500 DZD on entertainment, 2,000 DZD on other, **When** they view the expense distribution, **Then** they see percentages: Food 45%, Transport 20%, Entertainment 15%, Other 20%.
2. **Given** a user's highest spending is in the "Restaurants" subcategory, **When** they view the top spending indicator, **Then** it highlights "Restaurants" as their highest spending category.
3. **Given** a user has spent 38% of their salary with 60% of the cycle remaining, **When** they view the smart prediction, **Then** it estimates the remaining balance at end of cycle based on current spending rate.
4. **Given** a user is spending at a rate that would exhaust their balance before the cycle ends, **When** they view the balance depletion forecast, **Then** they see the estimated date their balance will reach zero.
5. **Given** a user has 3+ months of data, **When** they view the month comparison, **Then** they see a comparison of spending across the last 6 months (or available months).
6. **Given** a user has saved more than 30% of their salary, **When** they view their classification, **Then** they see "Legendary Saver" with the trophy icon.
7. **Given** a user whose balance will likely run out before the next salary, **When** they view their classification, **Then** they see "Danger" with the alert icon.

---

### User Story 5 - Debt Management (Priority: P2)

A user has debts they want to track. From the home screen's debt section, they can add a debt by entering the creditor's name, the total amount, and any amount already paid. They can make partial payments which automatically deduct from their current balance. The remaining amount updates in real time. No notifications are sent about debts to avoid pressuring the user.

**Why this priority**: Debt tracking is important for accurate financial visibility (debts affect the real balance) but is not used by all users. It enhances the core experience without being strictly required for basic salary tracking.

**Independent Test**: Can be tested by adding a debt, making a partial payment, and verifying balance deduction and debt tracking update. Delivers value by giving users visibility into their obligations.

**Acceptance Scenarios**:

1. **Given** a user is on the home screen, **When** they add a new debt with creditor "Ahmed", total 10,000 DZD, already paid 2,000 DZD, **Then** the debt appears showing 8,000 DZD remaining.
2. **Given** a user has a debt with 8,000 DZD remaining and a current balance of 40,000 DZD, **When** they pay 3,000 DZD toward the debt, **Then** the debt remaining becomes 5,000 DZD and the current balance becomes 37,000 DZD.
3. **Given** a user has debts, **When** the system sends notifications, **Then** no debt-related notifications are ever sent.
4. **Given** a user pays the full remaining amount of a debt, **When** the payment is processed, **Then** the debt is marked as fully paid and removed from active debts.

---

### User Story 6 - Savings Goals (Priority: P2)

A user wants to save for a specific purchase. They create a savings goal by entering a name (e.g., "Buy a phone") and the target amount (e.g., 80,000 DZD). The goal appears on the home screen with a progress bar. The user can add money to the goal over time. Multiple goals can exist simultaneously.

**Why this priority**: Savings goals give users something to work toward, driving the motivational aspect of the app. They depend on the user having an accurate financial picture first (P1 stories).

**Independent Test**: Can be tested by creating a goal, adding savings to it, and verifying the progress bar updates. Delivers value by providing tangible motivation to save.

**Acceptance Scenarios**:

1. **Given** a user is on the home screen, **When** they create a new goal "Buy a phone" with target 80,000 DZD, **Then** the goal appears on the home screen with 0% progress.
2. **Given** a user has a goal at 28,000 / 80,000 DZD, **When** they add 5,000 DZD to the goal, **Then** the progress updates to 33,000 / 80,000 DZD (41.25%) and the balance decreases by 5,000 DZD.
3. **Given** a user has multiple savings goals, **When** they view the home screen, **Then** all goals are visible with individual progress bars.
4. **Given** a user reaches 100% of their goal, **When** they view the goal, **Then** it is marked as achieved with a congratulatory message.

---

### User Story 7 - Smart Notifications (Priority: P3)

The app sends motivational, positive notifications to help users stay aware of their spending without causing stress. Active users receive progress updates and encouragement. Inactive (non-activated) users receive persuasive messages showcasing the app's value. Notifications never blame, scare, or pressure the user.

**Why this priority**: Notifications enhance engagement and retention but the app is fully functional without them. They are a polish feature that improves the experience over time.

**Independent Test**: Can be tested by verifying notification content matches the positive/motivational tone guidelines and triggers at appropriate moments. Delivers value by keeping users engaged and informed.

**Acceptance Scenarios**:

1. **Given** an active user has spent 70% of their salary with 40% of the cycle remaining, **When** a notification is triggered, **Then** the notification says something like "You've spent 70% of your salary and there's still 40% of the cycle left" — informative, not blaming.
2. **Given** an active user has 45% of salary remaining with 1 week until next salary, **When** a notification is triggered, **Then** it says something like "One week until next salary and you still have 45% — excellent performance!"
3. **Given** a non-activated user, **When** they receive a notification, **Then** it highlights the app's value (e.g., "In just one minute a day, you can know where your salary goes") without pressuring them to activate.
4. **Given** any notification scenario, **When** the notification is composed, **Then** it never contains negative language, blame, fear, or psychological pressure.

---

### User Story 8 - Weekly Challenges (Priority: P3)

Each week, the user receives a new savings challenge based on their previous week's spending. The challenge encourages them to spend less than the prior week by a specific amount. This gamifies the savings experience and creates a habit loop.

**Why this priority**: Challenges are a motivational layer that adds engagement but is not core functionality. Requires established spending data to generate meaningful challenges.

**Independent Test**: Can be tested by completing a week of expense tracking and verifying a relevant challenge is generated. Delivers value through gamification and behavioral nudging.

**Acceptance Scenarios**:

1. **Given** a user spent 15,000 DZD last week, **When** a new week begins, **Then** they receive a challenge like "Try to spend 1,000 DZD less than last week."
2. **Given** a user has completed a weekly challenge successfully, **When** the week ends, **Then** they receive acknowledgment of their achievement.
3. **Given** a user has no prior week data (first week), **When** the week begins, **Then** a general savings challenge is presented instead.

---

### User Story 9 - Financial Leak Detection (Priority: P3)

The app analyzes recurring small expenses and alerts the user about financial leaks — frequent small purchases that add up to significant amounts. It suggests what they could save by reducing these expenses.

**Why this priority**: This is an advanced analytical feature that provides powerful insights but requires several weeks of data to be effective. It builds on P1 and P2 functionality.

**Independent Test**: Can be tested by recording multiple small recurring expenses in the same subcategory and verifying the leak detection message appears with accurate calculations. Delivers value by revealing hidden spending patterns.

**Acceptance Scenarios**:

1. **Given** a user has spent 6,200 DZD on coffee/drinks this month across multiple transactions, **When** the leak detection runs, **Then** the user sees: "You spent 6,200 DZD on coffee and drinks this month. If you halved this, you'd save 3,100 DZD."
2. **Given** a user has no recurring small expenses in any category, **When** the leak detection runs, **Then** no leak alert is shown.
3. **Given** a category's spending increased by 35% compared to last month, **When** the financial intelligence analysis runs, **Then** the user sees a note like "Restaurant spending increased by 35% compared to last month."

---

### User Story 10 - Cycle Reset & Settings (Priority: P3)

A user wants to start a fresh financial cycle. They go to Settings and tap "Reset Financial Cycle." A confirmation message appears emphasizing financial commitment before allowing the reset. Upon confirmation, current cycle data is cleared and a new cycle begins. The user can also manage their account settings from this screen.

**Why this priority**: Settings and cycle management are utility features needed for long-term use but not critical for initial app adoption.

**Independent Test**: Can be tested by initiating a cycle reset, confirming, and verifying that cycle data is cleared while historical data is preserved for month comparisons. Delivers value by letting users start fresh.

**Acceptance Scenarios**:

1. **Given** a user is in Settings, **When** they tap "Reset Financial Cycle", **Then** they see a motivational confirmation message: "Financial success requires commitment. Resetting will delete current cycle data and start fresh. Are you sure?"
2. **Given** a user sees the reset confirmation, **When** they tap "Yes, Reset", **Then** the current cycle's expense data is cleared and a new cycle begins from today.
3. **Given** a user sees the reset confirmation, **When** they tap "Cancel", **Then** nothing changes and they return to Settings.

---

### Edge Cases

- What happens when the user enters 0 or a negative number as salary? The system must reject invalid salary amounts and prompt the user to enter a valid positive amount.
- What happens when the user's balance reaches exactly 0? The dashboard shows 0 DZD balance, the safe daily spending shows 0, and the consumption bar shows 100% consumed.
- What happens when the user has 0 days remaining until next salary? The "days remaining" indicator shows "Salary day!" and the safe balance calculation handles division by zero gracefully.
- How does the system handle a debt payment that exceeds the current balance? The system prevents the payment and notifies the user they don't have sufficient funds.
- What happens when a user tries to add savings to a goal but has insufficient balance? The system prevents the addition and informs the user of insufficient funds.
- What happens when an additional income amount is 0? The system rejects it and asks for a valid positive amount.
- How does the system handle the very first month with no historical data for comparisons? Month comparison shows only the current month; no comparison charts are displayed until at least 2 months of data exist.
- What happens when a user has no expenses recorded in a cycle? The dashboard shows full balance, 0 expenses, and all analytics show no data with a friendly prompt to start recording.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to create an account by entering their monthly salary in Algerian Dinars (DZD) and their salary reception date.
- **FR-002**: System MUST support two salary date options: "Today" or a specific calendar date selected by the user.
- **FR-003**: System MUST calculate financial cycles based on the salary reception date, not the calendar month (e.g., June 5 to July 5).
- **FR-004**: System MUST auto-renew the salary date each month based on the original date.
- **FR-005**: System MUST allow users to add additional income sources with a description and amount at any time during a financial cycle (not just during onboarding). Each addition immediately updates the current balance.
- **FR-006**: System MUST display a value proposition page during onboarding listing all app benefits before the activation request.
- **FR-007**: System MUST support a device-based licensing activation workflow: the app generates a unique device ID, the user sends their info (name, phone, wilaya) and device ID to the developer via WhatsApp, receives a license key, and enters it to activate the app. The license key is validated locally against the device ID.
- **FR-007a**: System MUST display the unique device ID on the activation screen with a copy-to-clipboard function.
- **FR-007b**: System MUST provide a "Send via WhatsApp" button that opens WhatsApp with a pre-formatted activation message containing the user's name, phone number, wilaya, and device ID.
- **FR-007c**: System MUST provide an "I have a license key" option allowing users to enter and validate their license key at any time.
- **FR-007d**: System MUST validate license keys locally against the device ID and persist the activation status on-device.
- **FR-008**: System MUST display the current balance (salary + additional income - expenses - paid debts) prominently on the home screen.
- **FR-009**: System MUST display total expenses for the current cycle on the home screen.
- **FR-010**: System MUST calculate and display the number of days remaining until the next salary.
- **FR-011**: System MUST calculate and display the average daily spending for the current cycle.
- **FR-012**: System MUST display a colored consumption bar showing the percentage of salary consumed vs. remaining.
- **FR-013**: System MUST calculate and display a "Safe Balance" — the maximum amount the user can spend daily while staying financially safe until the next salary.
- **FR-014**: System MUST categorize expenses into exactly four main categories: Essentials (Food, Transport, Bills, Medicine), Home & Family (Household, Children, Gifts, Other), Luxuries (Restaurants, Coffee, Clothing, Entertainment), and Other.
- **FR-015**: System MUST collect for each expense: item name (required), price (required), and notes (optional).
- **FR-016**: System MUST immediately update the balance after recording an expense and return the user to the home screen.
- **FR-016a**: System MUST allow users to edit expenses (item name, price, notes, category) within the current financial cycle, with the balance recalculated accordingly.
- **FR-016b**: System MUST allow users to delete expenses within the current financial cycle, restoring the deleted amount to the balance.
- **FR-016c**: System MUST NOT allow editing or deleting expenses from previous (closed) financial cycles — historical data is read-only.
- **FR-016d**: System MUST display a short list of recent expenses on the home screen (below the dashboard cards) showing date, item name, category, and amount.
- **FR-016e**: System MUST provide a dedicated full history screen with a complete chronological list of all expenses in the current cycle, accessible from the home screen or navigation.
- **FR-017**: System MUST display expense distribution by category as percentages in the statistics page.
- **FR-018**: System MUST identify and display the highest spending category.
- **FR-019**: System MUST provide a smart prediction of the remaining balance at end of cycle based on current spending rate.
- **FR-020**: System MUST predict the date when the balance will reach zero based on current spending rate.
- **FR-021**: System MUST support month-over-month comparison of spending for the last 6 months (when data is available).
- **FR-022**: System MUST classify users into financial behavior tiers: Legendary Saver (>30% saved), Smart Saver (15-30%), Balanced, Spender, Danger, and Early Bankrupt.
- **FR-023**: System MUST allow users to track debts with creditor name, total amount, amount paid, and amount remaining.
- **FR-024**: System MUST automatically deduct debt payments from the current balance.
- **FR-025**: System MUST never send notifications related to debts.
- **FR-026**: System MUST allow users to create and track multiple savings goals with name and target amount. Goals persist across financial cycles — accumulated progress is never reset.
- **FR-027**: System MUST display savings goal progress with a visual progress bar on the home screen.
- **FR-028**: System MUST send only positive, motivational notifications — never blaming, scary, or pressuring messages.
- **FR-029**: System MUST provide weekly savings challenges based on previous week's spending data.
- **FR-030**: System MUST detect recurring small expenses (financial leaks) and suggest potential savings.
- **FR-031**: System MUST support financial cycle reset with a motivational confirmation message.
- **FR-032**: System MUST validate all monetary inputs to reject zero, negative, or non-numeric values.
- **FR-033**: System MUST prevent debt payments and goal contributions that exceed the current balance.
- **FR-034**: System MUST present the entire UI in Arabic (right-to-left layout) as the primary language.
- **FR-035**: System MUST use Algerian Dinar (DZD / دج) as the currency throughout the app.

### Key Entities

- **User**: Represents an app user with their salary, salary date, activation status, additional income sources, and financial behavior classification. Each user has one active financial cycle at a time.
- **Financial Cycle**: A time period starting from the salary reception date to the next salary date. Contains all expenses, income, and balance calculations for that period. Historical cycles are preserved for comparison.
- **Expense**: A single spending record belonging to a financial cycle. Has a category, subcategory, item name, price, optional notes, and timestamp.
- **Category**: One of four main expense groups (Essentials, Home & Family, Luxuries, Other), each with predefined subcategories.
- **Debt**: A tracked obligation with a creditor name, total amount, paid amount, and remaining amount. Payments deduct from the user's balance.
- **Savings Goal**: A user-defined target with a name, target amount, and current progress. Multiple goals can exist simultaneously. Goals persist across financial cycles — accumulated savings carry over indefinitely and are not affected by cycle resets or new salary arrivals.
- **Additional Income**: An extra income source beyond the base salary, with a description and amount. Added to the current balance.
- **Weekly Challenge**: A generated savings challenge based on the previous week's spending, encouraging the user to spend less.
- **License Key**: A device-bound activation key generated by the developer. Tied to a unique device ID. Validated locally to unlock full app access. Persisted on-device once activated.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the full onboarding flow (from splash screen to activation request) in under 2 minutes.
- **SC-002**: Users can record an expense in under 15 seconds (from tapping "Spend" to returning to home screen).
- **SC-003**: The home screen provides a complete financial snapshot that users can understand within 5 seconds of viewing.
- **SC-004**: 80% of users can correctly identify their top spending category after using the app for one full cycle.
- **SC-005**: The safe daily spending amount is always accurately calculated (remaining balance divided by remaining days).
- **SC-006**: Smart predictions (end-of-cycle balance, depletion date) are within 10% accuracy of actual outcomes after 2 weeks of data.
- **SC-007**: Users who complete at least one full financial cycle report knowing where their salary goes.
- **SC-008**: 70% of active users record at least one expense per day on average.
- **SC-009**: Users with savings goals save at least 10% more than users without goals.
- **SC-010**: All notification content passes a tone review — 100% positive and motivational, 0% negative or blaming.
- **SC-011**: The app supports 1,000 concurrent users without performance degradation.
- **SC-012**: Month-over-month comparison data is available within 3 seconds of navigation to the statistics page.

## Assumptions

- Users are salaried employees or individuals with a regular monthly income in Algeria.
- Users have basic smartphone literacy and are comfortable entering numbers and dates.
- The app targets mobile platforms (Android and iOS) as the primary interface.
- Arabic (right-to-left) is the primary and default language; no other languages are required for the initial version.
- Activation uses a device-based licensing model: the user sends their device ID and personal info via WhatsApp, and the developer generates a license key offline using a script. No backend server is required for activation.
- Internet connectivity is required only for sending the WhatsApp activation message and receiving notifications. All financial data and license validation are fully local.
- Historical data from previous financial cycles is preserved for comparison features even after a cycle reset.
- No integration with banks or external financial services is required — all data is manually entered by the user.
- The app does not handle multiple currencies — Algerian Dinar (DZD) only.
- Push notification infrastructure is assumed to be available on the target platforms.
- No user-to-user features (sharing, social comparison) are in scope.
- Data privacy: all financial data is stored locally on the user's device with no cloud sync for v1.
