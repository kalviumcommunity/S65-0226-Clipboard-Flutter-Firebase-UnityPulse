# Clipboard App

A Flutter mobile application built with Clean Architecture and Production-Grade State Management.

## Tech Stack (2026 Optimized)
- State Management: Riverpod 3.0 (Code-Gen)
- DI: Injectable + Get_It
- Routing: GoRouter
- Persistence: Freezed (Immutable Models)
- Platforms: iOS & Android Only

## Quick Start

Execute these short commands to build, launch emulators, and run:

### Run on iOS
```bash
dart run rps ios
```

### Run on Android
```bash
dart run rps android
```

### Other Utils
- Build Code: `dart run rps build` (Runs build_runner)
- Live Watch: `dart run rps watch` (Auto-generate code on save)
- Format Code: `dart run rps format` (Stylize code)
- Auto Fix: `dart run rps fix` (Apply lint fixes)
- Analyze: `dart run rps lint` (Run static analysis)

## Architecture
- `lib/core`: Theme, Constants, and Base Utils.
- `lib/features`: Highly modular feature-based structure.
  - `domain`: Pure business logic and entity definitions.
  - `data`: Repositories and external service implementations.
  - `presentation`: UI components and Riverpod providers.
