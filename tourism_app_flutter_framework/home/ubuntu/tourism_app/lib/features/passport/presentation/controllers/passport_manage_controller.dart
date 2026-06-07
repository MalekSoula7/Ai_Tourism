import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tourism_app/app/routes/app_pages.dart';

class PassportManageController extends GetxController {
  final RxString passportNumber = 'N/A'.obs;
  final RxString expiryDate = 'N/A'.obs;
  final RxString accountStatus = 'pending_passport'.obs;
  final RxString passportUrl = ''.obs;
  final Rx<File?> passportImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchPassportDetails();
  }

  Future<void> fetchPassportDetails() async {
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .get();
      final data = doc.data();

      accountStatus.value = data?['status'] ?? 'pending_passport';
      passportUrl.value = data?['passportUrl'] ?? '';
      passportNumber.value = data?['passportNumber'] ?? 'Not verified yet';
      expiryDate.value = data?['passportExpiryDate'] ?? 'Not verified yet';
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch passport data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickFromGallery() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      passportImage.value = File(picked.path);
    }
  }

  Future<void> takePhoto() async {
    final picked =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked != null) {
      passportImage.value = File(picked.path);
    }
  }

  void removeImage() {
    passportImage.value = null;
    uploadProgress.value = 0.0;
  }

  Future<void> submitForVerification() async {
    final file = passportImage.value;
    if (file == null) {
      Get.snackbar('Error', 'Please select or scan a passport photo.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    isLoading.value = true;
    uploadProgress.value = 0.0;

    try {
      final ref =
          FirebaseStorage.instance.ref().child('passports/${user.uid}.jpg');
      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        final total = event.totalBytes > 0 ? event.totalBytes : 1;
        uploadProgress.value = event.bytesTransferred / total;
      });

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.uid)
          .set({
        'passportUrl': url,
        'status': 'under_verification',
        'passportUploadedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      accountStatus.value = 'under_verification';
      passportUrl.value = url;
      passportImage.value = null;
      Get.offAllNamed(Routes.UNDER_VERIFICATION);
      Get.snackbar(
          'Success', 'Passport uploaded. Your account is under verification.');
    } catch (e) {
      Get.snackbar('Upload Failed', e.toString());
    } finally {
      isLoading.value = false;
      uploadProgress.value = 0.0;
    }
  }

  void reportNewPassport() {
    passportImage.value = null;
    Get.snackbar('Update', 'Select or scan your new passport photo.');
  }
}
