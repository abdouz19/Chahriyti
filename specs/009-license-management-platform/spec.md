# Feature Specification: License Management Platform

**Feature Branch**: `009-license-management-platform`  
**Created**: 2026-07-14  
**Status**: Draft  
**Input**: User description: "License management platform with Admin and Manager portals for generating client licenses, tracking clients, and monitoring business performance"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Manager Generates a License for a Client (Priority: P1)

A manager receives a client request (typically via WhatsApp) to activate the Chahriyti mobile app. The manager opens the platform, navigates to the license generation form, enters the client's name, phone number, and device ID (provided by the client from the app). The system generates a license key that the manager copies and sends back to the client. The client record is automatically saved.

**Why this priority**: This is the core business operation — without license generation, the platform has no purpose. Every other feature builds on top of this.

**Independent Test**: Can be fully tested by entering client details into the form, generating a license key, and verifying the key follows the expected format (CHRY-XXXX-XXXX-XXXX-XXXX). The generated key should activate the mobile app successfully.

**Acceptance Scenarios**:

1. **Given** a manager is logged in, **When** they fill in client name, phone number, and device ID and submit, **Then** the system generates a valid license key displayed on screen with a copy button.
2. **Given** a manager submits the form, **When** the license is generated, **Then** the client record (name, phone, device ID, license key, date, manager who generated it) is saved to the database.
3. **Given** a manager enters an invalid device ID (wrong format or empty), **When** they submit, **Then** the system shows a clear validation error and does not generate a key.
4. **Given** a manager generates a license, **When** they click the copy button, **Then** the license key is copied to clipboard with visual confirmation.

---

### User Story 2 - Manager Views Client History (Priority: P1)

A manager needs to look up a previous client or review their daily/weekly activity. They navigate to the client history view, which shows a paginated list of all clients they have served. They can search by name or phone number, filter by date range, and see how many clients they served on any given day.

**Why this priority**: Equal to license generation — managers need to track their work, look up past clients, and avoid duplicate entries.

**Independent Test**: Can be tested by generating several client records, then verifying they appear in the history with correct pagination, search, and filtering.

**Acceptance Scenarios**:

1. **Given** a manager has generated licenses for multiple clients, **When** they open the client history, **Then** they see a paginated table of clients sorted by most recent first.
2. **Given** the client history is displayed, **When** the manager searches by client name or phone number, **Then** the results filter in real-time.
3. **Given** the client history is displayed, **When** the manager selects a date range filter, **Then** only clients within that range are shown.
4. **Given** the manager views the history, **When** they look at the summary bar, **Then** they see the total number of clients for today and overall.

---

### User Story 3 - Manager Dashboard with KPIs (Priority: P2)

A manager wants a quick overview of their performance. Their dashboard shows key metrics: total clients served (all-time, this month, today), a chart of daily client activations over time, and their most active days.

**Why this priority**: Gives managers visibility into their own productivity and motivates performance.

**Independent Test**: Can be tested by generating client records across multiple dates and verifying the dashboard metrics and charts reflect accurate data.

**Acceptance Scenarios**:

