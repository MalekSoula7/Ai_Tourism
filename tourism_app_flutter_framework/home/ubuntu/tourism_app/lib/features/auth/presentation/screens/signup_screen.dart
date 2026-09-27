import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
import 'package:tourism_app/features/auth/presentation/controllers/signup_controller.dart';

class SignupScreen extends GetView<SignupController> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CoastalAuthShell(
      title: 'Create account',
      subtitle: 'Join fellow travellers along the coast.',
      showBack: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 22),
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : FilledButton(
                  onPressed: () {
                    controller.signup(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                    );
                  },
                  child: const Text('Sign up'),
                )),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Already have an account? Sign in'),
          ),
        ],
      ),
    );
  }
}
