import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/core/utils/app_logger.dart';

class SignupStepperController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;

  // Bytes instead of File — works on web and mobile
  final Rx<Uint8List?> passportImageBytes = Rx<Uint8List?>(null);

  final RxString verificationMessage =
      'Please wait for verification.'.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void onStepContinue() async {
    if (currentStep.value == 0) {
      await registerUser();
    } else if (currentStep.value == 1) {
      await uploadPassport();
    }
  }

  void onStepCancel() {
    if (currentStep.value > 0) currentStep.value--;
  }

  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar('Validation', 'Please fill in all fields.');
      return;
    }

    isLoading.value = true;
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(credential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'status': 'pending_passport',
        'credits': 0,
        'behaviorStatus': 'good_standing',
        'createdAt': FieldValue.serverTimestamp(),
      });
      currentStep.value++;
    } catch (e) {
      appLogger.e('Registration error', error: e);
      Get.snackbar('Error', 'Failed to register: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPassportImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      passportImageBytes.value = await picked.readAsBytes();
    }
  }

  Future<void> uploadPassport() async {
    final bytes = passportImageBytes.value;
    if (bytes == null) {
      Get.snackbar('Error', 'Please select a passport image.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('passports/${user.uid}.jpg');

      // putData works on both web and mobile
      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .update({
        'passportUrl': url,
        'status': 'under_verification',
        'passportUploadedAt': FieldValue.serverTimestamp(),
      });

      verificationMessage.value =
          'Your account is under verification. Please wait for approval.';
      currentStep.value++;
      Get.offAllNamed(Routes.UNDER_VERIFICATION);
    } catch (e) {
      appLogger.e('Passport upload error', error: e);
      Get.snackbar('Error', 'Failed to upload passport: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
