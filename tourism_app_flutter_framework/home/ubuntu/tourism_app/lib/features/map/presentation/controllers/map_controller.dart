import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/core/services/crowd_predictor_service.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/data/models/transport_station_model.dart';
import 'package:tourism_app/data/repositories/place_repository.dart';
import 'package:tourism_app/data/repositories/transport_repository.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class MapController extends GetxController {
  final _placeRepo = PlaceRepository();
  final _transportRepo = TransportRepository();
  final _crowdPredictor = CrowdPredictorService();

  final RxSet<Marker> markers = <Marker>{}.obs;
  final Rx<LatLng> initialCameraPosition = const LatLng(35.6762, 139.6503).obs;
  final Rx<CameraPosition?> currentCameraPosition = Rx<CameraPosition?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showTransport = false.obs;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  List<PlaceModel> _places = [];
  List<TransportStationModel> _stations = [];

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
      zoom: 12,
    ));
  }

  void updateCameraPosition(CameraPosition position) {
    currentCameraPosition.value = position;
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading(true);
      errorMessage('');

      _places = await _placeRepo.getAllPlaces();
      _stations = await _transportRepo.getStations();

      _buildMarkers();
      appLogger.i('Map loaded ${_places.length} places, ${_stations.length} stations');
    } catch (e) {
      errorMessage('Failed to load places: $e');
      appLogger.e('Map fetch error', error: e);
    } finally {
      isLoading(false);
    }
  }

  void _buildMarkers() {
    markers.clear();
    final now = DateTime.now();

    for (final place in _places) {
      final prediction = _crowdPredictor.predict(place: place, dateTime: now);
      final crowdColor = prediction.level == CrowdLevel.high
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
          : prediction.level == CrowdLevel.medium
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);

      markers.add(Marker(
        markerId: MarkerId(place.id),
        position: LatLng(place.latitude, place.longitude),
        icon: crowdColor,
        infoWindow: InfoWindow(
          title: place.name,
          snippet: '${place.category} • Crowd: ${prediction.levelLabel}',
          onTap: () {
            final placeController = Get.find<PlaceController>();
            placeController.selectPlace(place);
            Get.toNamed(Routes.PLACE_DETAIL);
          },
        ),
      ));
    }

    if (showTransport.value) {
      for (final station in _stations) {
        markers.add(Marker(
          markerId: MarkerId('station_${station.id}'),
          position: LatLng(station.latitude, station.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
            title: station.name,
            snippet: '${station.type} • ${station.lines.join(", ")}',
          ),
        ));
      }
    }
  }

  void toggleTransportLayer() {
    showTransport.value = !showTransport.value;
    _buildMarkers();
  }

  Future<void> animateToLocation(LatLng location, {double zoom = 14}) async {
    await _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: zoom),
      ),
    );
  }

  Future<void> clearMarkers() async {
    markers.clear();
  }
}
