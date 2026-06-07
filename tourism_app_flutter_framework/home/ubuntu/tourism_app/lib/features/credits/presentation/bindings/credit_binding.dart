import 'package:get/get.dart';
import 'package:tourism_app/features/credits/presentation/controllers/credit_controller.dart';

class CreditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreditController>(() => CreditController());
    // TODO: Add repository dependencies (e.g., CreditRepository)
  }
}

