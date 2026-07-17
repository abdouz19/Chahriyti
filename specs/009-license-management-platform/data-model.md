# Data Model: License Management Platform

**Date**: 2026-07-14

## Firestore Collections

### Collection: `users`

Stores all platform users (admins and managers).

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `uid` | string (document ID) | yes | Firebase Auth UID |
| `email` | string | yes | Login email |
| `displayName` | string | yes | Full name |
| `role` | string (`admin` \| `manager`) | yes | User role, also stored as Firebase Auth custom claim |
| `status` | string (`active` \| `inactive`) | yes | Account status |
| `createdAt` | timestamp | yes | Account creation date |
| `createdBy` | string (uid ref) | yes | Admin who created this account |
| `lastLoginAt` | timestamp | no | Last successful login |

**Indexes**:
- `role` + `status` (for admin listing managers)
- `status` (for auth guard checks)

---

### Collection: `clients`

Stores every client who received a license.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string (auto-generated document ID) | yes | Unique client record ID |
| `name` | string | yes | Client's full name |
| `phone` | string | yes | Client's phone number |
| `deviceId` | string | yes | Device ID from mobile app |
| `licenseKey` | string | yes | Generated license key (CHRY-XXXX-XXXX-XXXX-XXXX) |
| `expiryDate` | string (YYYYMM) | yes | License expiry month |
| `generatedAt` | timestamp | yes | When the license was generated |
| `managerId` | string (uid ref) | yes | Manager who generated the license |
| `managerName` | string | yes | Denormalized manager name for display |

**Indexes**:
- `managerId` + `generatedAt` desc (manager history, paginated)
- `name` (search)
- `phone` (search)
- `deviceId` (duplicate check)
- `generatedAt` desc (global listing for admin)

---

### Collection: `stats` (aggregation documents)

Pre-computed counters for dashboard performance. Updated via Cloud Functions on each license generation.

#### Document: `stats/global`

| Field | Type | Description |
|-------|------|-------------|
| `totalClients` | number | All-time total clients |
| `totalManagers` | number | Total active managers |
| `todayClients` | number | Clients generated today (reset daily) |
| `monthClients` | number | Clients generated this month (reset monthly) |
| `lastUpdated` | timestamp | Last update time |

#### Document: `stats/managers/{managerId}`

| Field | Type | Description |
|-------|------|-------------|
| `totalClients` | number | Manager's all-time total |
| `todayClients` | number | Manager's today count |
| `monthClients` | number | Manager's month count |
| `lastUpdated` | timestamp | Last update time |

#### Document: `stats/daily/{YYYY-MM-DD}`

| Field | Type | Description |
|-------|------|-------------|
| `total` | number | Total clients that day |
| `byManager` | map<string, number> | Per-manager count for that day |

---

## Entity Relationships

```
users (1) ──── generates ────> (many) clients
  │                                │
  │ role: admin                    │ contains
  │ manages                       │
  ▼                               ▼
users (many)                   license key
  role: manager                (embedded in client)
```

- A **manager** generates many **clients** (1:N via `managerId`)
- An **admin** creates many **managers** (1:N via `createdBy`)
- A **client** has exactly one **license key** (embedded, not a separate collection)
- **Stats** are denormalized aggregates updated atomically on each license generation

## Validation Rules

| Entity | Field | Rule |
|--------|-------|------|
| Client | name | Non-empty, max 100 chars |
| Client | phone | Non-empty, 9-15 digits (Algerian format: starts with 0 or +213) |
| Client | deviceId | Non-empty, must be hex string (SHA-256 hash from mobile app) |
| User | email | Valid email format |
| User | displayName | Non-empty, max 100 chars |
| User | role | Must be `admin` or `manager` |

## State Transitions

### User Status
```
active ──── deactivate (by admin) ────> inactive
inactive ── reactivate (by admin) ────> active
```

- Deactivated users cannot log in (enforced by auth guard checking Firestore `status` field)
- Last admin cannot be deactivated (enforced by Cloud Function)

### License Lifecycle
```
generated ──── (12 months pass) ────> expired
```
- No revocation in v1. License validity is checked client-side by the mobile app against expiry date.
