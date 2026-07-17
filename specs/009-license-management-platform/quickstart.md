# Quickstart: License Management Platform

**Date**: 2026-07-14

## Prerequisites

- Node.js 18+
- Firebase CLI (`npm install -g firebase-tools`)
- Firebase project created with Auth + Firestore enabled

## Setup

```bash
cd chahriyti_platform

# Install dependencies
npm install

# Install Firebase tools
npm install firebase firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase (select Auth, Firestore, Functions, Emulators)
firebase init

# Start Firebase emulators for local development
firebase emulators:start

# Start React dev server
npm start
```

## Project Structure

```
chahriyti_platform/
├── public/
├── src/
│   ├── components/          # Shared UI components (Button, Card, Input, Modal, etc.)
│   │   ├── ui/              # Base design system components
│   │   ├── charts/          # Chart wrapper components
│   │   └── layout/          # Layout shells (AdminLayout, ManagerLayout)
│   ├── features/            # Feature modules (separation of concerns)
│   │   ├── auth/            # Login, auth guards, role routing
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── license/         # License generation (manager)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── clients/         # Client history (manager)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   ├── dashboard/       # Dashboard (both portals)
│   │   │   ├── pages/
│   │   │   ├── hooks/
│   │   │   └── components/
│   │   └── managers/        # Manager management (admin)
│   │       ├── pages/
│   │       ├── hooks/
│   │       └── components/
│   ├── services/            # Firebase service layer (NO business logic)
│   │   ├── auth.js          # Firebase Auth calls
│   │   ├── firestore.js     # Firestore CRUD operations
│   │   └── functions.js     # Cloud Function invocations
│   ├── hooks/               # Shared hooks (useAuth, useRole, etc.)
│   ├── utils/               # Pure utility functions (validators, formatters)
│   ├── config/              # Firebase config, constants, theme tokens
│   ├── contexts/            # React Context providers (AuthContext)
│   ├── routes/              # Route definitions, guards, lazy loading
│   ├── App.js
│   └── index.js
├── functions/               # Firebase Cloud Functions
│   ├── src/
│   │   ├── license.js       # generateLicense function
│   │   ├── users.js         # createManager, updateUserStatus
│   │   ├── stats.js         # getDashboardStats, counter updates
│   │   └── index.js         # Function exports
│   └── package.json
├── firestore.rules
├── firestore.indexes.json
├── firebase.json
├── tailwind.config.js
└── package.json
```

## Key Dependency Direction

```
Pages → Hooks → Services → Firebase SDK
  ↓
Components (pure UI, props only)
```

- Pages compose layout + feature components
- Hooks contain business logic, call services
- Services wrap Firebase SDK calls
- Components receive data via props, never call services directly
- Utils are pure functions, no side effects

## Environment Variables

```
REACT_APP_FIREBASE_API_KEY=
REACT_APP_FIREBASE_AUTH_DOMAIN=
REACT_APP_FIREBASE_PROJECT_ID=
REACT_APP_FIREBASE_STORAGE_BUCKET=
REACT_APP_FIREBASE_MESSAGING_SENDER_ID=
REACT_APP_FIREBASE_APP_ID=
```

## Running Tests

```bash
# Unit + component tests
npm test

# With Firebase emulators (integration)
firebase emulators:exec "npm test"
```
