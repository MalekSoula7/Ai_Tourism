import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/passport/presentation/controllers/passport_manage_controller.dart';

class PassportManageScreen extends GetView<PassportManageController> {
  const PassportManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value &&
              controller.passportImageBytes.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final status = controller.accountStatus.value;
          final canUpload =
              status == 'pending_passport' || status == 'rejected';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verification Status: ${_statusLabel(status)}',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Text('Passport Number: ${controller.passportNumber.value}'),
                const SizedBox(height: 8),
                Text('Expiry Date: ${controller.expiryDate.value}'),
                const SizedBox(height: 24),
                if (status == 'under_verification')
                  const Text(
                      'Your passport was uploaded and is waiting for approval.'),
                if (status == 'verified')
                  const Text(
                      'Your passport is verified. You have full app access.'),
                if (canUpload) ...[
                  Text(
                    status == 'rejected'
                        ? 'Your previous passport photo was rejected. Upload a clearer passport photo.'
                        : 'Upload or scan your passport photo to unlock full app access.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  controller.passportImageBytes.value == null
                      ? const SizedBox(
                          height: 160,
                          child: Center(
                              child: Text('No passport photo selected.')),
                        )
                      : Image.memory(controller.passportImageBytes.value!,
                          height: 180),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.pickFromGallery,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Upload'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Scan'),
                        ),
                      ),
                    ],
                  ),
                  if (controller.passportImageBytes.value != null) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: controller.removeImage,
                      child: const Text('Remove selected photo'),
                    ),
                  ],
                  if (controller.uploadProgress.value > 0) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                        value: controller.uploadProgress.value),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.submitForVerification,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Submit for Verification'),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'verified':
        return 'Verified';
      case 'under_verification':
        return 'Under verification';
      case 'rejected':
        return 'Rejected';
      case 'pending_passport':
      default:
        return 'Passport required';
    }
  }
}
