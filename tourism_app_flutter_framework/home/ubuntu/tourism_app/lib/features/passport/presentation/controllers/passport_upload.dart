import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PassportUploadController extends GetxController {
	final Rx<File?> passportImage = Rx<File?>(null);
	final RxBool isLoading = false.obs;
	final RxDouble uploadProgress = 0.0.obs;

	final ImagePicker _picker = ImagePicker();

	Future<void> pickFromGallery() async {
		final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
		if (picked != null) {
			passportImage.value = File(picked.path);
		}
	}

	Future<void> takePhoto() async {
		final picked = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
		if (picked != null) {
			passportImage.value = File(picked.path);
		}
	}

	void removeImage() {
		passportImage.value = null;
	}

	Future<void> submitForVerification() async {
		final file = passportImage.value;
		if (file == null) {
			Get.snackbar('Error', 'Please select a passport image.');
			return;
		}

		final user = FirebaseAuth.instance.currentUser;
		if (user == null) {
			Get.snackbar('Error', 'No authenticated user. Please sign in.');
			return;
		}

		isLoading.value = true;
		uploadProgress.value = 0.0;

		try {
			final ref = FirebaseStorage.instance.ref().child('passports/${user.uid}.jpg');
			final uploadTask = ref.putFile(file);

			uploadTask.snapshotEvents.listen((event) {
				final total = event.totalBytes > 0 ? event.totalBytes : 1;
				uploadProgress.value = event.bytesTransferred / total;
			});

			final snapshot = await uploadTask;
			final url = await snapshot.ref.getDownloadURL();

			// Update user's account document to point to passport and set verification status
			await FirebaseFirestore.instance.collection('accounts').doc(user.uid).set({
				'passportUrl': url,
				'status': 'under_verification',
				'passportUploadedAt': FieldValue.serverTimestamp(),
			}, SetOptions(merge: true));

			Get.snackbar('Success', 'Passport uploaded. Your account is under verification.');
		} catch (e) {
			Get.snackbar('Upload Failed', e.toString());
		} finally {
			isLoading.value = false;
			uploadProgress.value = 0.0;
		}
	}
}

