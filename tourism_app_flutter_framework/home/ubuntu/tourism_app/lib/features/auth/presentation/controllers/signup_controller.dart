import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_app/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> signup(String email, String password, String name) async {
    isLoading.value = true;
    try {
      // Create user with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      // Save additional user info to Firestore
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(userCredential.user?.uid)
          .set({
        'name': name,
        'email': email,
        'status': 'pending_passport',
        'createdAt': FieldValue.serverTimestamp(),
        'credits': 150, // Initialize credits to 150
      });

      isLoading.value = false;
      Get.offAllNamed(Routes.PASSPORT_MANAGE);
      Get.snackbar(
          'Success', 'Account created. Upload your passport to continue.');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = 'Signup failed. Please try again.';
      if (e.code == 'email-already-in-use') {
        message = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak.';
      }
      Get.snackbar('Signup Error', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred.');
      print('Signup error: $e');
    }
  }
}
