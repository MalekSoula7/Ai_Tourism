import 'package:get/get.dart';
import 'package:tourism_app/features/home/presentation/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    // TODO: Add repository dependencies if needed
  }
}

