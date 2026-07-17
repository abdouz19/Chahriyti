# Research: License Management Platform

**Date**: 2026-07-14

## R1: License Generation Algorithm — Server-Side Port

**Decision**: Port the Dart HMAC-SHA256 license algorithm to a Firebase Cloud Function (Node.js). The secret MUST NOT exist in frontend code.

**Rationale**: The existing Dart algorithm uses `HMAC(SHA-256, secret)` over `"${deviceId}|${expiryYYYYMM}"`, takes the first 16 hex chars uppercase, and formats as `CHRY-XXXX-XXXX-XXXX-XXXX`. Node.js `crypto` module provides identical HMAC-SHA256 output. The secret (`chahriyti_license_secret_2026`) must live server-side only to prevent key forgery.

**Alternatives considered**:
- Client-side generation (rejected: exposes secret in browser)
- Separate backend service (rejected: Firebase Cloud Functions sufficient for scale)

## R2: Firebase Architecture

**Decision**: Use Firebase Auth (email/password) + Firestore + Cloud Functions.

**Rationale**:
- **Auth**: Firebase Auth with custom claims for role (`admin`/`manager`). Custom claims are set via Cloud Functions on user creation. Enforced in Firestore security rules and frontend route guards.
- **Firestore**: NoSQL document database. Collections: `users`, `clients`, `licenses`. Firestore scales automatically, supports real-time listeners for dashboard sync, and pagination via cursors.
- **Cloud Functions**: License generation endpoint (HTTPS callable). Validates auth, generates key, writes to Firestore atomically.

**Alternatives considered**:
- Realtime Database (rejected: Firestore better for complex queries and offline)
- External auth provider (rejected: Firebase Auth integrates natively)

## R3: Frontend Architecture — Separation of Concerns

**Decision**: Feature-based folder structure with clear layer separation: pages (routes), components (UI), hooks (logic), services (Firebase calls), utils (pure functions).

**Rationale**: User insists on separation of concerns. React doesn't enforce architecture, so we impose it:
- **Pages**: Route-level components, compose layout + feature components
- **Components**: Pure UI, receive data via props, no Firebase calls
- **Hooks**: Business logic, state management, call services
- **Services**: Firebase SDK calls (Firestore queries, auth operations)
- **Utils**: Pure functions (formatters, validators, license algorithm)

**Alternatives considered**:
- Redux/MobX (rejected: overkill for this scale, React Context + hooks sufficient)
- Atomic design (rejected: adds naming overhead without proportional benefit at this scale)

## R4: UI Framework & Design System

**Decision**: Tailwind CSS + Recharts for charts. No heavy UI framework (MUI, Ant Design).

**Rationale**: User demands ultra-clean, modern, trend-matching UI. Tailwind enables pixel-perfect custom design matching Chahriyti brand identity without fighting a component library's opinionated styles. Recharts is lightweight and customizable for dashboard charts.

Brand tokens from mobile app:
- Primary: Deep Teal `#0D6E6E`
- Primary Light: `#1A9494`
- Primary Dark: `#084E4E`
- Positive: Emerald `#22C55E`
- Negative: Coral Red `#EF4444`
- Warning: Amber `#F59E0B`
- Surface: Warm White `#F8F9FA`
- Text Primary: Charcoal `#1A1A2E`
- Text Secondary: Cool Gray `#94A3B8`
- Border: `#E2E8F0`

**Alternatives considered**:
- Material UI (rejected: imposes Google design language, hard to match custom brand)
- Chakra UI (rejected: less control over fine-grained styling)
- CSS Modules (rejected: Tailwind utility-first approach faster and more consistent)

## R5: Real-Time Sync Between Entities

**Decision**: Use Firestore `onSnapshot` listeners for dashboard data. License generation triggers Firestore writes that automatically update connected dashboards.

**Rationale**: User insists everything should be synced. When a manager generates a license, the admin dashboard should reflect the new count without manual refresh. Firestore real-time listeners achieve this natively.

**Alternatives considered**:
- Polling (rejected: wasteful and laggy)
- WebSockets (rejected: Firestore already provides this)

## R6: Routing & Code Splitting

**Decision**: React Router v7 with lazy-loaded portal routes. Two layout shells: `AdminLayout` and `ManagerLayout`.

**Rationale**: Each portal has distinct navigation, sidebar, and feature set. Lazy loading ensures admin code isn't shipped to managers and vice versa, improving load time.

**Alternatives considered**:
- Next.js (rejected: adds SSR complexity unnecessary for internal tool)
- Single layout with conditional rendering (rejected: violates separation of concerns)

## R7: Testing Strategy

**Decision**: Vitest + React Testing Library for unit/component tests. Firestore emulator for integration tests.

**Rationale**: Constitution mandates testing. Vitest is fast, modern, and compatible with React. Firebase emulator suite allows local testing without hitting production.

**Alternatives considered**:
- Jest (rejected: Vitest is faster and has better ESM support)
- Cypress (deferred: E2E testing added later, not in v1 scope)

## R8: Constitution Adaptation for Web Platform

**Decision**: Adapt constitution principles to React/Firebase context. Not all Flutter-specific rules apply.

**Mapping**:
| Constitution Principle | Adaptation |
|---|---|
| I. Offline-First | N/A — web platform requires internet. Data safety still applies. |
| II. Testing Mandatory | Applies fully. Unit tests for hooks/services, component tests for UI. |
| III. Data Safety | Applies via Firestore transactions for license generation. |
| IV. Tech Stack | React, Firebase, Tailwind — documented and justified above. |
| V. Clean Architecture | Adapted: pages → hooks → services → Firebase (same dependency direction). |
| VI. Separation of Concerns | Applies fully — user explicitly requested this. |
| VII. Performance | Lazy loading, pagination, efficient queries. No unnecessary re-renders. |
| VIII. Stability | Applies. No experimental deps. Pin versions. |
| IX. Definition of Done | Adapted: implemented + tested + no perf regression + role-guarded. |
