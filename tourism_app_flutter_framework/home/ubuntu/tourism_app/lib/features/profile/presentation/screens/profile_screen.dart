import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/profile/presentation/controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize text fields with current controller values
    _nameController.text = controller.userName.value;
    _emailController.text = controller.userEmail.value;

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Your Profile:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: () {
                      controller.updateProfile(
                        _nameController.text,
                        _emailController.text,
                      );
                    },
                    child: const Text('Update Profile'),
                  )),
            // TODO: Add other profile sections (e.g., change password, preferences)
          ],
        ),
      ),
    );
  }
}

