import 'package:get/get.dart';
import 'package:tourism_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:tourism_app/features/auth/presentation/controllers/signup_controller.dart';
import 'package:tourism_app/features/auth/presentation/controllers/ForgotPasswordController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    // TODO: Add repository dependencies if needed
  }
}

