# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Applying Pressure is a Flutter-based business management application for service businesses. It uses Firebase for backend services (Authentication, Firestore, Storage).

## Commands

### Development
```bash
# Run the app on connected device/emulator
flutter run

# Run with specific device
flutter run -d chrome  # Web browser
flutter run -d iPhone  # iOS simulator
flutter run -d emulator-5554  # Android emulator

# Run web server accessible from other devices (like phones on same network)
python3 flutter_server.py start    # Start server on port 8090
python3 flutter_server.py stop     # Stop server
python3 flutter_server.py restart  # Restart server
python3 flutter_server.py reload   # Hot reload (restart for web-server)
python3 flutter_server.py status   # Check server status
python3 flutter_server.py logs     # View and follow logs
```

#### Testing on Mobile Devices
To test the Flutter web app on your phone:
1. Run `python3 flutter_server.py start`
2. Check status with `python3 flutter_server.py status` 
3. Once ready, note the IP address shown (e.g., http://10.0.0.128:8090)
4. Open this URL on your phone's browser (must be on same Wi-Fi)
5. Make code changes and run `python3 flutter_server.py restart` to see updates

### Building
```bash
# Android
flutter build apk
flutter build appbundle

# iOS (requires macOS with Xcode)
flutter build ios

# Web
flutter build web
```

### Testing & Analysis
```bash
# Run tests
flutter test

# Analyze code for issues
flutter analyze

# Format code
dart format lib/
```

### Common Flutter Commands
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Clean build cache
flutter clean

# Check Flutter setup
flutter doctor
```

## Architecture

### Core Structure
- **State Management**: StatefulWidget pattern throughout the app
- **Navigation**: Bottom navigation with 3 main sections (Jobs, Customers, Expenses)
- **Authentication**: Managed by `WidgetTree` which routes between `LoginPage` and `HomePage` based on auth state

### Data Layer
- **Database**: Firebase Firestore with centralized `DatabaseService` (lib/database_service.dart)
- **Models**: Each feature has model classes with Firestore serialization:
  - `Job` (lib/jobs/job.dart)
  - `Customer` (lib/customers/customer.dart)
  - `Expense` (lib/expenses/expense.dart)

### Key Services
- `DatabaseService`: All Firestore operations (CRUD for jobs, customers, expenses)
- Firebase Auth: User authentication
- Firebase Storage: Image uploads from camera/gallery

### Feature Organization
Each major feature follows this pattern:
```
feature/
├── feature.dart         # Model class
├── feature_page.dart    # List/main view
├── feature_form.dart    # Create/edit form
└── feature_info.dart    # Detail view (if applicable)
```

## Firebase Integration

The app relies heavily on Firebase services:
- **Authentication**: Email/password login
- **Firestore Collections**:
  - `jobs`: Job records with customer references
  - `customers`: Customer information
  - `expenses`: Expense tracking with receipt photos
- **Storage**: Receipt and documentation images

## Important Patterns

### Database Operations
All database operations go through `DatabaseService`:
```dart
// Example: Getting jobs
Stream<List<Job>> getJobs() => databaseService.getJobs();

// Example: Creating a job
await databaseService.createJob(job);
```

### Image Handling
The app uses camera and image_picker packages for receipts:
- Camera functionality in lib/camera/
- Images uploaded to Firebase Storage
- URLs stored in Firestore documents

### Navigation Flow
1. `main.dart` → `WidgetTree`
2. `WidgetTree` checks auth state
3. If authenticated → `HomePage` with bottom navigation
4. If not authenticated → `LoginPage`

## Development Notes

- The app uses minimal external state management (no Provider, Bloc, or Riverpod)
- Test coverage is minimal - most test file content is commented out
- All Firebase configuration is handled through Flutter's standard Firebase setup
- The app supports multiple platforms but is primarily designed for mobile use