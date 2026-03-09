# UnityPulse

A premium NGO Task Management mobile application built with Flutter, Firebase, and Clean Architecture.

## Features

### Role-Based Experience
- **Coordinators**: Create tasks, assign volunteers, manage global task pool, and monitor progress.
- **Volunteers**: View personalized task lists, track deadlines, and update task status in real-time.

### Task Management
- Real-time status tracking (🟡 **Pending**, 🔵 **In Progress**, 🟢 **Completed**).
- Firebase Authentication with Role-Based Access Control (RBAC).
- Cloud Firestore integration for instant synchronization.
- Detailed task metrics and management dashboards.

### Premium Design
- **Glassmorphism**: Modern UI with subtle blur and transparency effects.
- **NGO Branding**: Dark-themed aesthetic tailored for professional NGO operations.
- **Seamless UX**: High-performance navigation with GoRouter and Riverpod.

## Tech Stack
- **State Management**: Riverpod 3.0 (Code Generation)
- **Backend**: Firebase Auth & Cloud Firestore
- **UI Logic**: Flutter Hooks
- **Navigation**: GoRouter
- **Persistence**: Freezed (Immutable Data Models)

## Getting Started

Execute these commands to build and run:

### Build & Run
```bash
# Run on Android
dart run rps android

# Run on iOS
dart run rps ios
```

### Developer Utilities
- **Code Gen**: `dart run rps build`
- **Lint Check**: `dart run rps lint`
- **Auto Format**: `dart run rps format`

## Clean Architecture
Developed using a layered approach to ensure scalability:
- `domain`: Core business logic and Entity definitions.
- `data`: Infrastructure layer for Firebase interactions.
## Team UnityPulse

- **Navaneeth M** (Contributor)
- **Chaitanya Pawar** (Contributor)
- **Rohit Kumar** (Lead Developer)

---
Developed with ❤️ for NGOs everywhere.
