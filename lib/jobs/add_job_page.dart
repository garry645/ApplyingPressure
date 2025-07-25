import 'package:flutter/material.dart';
import '../routes.dart';
import '../services/service_provider.dart';
import '../shared/edit_form_page.dart';
import '../shared/form_field_config.dart';
import '../shared/date_time_picker_field.dart';
import '../customers/customer.dart';
import 'job.dart';
import 'job_info_page.dart';

class AddJobPage extends StatelessWidget {
  const AddJobPage({super.key});

  static const routeName = Routes.addJob;

  @override
  Widget build(BuildContext context) {
    // Get the customer if passed as an argument
    final Customer? customer = ModalRoute.of(context)?.settings.arguments as Customer?;
    final now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    DateTime projectedEndDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);

    return EditFormPage<Job>(
      shouldPopAfterSave: false,
      fieldConfigs: [
        const FormFieldConfig(
          name: 'title',
          label: 'Title',
          hintText: 'Enter Job Title',
          isRequired: true,
        ),
        FormFieldConfig(
          name: 'address',
          label: 'Address',
          hintText: 'Enter Job Address',
          isRequired: true,
          initialValue: customer?.address,
        ),
        FormFieldConfig(
          name: 'startDate',
          label: '',
          hintText: '',
          customWidget: StatefulBuilder(
            builder: (context, setState) {
              return DateTimePickerField(
                label: 'Start Date & Time',
                initialDate: startDate,
                onDateTimeChanged: (newDate) {
                  startDate = newDate;
                  // Access form data updater from context
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FormDataUpdater.of(context)?.updateFormData('startDate', newDate);
                  });
                },
              );
            },
          ),
        ),
        FormFieldConfig(
          name: 'projectedEndDate',
          label: '',
          hintText: '',
          customWidget: StatefulBuilder(
            builder: (context, setState) {
              return DateTimePickerField(
                label: 'Projected End Date & Time',
                initialDate: projectedEndDate,
                onDateTimeChanged: (newDate) {
                  projectedEndDate = newDate;
                  // Access form data updater from context
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FormDataUpdater.of(context)?.updateFormData('projectedEndDate', newDate);
                  });
                },
              );
            },
          ),
        ),
      ],
      modelBuilder: (formData) {
        return Job(
          title: formData['title']?.toString() ?? '',
          address: formData['address']?.toString() ?? '',
          startDate: formData['startDate'] as DateTime? ?? startDate,
          projectedEndDate: formData['projectedEndDate'] as DateTime? ?? projectedEndDate,
          customer: customer,
        );
      },
      onSave: (job) async {
        final service = ServiceProvider.getDatabaseService(context);
        final createdJob = await service.addJob(job);
        
        // Navigate to job details page after creation
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => JobInfoPage(job: createdJob),
            ),
          );
        }
      },
    );
  }
}