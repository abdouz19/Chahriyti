# Implementation Plan: License Management Platform

**Branch**: `009-license-management-platform` | **Date**: 2026-07-14 | **Spec**: [spec.md](spec.md)
**Input**: Feature specification from `specs/009-license-management-platform/spec.md`

## Summary

Build a web platform for managing Chahriyti mobile app license generation. Two role-based portals (Admin, Manager) with Firebase backend. Managers generate HMAC-SHA256 license keys for clients, view client history with pagination/search, and track their KPIs. Admins see aggregate analytics dashboards with charts, per-manager leaderboards, and manage manager accounts. UI must be ultra-clean, modern, and match Chahriyti brand identity exactly. Real-time sync via Firestore listeners.

## Technical Context

**Language/Version**: JavaScript (ES2022+), Node.js 18+ (Cloud Functions)
**Primary Dependencies**: React 19, React Router v7, Tailwind CSS, Recharts, Firebase SDK v10
**Storage**: Cloud Firestore (NoSQL document database)
**Testing**: Vitest + React Testing Library, Firebase Emulator Suite
**Target Platform**: Modern desktop browsers (Chrome, Firefox, Edge). Responsive secondary.
**Project Type**: Web application (SPA + serverless backend)
**Performance Goals**: Dashboard load <2s, license generation <30s end-to-end, search <1s
**Constraints**: License secret must be server-side only. All writes through Cloud Functions.
**Scale/Scope**: 1-3 admins, up to 20 managers, up to 50k client records

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. Offline-First | N/A | Web platform requires internet. Not applicable. |
| II. Testing Mandatory | PASS | Vitest + RTL for unit/component. Firebase emulator for integration. |
| III. Data Safety | PASS | All writes via Firestore transactions in Cloud Functions. No direct client writes. |
| IV. Tech Stack | ADAPTED | React/Firebase/Tailwind justified in research.md. Different from Matla Flutter stack but follows same rigor. |
| V. Clean Architecture | PASS | Pages → Hooks → Services → Firebase. Same dependency direction principle. |
| VI. Separation of Concerns | PASS | Feature-based modules. Components = pure UI. Hooks = logic. Services = data access. User explicitly requested this. |
| VII. Performance | PASS | Lazy loading portals, paginated queries, efficient Firestore indexes, memoized components. |
| VIII. Stability | PASS | Pinned dependencies, no experimental libs. |
| IX. Definition of Done | ADAPTED | Implemented + tested + role-guarded + brand-consistent + no perf regression. |

**Gate result**: PASS (no violations)

## Project Structure

### Documentation (this feature)

```text
specs/009-license-management-platform/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 research decisions
├── data-model.md        # Firestore data model
├── quickstart.md        # Setup and structure guide
├── contracts/
│   ├── cloud-functions.md   # Cloud Functions API contracts
│   └── firestore-rules.md   # Security rules contract
└── tasks.md             # Phase 2 output (created by /speckit-tasks)
```

### Source Code (repository root)

```text
chahriyti_platform/
├── public/
├── src/
│   ├── components/              # Shared UI components
│   │   ├── ui/                  # Design system (Button, Card, Input, Modal, Badge, etc.)
│   │   ├── charts/              # Chart wrappers (LineChart, BarChart, KPICard)
│   │   └── layout/              # AdminLayout, ManagerLayout, Sidebar, Header
│   ├── features/                # Feature modules
│   │   ├── auth/                # Login page, auth guards, role routing
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── license/             # License generation (manager portal)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── clients/             # Client history (manager portal)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── dashboard/           # Dashboard (admin + manager variants)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   └── managers/            # Manager management (admin portal)
│   │       ├── pages/
│   │       ├── hooks/
│   │       └── components/
│   ├── services/                # Firebase service layer
│   │   ├── auth.js
│   │   ├── firestore.js
│   │   └── functions.js
│   ├── hooks/                   # Shared hooks (useAuth, useRole)
│   ├── utils/                   # Pure functions (validators, formatters)
│   ├── config/                  # Firebase config, theme tokens, constants
│   ├── contexts/                # React Context (AuthContext)
│   ├── routes/                  # Route config, lazy loading, guards
│   ├── App.js
│   └── index.js
├── functions/                   # Firebase Cloud Functions
│   ├── src/
│   │   ├── license.js           # generateLicense
│   │   ├── users.js             # createManager, updateUserStatus
│   │   ├── stats.js             # getDashboardStats, counter logic
│   │   └── index.js
│   └── package.json
├── firestore.rules
├── firestore.indexes.json
├── firebase.json
├── tailwind.config.js
└── package.json
```

**Structure Decision**: Feature-based modular architecture within a single React SPA. Firebase Cloud Functions as serverless backend. Each feature module is self-contained with its own pages, hooks, and components — no cross-feature direct imports. Shared UI components live in `components/`. Service layer provides clean abstraction over Firebase SDK.

## Complexity Tracking

No violations. No complexity justifications needed.
