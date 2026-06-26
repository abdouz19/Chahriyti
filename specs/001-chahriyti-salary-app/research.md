# Research: Chahriyti — Salary & Expense Management App

**Date**: 2026-06-25  
**Spec**: [spec.md](./spec.md)

## 1. Drift (SQLite ORM) — Offline-First

**Decision**: Use Drift with WAL journal mode, `limit`/`offset` pagination, and reactive `StreamingQuery` for dashboard.

**Rationale**:
- WAL mode enables concurrent reads during writes — enable via `customStatement('PRAGMA journal_mode=WAL;')` in `onOpen`
- Explicit `MigrationStrategy` with `from`/`to` steps — never auto-migrate
- Paginated expense lists: `(select(expenses)..limit(pageSize, offset: page * pageSize)).get()`
- Keep DAOs thin: one DAO per aggregate root (`ExpensesDao`, `CyclesDao`, `DebtsDao`, `GoalsDao`)
- Use `batch()` for bulk operations (10-100x throughput)

**Alternatives considered**: `sqflite` (no type safety), `isar` (adds native binary, overkill)

## 2. Device UUID Generation

**Decision**: Use `device_info_plus` + `flutter_secure_storage` for persistent device ID.

**Rationale**:
- Android: `androidInfo.id` is stable since Android 8, survives app reinstall
- iOS: `identifierForVendor` resets on app deletion — store UUID in iOS Keychain via `flutter_secure_storage` for persistence
- Hash with SHA-256 for a stable, privacy-safe device fingerprint
- First launch: read platform ID → hash → store in secure storage as fallback

**Alternatives considered**: `android_id` (Android-only, deprecated on some ROMs), `unique_identifier` (unmaintained)

## 3. WhatsApp Deep Linking

**Decision**: Use `url_launcher` with `https://wa.me/<phone>?text=<encoded_message>`.

**Rationale**:
- `wa.me` is WhatsApp's official universal link — works on both Android and iOS
- Pre-fill message with `Uri.encodeComponent()` containing user name, phone, wilaya, device ID
- Check `canLaunchUrl` before calling `launchUrl`
- Android 11+: add `<queries>` block in AndroidManifest for package visibility

**Alternatives considered**: `whatsapp://send` scheme (unreliable on iOS), `intent://` (Android-only)

## 4. License Key Validation (Offline HMAC)

**Decision**: HMAC-SHA256 with embedded secret, keyed on `deviceId + expiry`.

**Rationale**:
- Generate key offline: `HMAC-SHA256(secret, deviceId + "|" + expiryYYYYMM)` → take first 16 chars, format as `CHRY-XXXX-XXXX-XXXX`
- Validate on-device: re-compute HMAC, compare. No network needed
- Include expiry date in payload for time-bound licenses
- Use `--obfuscate --split-debug-info` in release builds to protect the secret
- Uses `crypto` package (Dart standard)

**Alternatives considered**: RSA signatures (complex key distribution), online activation (violates offline-first)

## 5. Arabic RTL Support

**Decision**: `locale: Locale('ar')` at MaterialApp level + **Cairo** font from `google_fonts`.

**Rationale**:
- Flutter's `Directionality` widget propagates RTL automatically when locale is Arabic
- Cairo font: modern, geometric, clean numerals — excellent for financial figures. Weights 400/600/700
- Use `TextAlign.start` everywhere (not `.left`/`.right`)
- Currency amounts: wrap in `Directionality(textDirection: TextDirection.ltr)` to preserve digit order
- Include `GlobalMaterialLocalizations.delegate` and `GlobalCupertinoLocalizations.delegate`

**Alternatives considered**: Tajawal (thinner, less legible), Amiri (traditional, not modern UI)

## 6. Onboarding Animations

**Decision**: `PageView` with staggered `SlideTransition`/`AnimatedOpacity` + Lottie for illustrations.

**Rationale**:
- `smooth_page_indicator` for dot indicator — lightweight, customizable
- Staggered content entry per slide: icon 200ms, title 300ms, subtitle 400ms
- Lottie files from LottieFiles for finance/money themes, keep under 50KB each
- Max 3 onboarding screens: Welcome, Features/Value, Activation
- `BouncingScrollPhysics()` for natural page swiping feel

**Alternatives considered**: `introduction_screen` (too constrained), Rive (overkill), `flutter_animate` (extra dependency)

## 7. Empty State Illustrations

**Decision**: `flutter_svg` with optimized SVG files from unDraw, stored in `assets/illustrations/`.

**Rationale**:
- `flutter_svg` is stable, supports `colorFilter` for palette matching
- Source from unDraw.co — filter by brand color, download SVG, optimize with SVGO
- Keep files under 20KB each
- Reusable `EmptyStateWidget(illustrationPath, title, subtitle, actionButton)` in shared widgets

**Alternatives considered**: PNG (no scaling, larger), `vector_graphics` (less mature)

## 8. Color Palette

**Decision**: 6-color minimal financial palette:

| Role | Color | Hex |
|------|-------|-----|
| Primary Brand | Deep Teal | `#0D6E6E` |
| Positive / Income | Emerald Green | `#22C55E` |
| Negative / Expense | Coral Red | `#EF4444` |
| Surface / Card | Warm White | `#F8F9FA` |
| Text Primary | Charcoal | `#1A1A2E` |
| Text Secondary / Border | Cool Gray | `#94A3B8` |

**Rationale**:
- Deep Teal: professional, calm, trust-associated. Distinct from generic banking blue
- Green/Red: clear income/expense semantics, >4.5:1 contrast ratio on white
- Warm White surface avoids clinical feel for daily use
- Charcoal (not pure black) + Warm White is easier on eyes for Arabic text

**Alternatives considered**: Purple fintech (overused), black/white minimal (too stark), orange accent (clashes with red)

## Dependencies Summary

| Package | Purpose | Constitution Justification |
|---------|---------|---------------------------|
| `drift` + `drift_dev` | Local ORM (SQLite) | Approved in stack |
| `flutter_bloc` | BloC/Cubit state management | Approved in stack |
| `go_router` | Navigation | Approved in stack |
| `freezed` + `freezed_annotation` | Immutable models | Approved in stack |
| `json_serializable` + `json_annotation` | Serialization | Approved in stack |
| `device_info_plus` | Device UUID for licensing | Clear business justification: licensing |
| `flutter_secure_storage` | Persist license & device ID | Clear business justification: data safety |
| `url_launcher` | WhatsApp deep link | Clear business justification: activation flow |
| `crypto` | HMAC license validation | Clear business justification: offline licensing |
| `google_fonts` | Cairo Arabic font | Clear business justification: RTL UI |
| `flutter_svg` | Empty state illustrations | Clear business justification: UX |
| `lottie` | Onboarding animations | Clear business justification: UX |
| `smooth_page_indicator` | Onboarding dots | Clear business justification: UX |
| `path_provider` | File system access | Approved optional utility |
| `logger` | Structured logging | Approved optional utility |
| `flutter_localizations` | Arabic locale support | Clear business justification: RTL |
| `intl` | Number/date formatting | Clear business justification: DZD formatting |
