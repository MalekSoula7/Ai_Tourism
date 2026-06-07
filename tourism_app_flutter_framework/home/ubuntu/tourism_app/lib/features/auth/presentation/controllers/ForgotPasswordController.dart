import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController extends GetxController {
	final emailController = TextEditingController();
	final RxBool isLoading = false.obs;

	Future<void> sendResetEmail() async {
		final email = emailController.text.trim();
		if (email.isEmpty) {
			Get.snackbar('Error', 'Please enter your email address.');
			return;
		}

		isLoading.value = true;
		try {
			await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
			Get.snackbar('Success', 'Password reset email sent. Check your inbox.');
			// Optionally navigate back to login
			Future.delayed(const Duration(milliseconds: 500), () => Get.back());
		} on FirebaseAuthException catch (e) {
			String message = 'Failed to send reset email.';
			if (e.code == 'user-not-found') message = 'No user found for that email.';
			Get.snackbar('Error', message);
		} catch (e) {
			Get.snackbar('Error', 'An unexpected error occurred.');
		} finally {
			isLoading.value = false;
		}
	}

	@override
	void onClose() {
		emailController.dispose();
		super.onClose();
	}
}

