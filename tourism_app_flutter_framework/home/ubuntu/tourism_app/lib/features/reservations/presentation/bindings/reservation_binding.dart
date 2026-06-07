import 'package:get/get.dart';
import 'package:tourism_app/features/reservations/presentation/controllers/reservation_controller.dart';

class ReservationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReservationController>(() => ReservationController());
  }
}
