import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:applying_pressure/shared/edit_form_page.dart';
import 'package:applying_pressure/shared/form_field_config.dart';
import 'package:applying_pressure/jobs/job.dart';
import 'package:applying_pressure/customers/customer.dart';
import 'package:applying_pressure/expenses/expense.dart';
import '../test_helper.dart';

void main() {
  late TestServices services;

  setUpAll(() async {
    await initializeTestEnvironment();
  });

  setUp(() {
    services = TestServices();
  });

  tearDown(() {
    services.dispose();
  });

  group('EditFormPage Basic Tests', () {
    testWidgets('should display Add mode title when no existing model', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          EditFormPage<Job>(
            fieldConfigs: const [
              FormFieldConfig(
                name: 'title',
                label: 'Title',
                hintText: 'Enter title',
                isRequired: true,
              ),
            ],
            modelBuilder: (formData) => Job(
              title: formData['title']?.toString() ?? '',
              address: '',
            ),
            onSave: (_) async {},
          ),
        ),
      );

      expect(find.text('Add Job'), findsOneWidget);
    });

    testWidgets('should display Edit mode title with existing model', 
        (WidgetTester tester) async {
      final existingJob = Job(
        id: '123',
        title: 'Test Job',
        address: '123 Test St',
      );

      await tester.pumpWidget(
        createTestWidget(
          EditFormPage<Job>(
            existingModel: existingJob,
            fieldConfigs: const [
              FormFieldConfig(
                name: 'title',
                label: 'Title',
                hintText: 'Enter title',
                isRequired: true,
              ),
            ],
            modelBuilder: (formData) => Job(
              id: existingJob.id,
              title: formData['title']?.toString() ?? '',
              address: existingJob.address,
            ),
            onSave: (_) async {},
          ),
        ),
      );

      expect(find.text('Edit Job'), findsOneWidget);
    });

    testWidgets('should validate required fields', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          EditFormPage<Expense>(
            fieldConfigs: const [
              FormFieldConfig(
                name: 'name',
                label: 'Name',
                hintText: 'Enter expense name',
                isRequired: true,
              ),
              FormFieldConfig(
                name: 'cost',
                label: 'Cost',
                hintText: 'Enter cost',
                keyboardType: TextInputType.number,
                isRequired: true,
              ),
            ],
            modelBuilder: (formData) => Expense(
              name: formData['name']?.toString() ?? '',
              cost: double.tryParse(formData['cost']?.toString() ?? '') ?? 0,
              description: '',
            ),
            onSave: (_) async {},
          ),
        ),
      );

      // Tap submit without filling fields
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter Name:'), findsOneWidget);
      expect(find.text('Please enter Cost:'), findsOneWidget);
    });

    testWidgets('should call onSave with correct model data', 
        (WidgetTester tester) async {
      Job? savedJob;
      
      await tester.pumpWidget(
        createTestWidget(
          EditFormPage<Job>(
            fieldConfigs: const [
              FormFieldConfig(
                name: 'title',
                label: 'Title',
                hintText: 'Enter title',
                isRequired: true,
              ),
              FormFieldConfig(
                name: 'address',
                label: 'Address',
                hintText: 'Enter address',
                isRequired: true,
              ),
            ],
            modelBuilder: (formData) => Job(
              title: formData['title']?.toString() ?? '',
              address: formData['address']?.toString() ?? '',
            ),
            onSave: (job) async {
              savedJob = job;
            },
          ),
        ),
      );

      // Fill in the form
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter title'),
        'New Job',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter address'),
        '456 Test Ave',
      );

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify the saved data
      expect(savedJob, isNotNull);
      expect(savedJob!.title, 'New Job');
      expect(savedJob!.address, '456 Test Ave');
    });

    testWidgets('should handle custom validators', 
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          EditFormPage<Expense>(
            fieldConfigs: [
              FormFieldConfig(
                name: 'cost',
                label: 'Cost',
                hintText: 'Enter cost',
                keyboardType: TextInputType.number,
                isRequired: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cost is required';
                  }
                  final cost = double.tryParse(value);
                  if (cost == null || cost <= 0) {
                    return 'Cost must be greater than 0';
                  }
                  return null;
                },
              ),
            ],
            modelBuilder: (formData) => Expense(
              name: 'Test',
              cost: double.tryParse(formData['cost']?.toString() ?? '') ?? 0,
              description: '',
            ),
            onSave: (_) async {},
          ),
        ),
      );

      // Enter invalid cost
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter cost'),
        '-10',
      );

      // Try to submit
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Should show custom validation error
      expect(find.text('Cost must be greater than 0'), findsOneWidget);
    });
  });
}