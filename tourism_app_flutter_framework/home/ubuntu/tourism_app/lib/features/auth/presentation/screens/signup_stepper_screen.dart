import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/auth/presentation/controllers/signup_stepper_controller.dart';

class SignupStepperScreen extends GetView<SignupStepperController> {
  const SignupStepperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Obx(() => Stepper(
        currentStep: controller.currentStep.value,
        onStepContinue: controller.onStepContinue,
        onStepCancel: controller.onStepCancel,
        steps: [
          Step(
            title: const Text('Account Info'),
            isActive: controller.currentStep.value >= 0,
            content: Column(
              children: [
                TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Passport Upload'),
            isActive: controller.currentStep.value >= 1,
            content: Column(
              children: [
                controller.passportImage.value == null
                  ? const Text('No image selected.')
                  : Image.file(controller.passportImage.value!, height: 150),
                ElevatedButton(
                  onPressed: controller.pickPassportImage,
                  child: const Text('Upload Passport Photo'),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Verification'),
            isActive: controller.currentStep.value >= 2,
            content: Obx(() => controller.isLoading.value
              ? const CircularProgressIndicator()
              : Column(
                  children: [
                    Text(controller.verificationMessage.value),
                  ],
                )),
          ),
        ],
      )),
    );
  }
}