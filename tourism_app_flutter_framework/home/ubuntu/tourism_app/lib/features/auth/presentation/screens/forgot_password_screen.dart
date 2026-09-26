import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
import 'package:tourism_app/features/auth/presentation/controllers/ForgotPasswordController.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CoastalAuthShell(
      title: 'Forgot password',
      subtitle:
          'Enter the email associated with your account. We will send a password reset link.',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : FilledButton(
                  onPressed: controller.sendResetEmail,
                  child: const Text('Send reset email'),
                )),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Back to sign in'),
          ),
        ],
      ),
    );
  }
}
