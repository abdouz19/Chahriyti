# Firestore Security Rules Contract

**Date**: 2026-07-14

## Rules Summary

| Collection | Read | Write | Delete |
|-----------|------|-------|--------|
| `users` | Admin: all. Manager: own doc only. | Cloud Functions only. | Never. |
| `clients` | Admin: all. Manager: own clients only (`managerId == uid`). | Cloud Functions only. | Never. |
| `stats/global` | Any authenticated user. | Cloud Functions only. | Never. |
| `stats/managers/{id}` | Admin: all. Manager: own doc only. | Cloud Functions only. | Never. |
| `stats/daily/{date}` | Any authenticated user. | Cloud Functions only. | Never. |

## Key Constraints

- All write operations go through Cloud Functions (never direct client writes)
- Manager can only read their own clients and stats
- Admin can read everything
- No document deletion — data is append-only
- Role is verified via Firebase Auth custom claims in security rules
