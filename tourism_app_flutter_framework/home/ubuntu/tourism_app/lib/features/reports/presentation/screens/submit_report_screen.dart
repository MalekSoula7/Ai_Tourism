import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/data/models/behavior_report_model.dart';
import 'package:tourism_app/features/reports/presentation/controllers/report_controller.dart';

class SubmitReportScreen extends GetView<ReportController> {
  const SubmitReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Behavior')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Help us maintain a safe and respectful environment for everyone.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text('Reported User ID',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.reportedUserController,
              decoration: const InputDecoration(
                hintText: 'Enter user ID of the person being reported',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Category',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value.isEmpty
                      ? null
                      : controller.selectedCategory.value,
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  hint: const Text('Select a category'),
                  items: ReportCategory.all
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => controller.selectedCategory.value = val ?? '',
                )),
            const SizedBox(height: 20),
            const Text('Description',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller.descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe what happened in detail...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.submitReport,
                    icon: controller.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.send),
                    label: Text(controller.isSubmitting.value
                        ? 'Submitting...'
                        : 'Submit Report'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.red[700],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
