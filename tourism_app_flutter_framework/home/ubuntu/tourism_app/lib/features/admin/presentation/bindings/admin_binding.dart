import 'package:get/get.dart';
import 'package:tourism_app/features/admin/presentation/controllers/admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(() => AdminController());
  }
}
