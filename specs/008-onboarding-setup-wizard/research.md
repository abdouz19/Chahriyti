# Research: Onboarding Financial Setup Wizard

**Branch**: `008-onboarding-setup-wizard` | **Date**: 2026-07-06

## R1: Wizard Placement in Existing Flow

**Decision**: Financial setup wizard runs AFTER activation, BEFORE existing salary onboarding.

**Rationale**: User's current financial reality (balance, debts, savings, lendings) should be captured before salary cycle setup. The salary onboarding creates the first financial cycle — knowing the user's starting position first provides better context. This also avoids disrupting the existing onboarding flow.

**Flow**: Signup → Activation → **Financial Setup Wizard (NEW)** → Salary Onboarding → Home

**Alternatives considered**:
- After existing onboarding: Would work but delays capturing baseline data. User might abandon after salary setup thinking they're done.
- Replace existing onboarding: Too disruptive, existing flow works well for its purpose.
- Merge into existing onboarding cubit: Violates separation of concerns — financial setup and salary cycle are distinct responsibilities.

## R2: Balance Storage

**Decision**: Add `initialBalance` field to `UserEntity` (nullable double, set once during wizard). This represents the user's total money at onboarding time, independent of cycle-based balance tracking.

**Rationale**: Balance in the existing system is derived (cycle salary − expenses). Initial balance is a separate concept — what the user physically has right now. It cannot be shoehorned into a cycle because no cycle exists yet at this point.

**Alternatives considered**:
- Store as first cycle's salary: Semantically wrong — balance ≠ salary.
- Create a new Account entity: Over-engineering for a single field.
- Store in financial_cycle: Cycle doesn't exist yet when wizard runs.

## R3: Savings Initial Amount

**Decision**: Use existing savings infrastructure. Create a savings history entry with type "deposit" for the initial amount entered in the wizard. Link it to the first cycle once created.

**Rationale**: Savings entity/repository/DAO already exist and work. Creating a parallel system would violate DRY and cause data inconsistency. The savings amount from the wizard becomes the initial deposit.

**Alternatives considered**:
- New field on UserEntity: Would duplicate savings data and diverge from existing tracking.
- Create a SavingsGoal: Goals have targets; initial savings is just a balance — wrong abstraction.

## R4: Debts and Lendings

**Decision**: Use existing debt/lending entities and repositories directly. Each debt/lending added in the wizard creates a real entity via existing use cases.

**Rationale**: Debt and lending entities already have all required fields (creditorName/borrowerName, totalAmount). No new infrastructure needed. Data entered in wizard immediately available in debt/lending management screens.

**Alternatives considered**:
- Temporary wizard-only storage: Would require sync step, adds complexity, risks data loss.

## R5: Wizard Progress Persistence

**Decision**: Add `onboardingStep` field to `UserEntity` (nullable int). When null = wizard not started. When set = resume from that step. When wizard complete, set a `hasCompletedFinancialSetup` boolean flag.

**Rationale**: App can close mid-wizard. Need to resume from last completed step. Simple integer tracking avoids complex state serialization.

**Alternatives considered**:
- SharedPreferences: Not part of the data layer, could desync from database state.
- Separate onboarding_progress table: Over-engineering for a single field.

## R6: Cubit Architecture

**Decision**: New `FinancialSetupCubit` with Dart sealed class states, following the same pattern as existing `OnboardingCubit`. Separate from existing cubit — each wizard step is a distinct state.

**Rationale**: Follows existing patterns (sealed class states, not Freezed). Separation of concerns — financial setup and salary onboarding are independent features with different lifecycles.

**States**: FinancialSetupInitial → BalanceInput → SavingsInput → DebtsInput → LendingsInput → SetupSummary → SetupCompleted

## R7: Router Integration

**Decision**: Add a new redirect guard in `app_router.dart`. After activation check and before existing onboarding redirect, check `hasCompletedFinancialSetup`. If false, redirect to `/financial-setup`.

**Rationale**: Follows existing guard pattern. Minimal change to router — one additional condition in the redirect chain.

**Guard order**: No user → onboarding | Not activated → activation | **Not financially setup → financial-setup** | Not salary-setup → salary-onboarding | Home
