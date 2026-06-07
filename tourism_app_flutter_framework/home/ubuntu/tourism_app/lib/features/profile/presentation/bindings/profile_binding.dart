import 'package:get/get.dart';
import 'package:tourism_app/features/profile/presentation/controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    // TODO: Add repository dependencies (e.g., UserRepository)
  }
}

