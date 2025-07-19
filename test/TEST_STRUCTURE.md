# Test Suite Organization

## Directory Structure

### `/auth/`
Authentication and authorization tests:
- `auth_flow_test.dart` - Comprehensive auth flow tests including login, logout, forgot password, and WidgetTree auth state management
- Individual page tests that were previously scattered

### `/integration/`
Integration tests for complex workflows:
- `job_fixes_test.dart` - Job model serialization tests
- `performance_test.dart` - Performance and memory tests

### `/mocks/`
Mock implementations for testing:
- `mock_auth_service.dart` - Mock authentication service
- `mock_database_service.dart` - Mock database service
- `mock_storage_service.dart` - Mock storage service
- `firebase_mocks.dart` - Firebase-specific mocks
- `test_services.dart` - Test service utilities

### `/models/`
Data model unit tests:
- `job_test.dart` - Job model tests

### `/pages/`
Individual page widget tests:
- `settings_page_test.dart` - Settings page UI tests

### `/unit/`
Pure unit tests for business logic:
- `date_display_test.dart` - Date display logic
- `date_formatting_test.dart` - Date formatting utilities
- `regression_test.dart` - Regression tests
- `singleton_logic_test.dart` - Singleton pattern tests
- `singleton_test.dart` - Service singleton tests

### `/widgets/`
Widget and navigation tests:
- `add_job_page_test.dart` - Add job page tests
- `home_page_optimization_test.dart` - Home page performance tests
- `jobs_list_page_test.dart` - Jobs list tests
- `navigation_test.dart` - Navigation flow tests

## Test Guidelines

1. **Group Related Tests**: Use `group()` to organize related tests within files
2. **Shared Setup**: Use `setUp()` and `tearDown()` for common test configuration
3. **Mock Services**: Always use mock services from `/mocks/` for consistency
4. **Widget Tests**: Create a reusable `createTestApp()` or `createTestWidget()` helper
5. **Async Operations**: Use `pumpAndSettle()` for async operations, `pump()` for specific timing

## Running Tests

```bash
# Run all tests
flutter test

# Run specific directory
flutter test test/auth/
flutter test test/widgets/

# Run specific file
flutter test test/auth/auth_flow_test.dart

# Run with coverage
flutter test --coverage
```