import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/behavior_report_model.dart';
import 'package:tourism_app/data/repositories/report_repository.dart';

class ReportController extends GetxController {
  final _reportRepo = ReportRepository();

  final RxBool isSubmitting = false.obs;
  final RxString selectedCategory = ''.obs;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController reportedUserController = TextEditingController();

  @override
  void onClose() {
    descriptionController.dispose();
    reportedUserController.dispose();
    super.onClose();
  }

  Future<void> submitReport() async {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Validation', 'Please select a category.');
      return;
    }
    final desc = descriptionController.text.trim();
    if (desc.isEmpty) {
      Get.snackbar('Validation', 'Please describe the incident.');
      return;
    }
    final reportedId = reportedUserController.text.trim();
    if (reportedId.isEmpty) {
      Get.snackbar('Validation', 'Please enter the reported user ID.');
      return;
    }

    isSubmitting(true);
    try {
      await _reportRepo.submitReport(
        reportedUserId: reportedId,
        category: selectedCategory.value,
        description: desc,
      );
      descriptionController.clear();
      reportedUserController.clear();
      selectedCategory.value = '';
      Get.back();
      Get.snackbar(
        'Report Submitted',
        'Thank you. Our team will review this report.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      appLogger.e('Error submitting report', error: e);
      Get.snackbar('Error', 'Could not submit report: $e');
    } finally {
      isSubmitting(false);
    }
  }
}
