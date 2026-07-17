# Cloud Functions API Contracts

**Date**: 2026-07-14

## generateLicense

HTTPS Callable function. Generates a license key for a client.

**Auth**: Required. Caller must have `manager` or `admin` role.

### Request

```json
{
  "clientName": "string (required, 1-100 chars)",
  "phone": "string (required, 9-15 digits)",
  "deviceId": "string (required, hex SHA-256 hash)"
}
```

### Response (success)

```json
{
  "success": true,
  "data": {
    "clientId": "string (Firestore document ID)",
    "licenseKey": "string (CHRY-XXXX-XXXX-XXXX-XXXX)",
    "expiryDate": "string (YYYYMM)",
    "generatedAt": "string (ISO 8601 timestamp)"
  }
}
```

### Response (error)

```json
{
  "success": false,
  "error": {
    "code": "string (VALIDATION_ERROR | UNAUTHORIZED | INTERNAL)",
    "message": "string (human-readable)"
  }
}
```

### Side Effects

- Creates document in `clients` collection
- Increments counters in `stats/global`, `stats/managers/{managerId}`, `stats/daily/{date}`
- All writes are atomic (Firestore batch/transaction)

---

## createManager

HTTPS Callable function. Creates a new manager account.

**Auth**: Required. Caller must have `admin` role.

### Request

```json
{
  "email": "string (required, valid email)",
  "displayName": "string (required, 1-100 chars)",
  "password": "string (required, min 8 chars)"
}
```

### Response (success)

```json
{
  "success": true,
  "data": {
    "uid": "string (Firebase Auth UID)",
    "email": "string",
    "displayName": "string",
    "role": "manager"
  }
}
```

### Side Effects

- Creates Firebase Auth user
- Sets custom claim `{ role: "manager" }`
- Creates document in `users` collection
- Increments `stats/global.totalManagers`

---

## updateUserStatus

HTTPS Callable function. Activates or deactivates a user.

**Auth**: Required. Caller must have `admin` role.

### Request

```json
{
  "uid": "string (required, target user UID)",
  "status": "string (required, 'active' | 'inactive')"
}
```

### Response (success)

```json
{
  "success": true,
  "data": {
    "uid": "string",
    "status": "string",
    "updatedAt": "string (ISO 8601)"
  }
}
```

### Validation

- Cannot deactivate the last active admin
- Cannot change own status (prevents self-lockout)

### Side Effects

- Updates `users/{uid}.status`
- If deactivating: revokes Firebase Auth refresh tokens (forces re-auth)
- Updates `stats/global.totalManagers` count

---

## getDashboardStats

HTTPS Callable function. Returns aggregated stats for dashboards.

**Auth**: Required. Any authenticated user.

### Request

```json
{
  "period": "string (optional, 'week' | 'month' | 'quarter' | 'year', default: 'month')",
  "managerId": "string (optional, for admin drill-down)"
}
```

### Response

```json
{
  "success": true,
  "data": {
    "totalClients": "number",
    "monthClients": "number",
    "todayClients": "number",
    "totalManagers": "number (admin only)",
    "growthPercent": "number (vs previous period)",
    "dailyCounts": [
      { "date": "YYYY-MM-DD", "count": "number" }
    ],
    "managerLeaderboard": [
      { "managerId": "string", "name": "string", "count": "number" }
    ]
  }
}
```

### Behavior

- If caller is `manager`: returns only their own data, `managerLeaderboard` is omitted
- If caller is `admin`: returns aggregate data across all managers
- If `managerId` is provided (admin only): returns that specific manager's data
