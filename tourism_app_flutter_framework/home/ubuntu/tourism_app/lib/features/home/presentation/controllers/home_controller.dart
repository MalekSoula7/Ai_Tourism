import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/data/repositories/place_repository.dart';

class HomeController extends GetxController {
  final _placeRepo = PlaceRepository();

  final RxString welcomeMessage = 'Welcome Tourist!'.obs;
  final RxInt userCredits = 0.obs;
  final RxString behaviorStatus = 'good_standing'.obs;
  final RxList<PlaceModel> recommendedPlaces = <PlaceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    appLogger.i('Fetching home screen data...');
    try {
      final canAccessHome = await checkUserStatus();
      if (!canAccessHome) return;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('accounts')
            .doc(user.uid)
            .get();
        final data = doc.data();
        if (doc.exists && data != null) {
          final name = data['name'] ?? 'Tourist';
          final credits = (data['credits'] as num?)?.toInt() ?? 0;
          welcomeMessage.value = 'Welcome, $name!';
          userCredits.value = credits;
          behaviorStatus.value = data['behaviorStatus'] ?? 'good_standing';
        } else {
          welcomeMessage.value = 'Welcome Tourist!';
          userCredits.value = 0;
        }
      }
      await _loadRecommendations();
      appLogger.i('Home screen data loaded.');
    } catch (e) {
      appLogger.e('Error fetching home data', error: e);
      welcomeMessage.value = 'Welcome Tourist!';
      userCredits.value = 0;
    }
  }

  Future<void> _loadRecommendations() async {
    try {
      final places = await _placeRepo.getAllPlaces();
      final topPlaces = List<PlaceModel>.from(places)
        ..sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
      recommendedPlaces.assignAll(topPlaces.take(3).toList());
    } catch (e) {
      appLogger.w('Could not load recommendations', error: e);
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
      Get.offAllNamed(Routes.UNDER_VERIFICATION);
      return false;
    } else if (status == 'rejected') {
      Get.offAllNamed(Routes.REJECTED);
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
    await prefs.clear();
    Get.offAllNamed(Routes.LOGIN);
    Get.snackbar('Logged out', 'You have been logged out.');
  }
}
