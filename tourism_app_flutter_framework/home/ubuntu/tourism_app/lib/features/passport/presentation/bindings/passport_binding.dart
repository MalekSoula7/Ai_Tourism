import 'package:get/get.dart';
import 'package:tourism_app/features/passport/presentation/controllers/passport_manage_controller.dart';
import 'package:tourism_app/features/passport/presentation/controllers/passport_scan_controller.dart';

class PassportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PassportScanController>(() => PassportScanController());
    Get.lazyPut<PassportManageController>(() => PassportManageController());
    // TODO: Add repository/service dependencies (e.g., PassportRepository, CameraService, OCRService)
  }
}

