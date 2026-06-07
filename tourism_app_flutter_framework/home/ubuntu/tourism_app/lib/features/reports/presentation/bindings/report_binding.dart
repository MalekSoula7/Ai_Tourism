import 'package:get/get.dart';
import 'package:tourism_app/features/reports/presentation/controllers/report_controller.dart';

class ReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportController>(() => ReportController());
  }
}
