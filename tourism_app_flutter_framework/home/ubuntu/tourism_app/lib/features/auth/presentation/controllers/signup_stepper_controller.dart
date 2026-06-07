import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/app/routes/app_pages.dart';

class SignupStepperController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;
  final Rx<File?> passportImage = Rx<File?>(null);
  final RxString verificationMessage = 'Please wait for verification.'.obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void onStepContinue() async {
    if (currentStep.value == 0) {
      await registerUser();
    } else if (currentStep.value == 1) {
      await uploadPassport();
    } else if (currentStep.value == 2) {
      // Done, maybe navigate or show message
    }
  }

  void onStepCancel() {
    if (currentStep.value > 0) currentStep.value--;
  }

  Future<void> registerUser() async {
    isLoading.value = true;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(userCredential.user!.uid)
          .set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'status': 'pending_passport',
        'credits': 150,
        'createdAt': FieldValue.serverTimestamp(),
      });
      currentStep.value++;
    } catch (e) {
      Get.snackbar('Error', 'Failed to register: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickPassportImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      passportImage.value = File(pickedFile.path);
    }
  }

  Future<void> uploadPassport() async {
    if (passportImage.value == null) {
      Get.snackbar('Error', 'Please select a passport image.');
      return;
    }
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      final ref =
          FirebaseStorage.instance.ref().child('passports/${user!.uid}.jpg');
      await ref.putFile(passportImage.value!);
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
      Get.snackbar('Error', 'Failed to upload passport: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
