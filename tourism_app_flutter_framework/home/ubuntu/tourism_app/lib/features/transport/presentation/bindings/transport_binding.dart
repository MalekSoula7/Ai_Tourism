import 'package:get/get.dart';
import 'package:tourism_app/features/transport/presentation/controllers/transport_controller.dart';

class TransportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransportController>(() => TransportController());
  }
}
