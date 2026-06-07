import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  // TODO: Implement home screen logic (fetch recommendations, credits, etc.)
  final RxString welcomeMessage = 'Welcome Tourist!'.obs;
  final RxInt userCredits = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    print('Fetching home screen data...');
    try {
      final canAccessHome = await checkUserStatus();
      if (!canAccessHome) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef =
            FirebaseFirestore.instance.collection('accounts').doc(user.uid);
        final doc = await docRef.get();
        print('Fetched document for user: ${docRef.path} exists=${doc.exists}');
        final data = doc.data();
        if (doc.exists && data != null) {
          final name = data['name'] ?? 'Tourist';
          final credits = data['credits'] ?? 0;
          print('User name: $name, credits: $credits');
          welcomeMessage.value = 'Welcome $name!';
          userCredits.value = credits;
        } else {
          print(
              'No account document found for user ${user.uid} in accounts collection.');
          welcomeMessage.value = 'Welcome Tourist!';
          userCredits.value = 0;
        }
      } else {
        welcomeMessage.value = 'Welcome Tourist!';
        userCredits.value = 0;
      }
      print('Home screen data loaded.');
    } catch (e) {
      print('Error fetching user data: $e');
      welcomeMessage.value = 'Welcome Tourist!';
      userCredits.value = 0;
    }
  }

  Future<bool> checkUserStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
      return false;
    }

    final doc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(user.uid)
        .get();
    final status = doc.data()?['status'] ?? 'pending_passport';

    if (status == 'under_verification') {
      Get.offAllNamed(Routes
          .UNDER_VERIFICATION); // Create this screen to show a waiting message
      return false;
    } else if (status == 'rejected') {
      Get.offAllNamed(Routes.REJECTED); // Create this screen to show rejection
      return false;
    } else if (status != 'verified') {
      Get.offAllNamed(Routes.PASSPORT_MANAGE);
      return false;
    }

    return true;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or prefs.remove('user_token');
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