1. **Given** a manager logs in, **When** the dashboard loads, **Then** they see KPI cards: total clients (all-time), clients this month, clients today.
2. **Given** a manager views the dashboard, **When** they look at the activity chart, **Then** it shows daily client counts for the selected period (default: last 30 days).
3. **Given** a manager has served clients on various days, **When** they view the dashboard, **Then** the data accurately reflects their individual activity (not other managers' data).

---

### User Story 4 - Admin Dashboard with Business Analytics (Priority: P2)

An admin needs a bird's-eye view of the entire business. Their dashboard shows comprehensive charts and KPIs: total clients across all managers, revenue trends, per-manager performance comparison, daily/weekly/monthly activation trends, and growth metrics.

**Why this priority**: Admins need visibility to make business decisions, identify top performers, and track growth.

**Independent Test**: Can be tested by creating data across multiple managers and verifying the admin dashboard aggregates and displays it correctly.

**Acceptance Scenarios**:

1. **Given** an admin logs in, **When** the dashboard loads, **Then** they see aggregate KPI cards: total clients (all-time, this month, today), total managers, and growth percentage.
2. **Given** the admin views the dashboard, **When** they look at the manager leaderboard, **Then** they see each manager ranked by number of clients confirmed, with their name and count.
3. **Given** the admin views the dashboard, **When** they look at the trend charts, **Then** they see daily/weekly/monthly activation trends with the ability to switch time periods.
4. **Given** the admin views the dashboard, **When** they select a specific manager, **Then** they can drill down into that manager's individual performance.

---

### User Story 5 - Admin Manages Manager Accounts (Priority: P2)

An admin needs to create, view, and deactivate manager accounts. They can invite new managers by providing their email, and deactivate managers who are no longer active.

**Why this priority**: Essential for multi-manager operations — admins must control who has access to generate licenses.

**Independent Test**: Can be tested by creating a manager account, verifying the manager can log in, then deactivating and verifying access is revoked.

**Acceptance Scenarios**:

1. **Given** an admin is logged in, **When** they navigate to manager management, **Then** they see a list of all managers with their status (active/inactive) and client count.
2. **Given** an admin clicks "Add Manager", **When** they provide an email and name, **Then** the manager account is created and an invitation is sent.
3. **Given** an admin selects an active manager, **When** they deactivate the account, **Then** the manager can no longer log in or generate licenses.

---

### User Story 6 - Role-Based Authentication and Portal Routing (Priority: P1)

Users log in with their credentials. Based on their role (Admin or Manager), they are automatically routed to the appropriate portal with its own layout, navigation, and feature set. Unauthorized access to the other portal is blocked.

**Why this priority**: Foundational — all other features depend on knowing who the user is and what they can access.

**Independent Test**: Can be tested by logging in as admin and manager separately, verifying each sees only their portal, and attempting cross-portal access is denied.

**Acceptance Scenarios**:

1. **Given** a user visits the platform, **When** they are not authenticated, **Then** they see a login page.
2. **Given** a user logs in with valid admin credentials, **When** authentication succeeds, **Then** they are routed to the admin portal.
3. **Given** a user logs in with valid manager credentials, **When** authentication succeeds, **Then** they are routed to the manager portal.
4. **Given** a manager is logged in, **When** they attempt to access an admin-only route, **Then** they are redirected to their own portal.

---

### Edge Cases

- What happens when a manager tries to generate a license for a device ID that already has an active license? System should warn but allow re-generation (client may have reinstalled the app).
- What happens when a manager is deactivated while they are logged in? Their session should be invalidated on next request.
- What happens if the same phone number is used for multiple clients? Allow it — different family members may share a phone number.
- What happens when an admin tries to deactivate the last remaining admin? System should prevent this to avoid lockout.
- What happens if the platform is accessed on mobile? The UI should be responsive but optimized for desktop use (managers typically work from computers).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST support two distinct roles: Admin and Manager, each with their own portal and permissions.
- **FR-002**: System MUST authenticate users and route them to the correct portal based on their role.
- **FR-003**: Managers MUST be able to generate license keys by providing client name, phone number, and device ID.
- **FR-004**: System MUST generate license keys using the same algorithm as the mobile app's existing license validation (HMAC-based, format: CHRY-XXXX-XXXX-XXXX-XXXX).
- **FR-005**: System MUST automatically set the license expiry to 12 months from the generation date.
- **FR-006**: System MUST persist every generated license as a client record (name, phone, device ID, license key, generation date, expiry date, generating manager).
- **FR-007**: Managers MUST be able to view their client history in a paginated list with search (by name/phone) and date filtering.
- **FR-008**: Manager dashboard MUST display KPIs: total clients all-time, this month, and today.
- **FR-009**: Manager dashboard MUST show a chart of daily client activations over a selectable time period.
- **FR-010**: Admin dashboard MUST display aggregate KPIs: total clients, total managers, growth metrics.
- **FR-011**: Admin dashboard MUST show per-manager performance comparison (leaderboard).
- **FR-012**: Admin dashboard MUST show activation trend charts (daily/weekly/monthly).
- **FR-013**: Admins MUST be able to create and deactivate manager accounts.
- **FR-014**: System MUST prevent access to admin features by manager-role users and vice versa.
- **FR-015**: Generated license keys MUST include a one-click copy-to-clipboard function.
- **FR-016**: System MUST validate all form inputs before generating a license (non-empty name, valid phone format, non-empty device ID).
- **FR-017**: UI MUST follow the Chahriyti mobile app brand identity (Deep Teal #0D6E6E primary, Warm White #F8F9FA background, clean modern aesthetic).
- **FR-018**: Admin MUST be able to drill down into individual manager performance details.

### Key Entities

- **Client**: Represents an activated app user — name, phone number, device ID, license key, generation date, expiry date, associated manager.
- **Manager**: A platform user who generates licenses — name, email, status (active/inactive), creation date, total clients served.
- **Admin**: A platform user with full access — name, email, manages managers and views business analytics.
- **License**: The generated activation key — key string, device ID, expiry date, generation date, linked client and manager.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A manager can generate a license key for a new client in under 30 seconds from form open to key copied.
- **SC-002**: Client history search returns results within 1 second for datasets up to 50,000 records.
- **SC-003**: Dashboard charts and KPIs load within 2 seconds on initial page load.
- **SC-004**: 100% of generated license keys are valid and successfully activate the mobile app.
- **SC-005**: Both Admin and Manager portals are fully functional and visually consistent with the Chahriyti brand identity.
- **SC-006**: System supports at least 10 concurrent managers generating licenses without performance degradation.
- **SC-007**: All client data (name, phone, device ID) is stored securely and only accessible to authorized users.
- **SC-008**: Manager cannot access any admin functionality, and admin routes are fully protected.

## Assumptions

- Managers will primarily use the platform from desktop browsers (Chrome, Firefox, Edge). Mobile responsiveness is secondary.
- The license generation algorithm must exactly match the one used in the mobile app's validation logic (HMAC-SHA256 with shared secret).
- License expiry is fixed at 12 months from generation date — no custom expiry needed for v1.
- Admin accounts are pre-created (seeded) — there is no self-registration for admins.
- Manager invitations are handled via email-based authentication.
- The platform will be used by a small team (1-3 admins, up to 20 managers) — enterprise-scale multi-tenancy is not required.
- Client data (name, phone number) is collected for business records only — no marketing or automated communication is planned.
- The existing React project scaffold at `chahriyti_platform/` is the target codebase.
