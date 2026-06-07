import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileController extends GetxController {
  // TODO: Implement profile management logic (fetch user data, update details)
  final RxString userName = 'Tourist Name'.obs;
  final RxString userEmail = 'tourist@example.com'.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    print('Fetching user profile...');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userEmail.value = user.email ?? 'tourist@example.com';
        final docRef = FirebaseFirestore.instance.collection('accounts').doc(user.uid);
        final doc = await docRef.get();
        print('Fetched document for user: ${docRef.path} exists=${doc.exists}');
        final data = doc.data();
        final name = data?['name'] ?? 'Tourist';
        if (doc.exists && data != null) {
          userName.value = name ?? 'Tourist Name';}
      }
      print('User profile loaded.');
    } catch (e) {
      print('Error fetching user profile: $e');
      Get.snackbar('Error', 'Failed to fetch profile data.');
    }
  }

  Future<void> updateProfile(String newName, String newEmail) async {
    print('Updating profile with Name: $newName, Email: $newEmail');
    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': newName,
          'email': newEmail,
        });
        // Update Auth email if changed
        if (user.email != newEmail) {
          await user.updateEmail(newEmail);
        }
        userName.value = newName;
        userEmail.value = newEmail;
        Get.snackbar('Success', 'Profile updated successfully!');
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar('Error', 'Failed to update profile.');
    } finally {
      isLoading.value = false;
    }
  }
}


