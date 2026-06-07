// lib/controllers/map_controller.dart
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<LatLng> initialCameraPosition = const LatLng(37.7749, -122.4194).obs;
  final Rx<CameraPosition?> currentCameraPosition = Rx<CameraPosition?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  @override
  void onClose() {
    _mapController?.dispose();
    super.onClose();
  }

  
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    updateCameraPosition(CameraPosition(
      target: initialCameraPosition.value,
      zoom: 14,
    ));
  }

  void updateCameraPosition(CameraPosition position) {
    currentCameraPosition.value = position;
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading(true);
      errorMessage('');
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Clear existing markers
      markers.clear();
      
      // Add new markers (replace with your actual data fetching logic)
      markers.addAll([
        Marker(
          markerId: const MarkerId('place_1'),
          position: const LatLng(37.7749, -122.4194),
          infoWindow: const InfoWindow(title: 'Example Place 1'),
        ),
        Marker(
          markerId: const MarkerId('place_2'),
          position: const LatLng(37.7859, -122.4014),
          infoWindow: const InfoWindow(title: 'Example Place 2'),
        ),
      ]);
      
    } catch (e) {
      errorMessage('Failed to load places: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  Future<void> animateToLocation(LatLng location, {double zoom = 14}) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: zoom),
      ),
    );
  }

  Future<void> addMarker(Marker marker) async {
    markers.add(marker);
    await animateToLocation(marker.position);
  }

  Future<void> clearMarkers() async {
    markers.clear();
  }
}