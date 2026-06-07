import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_app/app/bindings/initial_binding.dart';
import 'package:tourism_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> saveToken(String token) async {
    final localStorage = LocalStorageImpl();
    await localStorage.saveToken(token);
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      String? token = await userCredential.user?.getIdToken();
      if (token != null) {
        await saveToken(token);
      }
      isLoading.value = false;
      await _redirectByAccountStatus(userCredential.user!.uid);
      Get.snackbar('Success', 'Logged in successfully!');
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      String message = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      }
      Get.snackbar('Login Error', message);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }

  Future<void> _redirectByAccountStatus(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('accounts').doc(uid).get();
    final status = doc.data()?['status'] ?? 'pending_passport';

    if (status == 'verified') {
      Get.offAllNamed(Routes.HOME);
    } else if (status == 'under_verification') {
      Get.offAllNamed(Routes.UNDER_VERIFICATION);
    } else if (status == 'rejected') {
      Get.offAllNamed(Routes.REJECTED);
    } else {
      Get.offAllNamed(Routes.PASSPORT_MANAGE);
    }
  }
}

// This controller handles the login logic using Firebase Auth
