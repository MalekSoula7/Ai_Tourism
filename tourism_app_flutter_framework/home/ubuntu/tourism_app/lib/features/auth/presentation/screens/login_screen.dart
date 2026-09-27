import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
import 'package:tourism_app/features/auth/presentation/controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController controller = Get.find<LoginController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CoastalAuthShell(
      title: 'Welcome back',
      subtitle: 'Sign in to pick up where the tide left you.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            obscureText: _obscurePassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : FilledButton(
                  onPressed: () {
                    controller.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Text('Sign in'),
                )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'New here?',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.SIGNUP_STEPPER),
                child: const Text('Create an account'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
