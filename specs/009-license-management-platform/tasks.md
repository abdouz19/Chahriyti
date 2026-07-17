# Tasks: License Management Platform

**Input**: Design documents from `specs/009-license-management-platform/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Included — user explicitly requested testing as mandatory.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2)
- Paths relative to `chahriyti_platform/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization, dependencies, and tooling

- [x] T001 Install core dependencies: `react-router-dom`, `firebase`, `tailwindcss`, `postcss`, `autoprefixer`, `recharts`, `react-hot-toast` in `chahriyti_platform/package.json`
- [x] T002 Configure Tailwind CSS with Chahriyti brand tokens (primary #0D6E6E, surface #F8F9FA, etc.) in `chahriyti_platform/tailwind.config.js`
- [x] T003 [P] Create global styles and CSS reset in `chahriyti_platform/src/index.css` with Tailwind directives and custom font setup
- [x] T004 [P] Create Firebase config file with environment variable references in `chahriyti_platform/src/config/firebase.js`
- [x] T005 [P] Create theme tokens constants (colors, spacing, shadows) in `chahriyti_platform/src/config/theme.js`
- [x] T006 Initialize Firebase project: create `chahriyti_platform/firebase.json`, `chahriyti_platform/.firebaserc`, `chahriyti_platform/firestore.rules`, `chahriyti_platform/firestore.indexes.json`
- [x] T007 Initialize Cloud Functions project: create `chahriyti_platform/functions/package.json` with `firebase-functions`, `firebase-admin`, install dependencies
- [x] T008 [P] Configure Vitest and React Testing Library: install `vitest`, `@testing-library/react`, `@testing-library/jest-dom`, `@testing-library/user-event`, `jsdom`, create `chahriyti_platform/vitest.config.js`
- [x] T009 [P] Create `.env.example` with all required Firebase environment variables in `chahriyti_platform/.env.example`
- [x] T010 Create project folder structure per plan.md: `src/components/ui/`, `src/components/charts/`, `src/components/layout/`, `src/features/auth/`, `src/features/license/`, `src/features/clients/`, `src/features/dashboard/`, `src/features/managers/`, `src/services/`, `src/hooks/`, `src/utils/`, `src/config/`, `src/contexts/`, `src/routes/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story

**CRITICAL**: No user story work can begin until this phase is complete

### Design System Components

- [x] T011 [P] Create Button component (primary, secondary, danger, ghost variants, loading state) in `chahriyti_platform/src/components/ui/Button.jsx`
- [x] T012 [P] Create Input component (text, password, search variants, validation error display, RTL-ready) in `chahriyti_platform/src/components/ui/Input.jsx`
- [x] T013 [P] Create Card component (elevated, outlined variants, header/body/footer slots) in `chahriyti_platform/src/components/ui/Card.jsx`
- [x] T014 [P] Create Modal component (overlay, close on escape/backdrop, animated entrance) in `chahriyti_platform/src/components/ui/Modal.jsx`
- [x] T015 [P] Create Badge component (success, warning, danger, neutral variants) in `chahriyti_platform/src/components/ui/Badge.jsx`
- [x] T016 [P] Create Spinner/LoadingState component in `chahriyti_platform/src/components/ui/Spinner.jsx`
- [x] T017 [P] Create EmptyState component (icon, title, description, action button) in `chahriyti_platform/src/components/ui/EmptyState.jsx`
- [x] T018 [P] Create Pagination component (page numbers, prev/next, page size selector) in `chahriyti_platform/src/components/ui/Pagination.jsx`
- [x] T019 [P] Create DateRangePicker component in `chahriyti_platform/src/components/ui/DateRangePicker.jsx`
- [x] T020 [P] Create KPICard component (icon, label, value, trend indicator, colored accent) in `chahriyti_platform/src/components/charts/KPICard.jsx`

### Design System Tests

- [x] T021 [P] Write component tests for Button, Input, Card, Modal in `chahriyti_platform/src/components/ui/__tests__/`
- [x] T022 [P] Write component tests for Badge, Spinner, EmptyState, Pagination in `chahriyti_platform/src/components/ui/__tests__/`

### Firebase Services Layer

- [x] T023 Create auth service: `signIn`, `signOut`, `onAuthStateChanged`, `getIdTokenResult` (for custom claims) in `chahriyti_platform/src/services/auth.js`
- [x] T024 [P] Create functions service: callable function wrappers (`generateLicense`, `createManager`, `updateUserStatus`, `getDashboardStats`) in `chahriyti_platform/src/services/functions.js`
- [x] T025 [P] Create firestore service: `getClients` (paginated), `getManagers`, `onStatsSnapshot` (real-time listener) in `chahriyti_platform/src/services/firestore.js`

### Shared Hooks & Context

- [x] T026 Create AuthContext provider: auth state, user role, loading state, sign in/out methods in `chahriyti_platform/src/contexts/AuthContext.jsx`
- [x] T027 Create useAuth hook: consume AuthContext, return `{ user, role, loading, signIn, signOut }` in `chahriyti_platform/src/hooks/useAuth.js`

### Shared Utilities

- [x] T028 [P] Create validators: `validateName`, `validatePhone` (Algerian format), `validateDeviceId` (hex SHA-256) in `chahriyti_platform/src/utils/validators.js`
- [x] T029 [P] Create formatters: `formatDate`, `formatPhone`, `formatNumber` (with thousands separator), `formatLicenseKey` in `chahriyti_platform/src/utils/formatters.js`
- [x] T030 [P] Create constants: role enums, collection names, function names in `chahriyti_platform/src/config/constants.js`

### Utility Tests

- [x] T031 [P] Write unit tests for validators in `chahriyti_platform/src/utils/__tests__/validators.test.js`
- [x] T032 [P] Write unit tests for formatters in `chahriyti_platform/src/utils/__tests__/formatters.test.js`

### Cloud Functions Foundation

- [x] T033 Create Cloud Function utility: license key generation (port HMAC-SHA256 algorithm from `tools/generate_license.dart`) in `chahriyti_platform/functions/src/license.js`
- [x] T034 [P] Create Cloud Function utility: auth middleware (verify caller role from custom claims) in `chahriyti_platform/functions/src/middleware.js`
- [x] T035 [P] Create Cloud Function utility: stats counter helpers (atomic increment/decrement) in `chahriyti_platform/functions/src/stats.js`

### Cloud Functions Tests

- [x] T036 Write unit test for license key generation: verify output matches Dart algorithm for same inputs in `chahriyti_platform/functions/__tests__/license.test.js`
- [x] T037 [P] Write unit test for auth middleware in `chahriyti_platform/functions/__tests__/middleware.test.js`

### Firestore Security Rules

- [x] T038 Write Firestore security rules: role-based read access, Cloud Functions-only writes per contracts/firestore-rules.md in `chahriyti_platform/firestore.rules`
- [x] T039 Write Firestore indexes for `clients` collection (managerId+generatedAt, deviceId) in `chahriyti_platform/firestore.indexes.json`

**Checkpoint**: Foundation ready — design system, services, auth context, Cloud Functions, and security rules all in place. User story implementation can begin.

---

## Phase 3: User Story 6 — Role-Based Authentication & Portal Routing (Priority: P1)

**Goal**: Users log in and get routed to correct portal (Admin or Manager). Unauthorized cross-portal access blocked.

**Independent Test**: Log in as admin → see admin portal. Log in as manager → see manager portal. Manager tries admin URL → redirected.

### Tests for US6

- [x] T040 [P] [US6] Write test for LoginPage: form validation, submit, error display in `chahriyti_platform/src/features/auth/__tests__/LoginPage.test.jsx`
- [x] T041 [P] [US6] Write test for ProtectedRoute: redirect unauthenticated, redirect wrong role in `chahriyti_platform/src/routes/__tests__/ProtectedRoute.test.jsx`

### Implementation for US6

- [x] T042 [US6] Create LoginPage: email/password form, Chahriyti logo, brand-styled, error handling in `chahriyti_platform/src/features/auth/pages/LoginPage.jsx`
- [x] T043 [US6] Create ProtectedRoute component: check auth + role, redirect to login or correct portal in `chahriyti_platform/src/routes/ProtectedRoute.jsx`
- [x] T044 [P] [US6] Create AdminLayout shell: sidebar nav (Dashboard, Managers), header with user info/logout, content area in `chahriyti_platform/src/components/layout/AdminLayout.jsx`
- [x] T045 [P] [US6] Create ManagerLayout shell: sidebar nav (Generate License, Clients, Dashboard), header with user info/logout, content area in `chahriyti_platform/src/components/layout/ManagerLayout.jsx`
- [x] T046 [US6] Create Sidebar component: nav items, active state, Chahriyti branding, collapsible in `chahriyti_platform/src/components/layout/Sidebar.jsx`
- [x] T047 [US6] Create Header component: user avatar/name, role badge, logout button in `chahriyti_platform/src/components/layout/Header.jsx`
- [x] T048 [US6] Configure React Router: lazy-loaded admin/manager route groups, login route, 404, redirects in `chahriyti_platform/src/routes/index.jsx`
- [x] T049 [US6] Wire everything in App.jsx: AuthProvider, RouterProvider, global toast notifications in `chahriyti_platform/src/App.js`

**Checkpoint**: Auth fully working. Admin and Manager each see their portal with branded sidebar. Cross-portal access blocked.

---

## Phase 4: User Story 1 — Manager Generates a License (Priority: P1) MVP

**Goal**: Manager fills form (name, phone, device ID), gets license key, copies to clipboard. Client record saved.

**Independent Test**: Log in as manager → open license form → enter valid data → submit → see generated key → copy key → verify it matches expected format.

### Tests for US1

- [x] T050 [P] [US1] Write test for GenerateLicensePage: form renders, validation errors, successful generation display in `chahriyti_platform/src/features/license/__tests__/GenerateLicensePage.test.jsx`
- [x] T051 [P] [US1] Write test for useGenerateLicense hook: calls function service, handles loading/error/success states in `chahriyti_platform/src/features/license/__tests__/useGenerateLicense.test.js`
- [x] T052 [P] [US1] Write integration test for generateLicense Cloud Function: valid input → correct key format, invalid input → error in `chahriyti_platform/functions/__tests__/generateLicense.integration.test.js`

### Implementation for US1

- [x] T053 [US1] Create generateLicense Cloud Function: validate input, generate HMAC key, write client doc + update stats atomically in `chahriyti_platform/functions/src/generateLicense.js`
- [x] T054 [US1] Export generateLicense in `chahriyti_platform/functions/src/index.js`
- [x] T055 [US1] Create useGenerateLicense hook: form state, validation, call functions service, loading/error/success in `chahriyti_platform/src/features/license/hooks/useGenerateLicense.js`
- [x] T056 [US1] Create LicenseForm component: name input, phone input, device ID input (with paste support), submit button in `chahriyti_platform/src/features/license/components/LicenseForm.jsx`
- [x] T057 [US1] Create LicenseResult component: display generated key in large styled text, copy-to-clipboard button with success toast, expiry info in `chahriyti_platform/src/features/license/components/LicenseResult.jsx`
- [x] T058 [US1] Create DuplicateWarning component: shown when device ID already has active license, allow proceed or cancel in `chahriyti_platform/src/features/license/components/DuplicateWarning.jsx`
- [x] T059 [US1] Create GenerateLicensePage: compose form + result + duplicate warning, manage flow state in `chahriyti_platform/src/features/license/pages/GenerateLicensePage.jsx`
- [x] T060 [US1] Add GenerateLicensePage route to manager portal routes in `chahriyti_platform/src/routes/index.jsx`

**Checkpoint**: Manager can generate licenses. Core business operation works. This is the MVP.

---

## Phase 5: User Story 2 — Manager Views Client History (Priority: P1)

**Goal**: Manager sees paginated list of their clients with search and date filtering. Daily count visible.

**Independent Test**: Generate several licenses → open client history → see all listed → search by name → filter by date → verify pagination works.

### Tests for US2

- [x] T061 [P] [US2] Write test for ClientsPage: table renders, pagination works, search filters in `chahriyti_platform/src/features/clients/__tests__/ClientsPage.test.jsx`
- [x] T062 [P] [US2] Write test for useClients hook: pagination, search debounce, date filtering in `chahriyti_platform/src/features/clients/__tests__/useClients.test.js`

### Implementation for US2

- [x] T063 [US2] Create useClients hook: Firestore paginated query (cursor-based), search by name/phone, date range filter, loading/error state in `chahriyti_platform/src/features/clients/hooks/useClients.js`
- [x] T064 [US2] Create ClientsTable component: columns (name, phone, device ID truncated, license key truncated, date, copy key button), responsive in `chahriyti_platform/src/features/clients/components/ClientsTable.jsx`
- [x] T065 [US2] Create ClientsToolbar component: search input with debounce, date range picker, today/week/month quick filters, total count badge in `chahriyti_platform/src/features/clients/components/ClientsToolbar.jsx`
- [x] T066 [US2] Create ClientDetailModal component: full client info, full license key with copy, generation date, manager info in `chahriyti_platform/src/features/clients/components/ClientDetailModal.jsx`
- [x] T067 [US2] Create ClientsPage: compose toolbar + table + pagination + detail modal, summary bar (today count, total count) in `chahriyti_platform/src/features/clients/pages/ClientsPage.jsx`
- [x] T068 [US2] Add ClientsPage route to manager portal routes in `chahriyti_platform/src/routes/index.jsx`

**Checkpoint**: Manager can browse, search, and filter all their clients. History is complete.

---

## Phase 6: User Story 3 — Manager Dashboard with KPIs (Priority: P2)

**Goal**: Manager sees their personal performance: total clients (all-time, month, today), daily activity chart.

**Independent Test**: Generate clients on different dates → open dashboard → verify KPI numbers match → verify chart shows correct daily counts.

### Tests for US3

- [x] T069 [P] [US3] Write test for ManagerDashboardPage: KPI cards render with correct data, chart renders in `chahriyti_platform/src/features/dashboard/__tests__/ManagerDashboardPage.test.jsx`
- [x] T070 [P] [US3] Write test for useManagerDashboard hook: fetches stats, real-time updates in `chahriyti_platform/src/features/dashboard/__tests__/useManagerDashboard.test.js`

### Implementation for US3

- [x] T071 [US3] Create getDashboardStats Cloud Function: aggregate stats, filter by managerId if manager role, return daily counts array in `chahriyti_platform/functions/src/getDashboardStats.js`
- [x] T072 [US3] Export getDashboardStats in `chahriyti_platform/functions/src/index.js`
- [x] T073 [US3] Create useManagerDashboard hook: call getDashboardStats, real-time listener on `stats/managers/{uid}`, period selector state in `chahriyti_platform/src/features/dashboard/hooks/useManagerDashboard.js`
- [x] T074 [US3] Create ActivityChart component: Recharts LineChart, daily client counts, selectable period (7d, 30d, 90d), tooltips, Chahriyti brand colors in `chahriyti_platform/src/features/dashboard/components/ActivityChart.jsx`
- [x] T075 [US3] Create ManagerDashboardPage: KPI cards row (all-time, month, today), activity chart, best day highlight in `chahriyti_platform/src/features/dashboard/pages/ManagerDashboardPage.jsx`
- [x] T076 [US3] Add ManagerDashboardPage as default manager route in `chahriyti_platform/src/routes/index.jsx`

**Checkpoint**: Manager dashboard with live KPIs and activity chart is functional.

---

## Phase 7: User Story 4 — Admin Dashboard with Business Analytics (Priority: P2)

**Goal**: Admin sees aggregate business view: total clients, total managers, growth, per-manager leaderboard, trend charts, drill-down.

**Independent Test**: Create data across multiple managers → log in as admin → verify aggregate KPIs correct → verify leaderboard shows correct rankings → verify trend charts → click manager to drill down.

### Tests for US4

- [x] T077 [P] [US4] Write test for AdminDashboardPage: KPI cards, leaderboard, trend chart render correctly in `chahriyti_platform/src/features/dashboard/__tests__/AdminDashboardPage.test.jsx`
- [x] T078 [P] [US4] Write test for useAdminDashboard hook: aggregate data, period switching, drill-down state in `chahriyti_platform/src/features/dashboard/__tests__/useAdminDashboard.test.js`

### Implementation for US4

- [x] T079 [US4] Create useAdminDashboard hook: call getDashboardStats (no managerId filter), real-time listener on `stats/global`, period selector, drill-down state in `chahriyti_platform/src/features/dashboard/hooks/useAdminDashboard.js`
- [x] T080 [US4] Create ManagerLeaderboard component: ranked list of managers with avatar/name/count, clickable rows for drill-down in `chahriyti_platform/src/features/dashboard/components/ManagerLeaderboard.jsx`
- [x] T081 [US4] Create TrendChart component: Recharts BarChart/AreaChart, daily/weekly/monthly toggle, growth indicator, Chahriyti colors in `chahriyti_platform/src/features/dashboard/components/TrendChart.jsx`
- [x] T082 [US4] Create GrowthIndicator component: percentage change vs previous period, up/down arrow, green/red color in `chahriyti_platform/src/features/dashboard/components/GrowthIndicator.jsx`
- [x] T083 [US4] Create ManagerDrilldown component: modal or panel showing individual manager stats + chart when clicked from leaderboard in `chahriyti_platform/src/features/dashboard/components/ManagerDrilldown.jsx`
- [x] T084 [US4] Create AdminDashboardPage: KPI cards row (total clients, total managers, growth), leaderboard, trend chart, drill-down panel in `chahriyti_platform/src/features/dashboard/pages/AdminDashboardPage.jsx`
- [x] T085 [US4] Add AdminDashboardPage as default admin route in `chahriyti_platform/src/routes/index.jsx`

**Checkpoint**: Admin dashboard with full analytics, leaderboard, and drill-down is functional.

---

## Phase 8: User Story 5 — Admin Manages Manager Accounts (Priority: P2)

**Goal**: Admin creates, views, and deactivates manager accounts.

**Independent Test**: Log in as admin → create manager → verify manager appears in list → log in as new manager → deactivate manager → verify manager cannot log in.

### Tests for US5

- [x] T086 [P] [US5] Write test for ManagersPage: list renders, add modal works, status toggle works in `chahriyti_platform/src/features/managers/__tests__/ManagersPage.test.jsx`
- [x] T087 [P] [US5] Write test for createManager Cloud Function: valid input → user created, duplicate email → error in `chahriyti_platform/functions/__tests__/createManager.test.js`
- [x] T088 [P] [US5] Write test for updateUserStatus Cloud Function: deactivate works, cannot deactivate last admin in `chahriyti_platform/functions/__tests__/updateUserStatus.test.js`

### Implementation for US5

- [x] T089 [US5] Create createManager Cloud Function: create Firebase Auth user, set custom claims, write user doc, update stats in `chahriyti_platform/functions/src/createManager.js`
- [x] T090 [US5] Create updateUserStatus Cloud Function: toggle status, revoke tokens on deactivate, prevent last admin deactivation in `chahriyti_platform/functions/src/updateUserStatus.js`
- [x] T091 [US5] Export createManager and updateUserStatus in `chahriyti_platform/functions/src/index.js`
- [x] T092 [US5] Create useManagers hook: fetch managers list, real-time listener, create/deactivate methods, loading states in `chahriyti_platform/src/features/managers/hooks/useManagers.js`
- [x] T093 [US5] Create AddManagerModal component: form (email, name, password), validation, submit in `chahriyti_platform/src/features/managers/components/AddManagerModal.jsx`
- [x] T094 [US5] Create ManagersTable component: columns (name, email, status badge, client count, created date, actions), status toggle button in `chahriyti_platform/src/features/managers/components/ManagersTable.jsx`
- [x] T095 [US5] Create ConfirmDeactivateModal component: warning message, confirm/cancel buttons in `chahriyti_platform/src/features/managers/components/ConfirmDeactivateModal.jsx`
- [x] T096 [US5] Create ManagersPage: compose toolbar (add button, search) + table + modals in `chahriyti_platform/src/features/managers/pages/ManagersPage.jsx`
- [x] T097 [US5] Add ManagersPage route to admin portal routes in `chahriyti_platform/src/routes/index.jsx`

**Checkpoint**: Admin can fully manage manager accounts. All CRUD operations work with proper validation.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Final quality pass across all features

### Visual Polish

- [x] T098 [P] Add page transition animations (fade/slide) using CSS transitions in layout components
- [x] T099 [P] Add skeleton loading states for dashboard cards and tables in `chahriyti_platform/src/components/ui/Skeleton.jsx`
- [x] T100 [P] Add responsive breakpoints for tablet/mobile fallback in layout components
- [x] T101 Review and polish all pages for visual consistency: spacing, typography, color usage, shadows, border radius

### Error Handling & UX

- [x] T102 [P] Create global error boundary component with branded error page in `chahriyti_platform/src/components/ui/ErrorBoundary.jsx`
- [x] T103 [P] Add toast notifications for all user actions (license generated, manager created, errors) using react-hot-toast
- [x] T104 Add session expiry handling: detect deactivated user on next request, force logout with message

### Security & Performance

- [x] T105 Verify Firestore security rules with emulator tests: manager can't read other managers' clients, can't write directly in `chahriyti_platform/firestore.rules`
- [x] T106 [P] Add React.memo to heavy list components (ClientsTable, ManagersTable, Leaderboard)
- [x] T107 [P] Verify all Cloud Functions validate auth and input before processing

### Deployment

- [x] T108 Create Firebase deployment script: deploy functions + rules + indexes in `chahriyti_platform/package.json` scripts
- [x] T109 Create admin seed script: create initial admin account via Firebase Admin SDK in `chahriyti_platform/functions/src/seed.js`
- [x] T110 Final end-to-end walkthrough: login → generate license → view history → check dashboard → manage managers → verify real-time sync

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — BLOCKS all user stories
- **Phase 3 (US6 Auth)**: Depends on Phase 2 — BLOCKS all other user stories (auth required first)
- **Phase 4 (US1 License)**: Depends on Phase 3 (needs auth + portal layout)
- **Phase 5 (US2 Clients)**: Depends on Phase 3. Can run parallel with Phase 4.
- **Phase 6 (US3 Manager Dashboard)**: Depends on Phase 3. Can run parallel with Phases 4-5.
- **Phase 7 (US4 Admin Dashboard)**: Depends on Phase 3. Can run parallel with Phases 4-6.
- **Phase 8 (US5 Manager Management)**: Depends on Phase 3. Can run parallel with Phases 4-7.
- **Phase 9 (Polish)**: Depends on all user stories complete.

### User Story Dependencies

- **US6 (Auth)**: Foundation only — MUST be first
- **US1 (License Gen)**: US6 only — primary MVP feature
- **US2 (Client History)**: US6 only — reads client data (benefits from US1 test data but not blocked by it)
- **US3 (Manager Dashboard)**: US6 only — reads stats data
- **US4 (Admin Dashboard)**: US6 only — reads aggregate stats
- **US5 (Manager Mgmt)**: US6 only — manages users

### Within Each User Story

1. Tests written first → verify they fail
2. Cloud Functions (backend) before frontend hooks
3. Hooks (logic) before components (UI)
4. Components before page composition
5. Route registration last

### Parallel Opportunities

- All T011-T020 design system components can run in parallel
- All T028-T032 utilities and their tests can run in parallel
- T033-T037 Cloud Function foundations can run in parallel
- After US6 auth is complete: US1, US2, US3, US4, US5 can ALL run in parallel
- Within each US: tests can run in parallel, components can run in parallel

---

## Parallel Example: Phase 2 Foundation

```
# All design system components in parallel:
T011: Button component
T012: Input component
T013: Card component
T014: Modal component
T015: Badge component
T016: Spinner component
T017: EmptyState component
T018: Pagination component
T019: DateRangePicker component
T020: KPICard component

# All utilities in parallel:
T028: validators.js
T029: formatters.js
T030: constants.js
T031: validators tests
T032: formatters tests
```

## Parallel Example: After Auth (US6) Complete

```
# All user stories can start simultaneously:
Developer A: US1 (License Generation) — T050-T060
Developer B: US2 (Client History) — T061-T068
Developer C: US3+US4 (Dashboards) — T069-T085
Developer D: US5 (Manager Management) — T086-T097
```

---

## Implementation Strategy

### MVP First (US6 + US1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundation
3. Complete Phase 3: US6 Auth → login + portals work
4. Complete Phase 4: US1 License → **MVP READY: managers can generate licenses**
5. STOP and VALIDATE: Deploy, get real user feedback

### Incremental Delivery

1. Setup + Foundation → tooling ready
2. US6 (Auth) → portals accessible
3. US1 (License Gen) → **MVP** — core business works
4. US2 (Client History) → managers can look up clients
5. US3 (Manager Dashboard) → managers see their stats
6. US4 (Admin Dashboard) → admins see business overview
7. US5 (Manager Mgmt) → admins manage team
8. Polish → production-ready

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- User explicitly required testing — all phases include test tasks
- License key algorithm MUST produce identical output to `tools/generate_license.dart` for same inputs
- All Firestore writes go through Cloud Functions — never direct client writes
- Real-time sync via `onSnapshot` listeners for dashboards and stats
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
