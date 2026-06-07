import 'package:get/get.dart';
import 'package:tourism_app/features/map/presentation/controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
    // TODO: Add repository/service dependencies (e.g., PlaceRepository, LocationService)
  }
}

