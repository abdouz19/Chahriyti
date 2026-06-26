# Quickstart: Chahriyti

**Date**: 2026-06-25

## Prerequisites

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2
- Android Studio / Xcode (for platform builds)
- A physical device or emulator (Android 8+ / iOS 15+)

## Setup

```bash
cd chahriyti

# Install dependencies
flutter pub get

# Generate code (Drift tables, Freezed models, json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Code Generation

After modifying Drift tables, Freezed models, or json_serializable classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous watching during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Running Tests

```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Integration tests
flutter test integration_test/

# With coverage
flutter test --coverage
```

## Building for Release

```bash
# Android APK (with code obfuscation for license key security)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Android App Bundle
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# iOS
flutter build ios --release --obfuscate --split-debug-info=build/debug-info
```

## License Key Generation (Admin Tool)

```bash
# Generate a license key for a device (run from project root)
dart run tools/generate_license.dart --device-id <DEVICE_ID> --expiry 202712
```

## Project Structure

```
chahriyti/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── app.dart                           # MaterialApp configuration
│   ├── core/
│   │   ├── theme/                         # Color palette, typography, app theme
│   │   ├── constants/                     # App-wide constants (categories, wilayas)
│   │   ├── extensions/                    # Dart extensions (formatting, etc.)
│   │   └── di/                            # Dependency injection setup
│   ├── domain/
│   │   ├── entities/                      # Pure Dart entities (Freezed)
│   │   ├── repositories/                  # Repository interfaces
│   │   └── value_objects/                 # Value objects (Money, DeviceId, etc.)
│   ├── application/
│   │   └── use_cases/                     # One use case per business operation
│   ├── infrastructure/
│   │   ├── database/                      # Drift database, tables, DAOs
│   │   ├── repositories/                  # Repository implementations
│   │   └── services/                      # Device info, secure storage, etc.
│   └── presentation/
│       ├── onboarding/                    # Splash, salary setup, value prop
│       ├── activation/                    # License activation flow
│       ├── home/                          # Dashboard, balance cards
│       ├── expense/                       # Add/edit expense flow
│       ├── history/                       # Full expense history
│       ├── statistics/                    # Analytics, charts, classification
│       ├── debt/                          # Debt management
│       ├── goal/                          # Savings goals
│       ├── settings/                      # Settings, cycle reset
│       └── shared/
│           ├── widgets/                   # Reusable widgets (EmptyState, etc.)
│           └── routing/                   # GoRouter configuration
├── assets/
│   ├── illustrations/                     # SVG empty states (from unDraw)
│   ├── animations/                        # Lottie onboarding animations
│   └── fonts/                             # Cairo font files (if not using google_fonts)
├── test/
│   ├── unit/                              # Domain & application layer tests
│   └── widget/                            # Presentation layer tests
├── integration_test/                      # Full flow integration tests
└── tools/
    └── generate_license.dart              # Admin license key generator
```

## Key Conventions

- **Monetary values**: Always in centimes (1 DZD = 100 centimes). Use `Money` value object for type safety
- **RTL**: All text uses `TextAlign.start`, never `.left`/`.right`
- **Currency display**: Wrap amounts in LTR directionality, append `دج`
- **State management**: BloC/Cubit only — never call repositories from widgets
- **Navigation**: GoRouter only — no `Navigator.push` calls
- **Code generation**: Run `build_runner` after touching `*.drift.dart`, `*.freezed.dart`, or `*.g.dart` files
