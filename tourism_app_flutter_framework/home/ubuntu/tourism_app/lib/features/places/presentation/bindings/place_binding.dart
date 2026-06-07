import 'package:get/get.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class PlaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceController>(() => PlaceController());
  }
}
