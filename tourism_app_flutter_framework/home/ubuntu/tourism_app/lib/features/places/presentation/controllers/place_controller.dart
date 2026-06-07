import 'package:get/get.dart';
import 'package:tourism_app/core/services/crowd_predictor_service.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/data/repositories/place_repository.dart';

class PlaceController extends GetxController {
  final _placeRepo = PlaceRepository();
  final _crowdPredictor = CrowdPredictorService();

  final RxList<PlaceModel> allPlaces = <PlaceModel>[].obs;
  final RxList<PlaceModel> filteredPlaces = <PlaceModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool isLoading = false.obs;
  final Rx<PlaceModel?> selectedPlace = Rx<PlaceModel?>(null);
  final Rx<CrowdPrediction?> crowdPrediction = Rx<CrowdPrediction?>(null);
  final Rx<DateTime> predictionDateTime = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadPlaces();
  }

  Future<void> loadPlaces() async {
    isLoading(true);
    try {
      final places = await _placeRepo.getAllPlaces();
      allPlaces.assignAll(places);
      filteredPlaces.assignAll(places);
      appLogger.i('Loaded ${places.length} places');
    } catch (e) {
      appLogger.e('Error loading places', error: e);
    } finally {
      isLoading(false);
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      filteredPlaces.assignAll(allPlaces);
    } else {
      filteredPlaces.assignAll(
        allPlaces.where((p) => p.category == category).toList(),
      );
    }
  }

  void selectPlace(PlaceModel place) {
    selectedPlace.value = place;
    predictCrowd();
  }

  void updatePredictionTime(DateTime dt) {
    predictionDateTime.value = dt;
    if (selectedPlace.value != null) predictCrowd();
  }

  void predictCrowd() {
    final place = selectedPlace.value;
    if (place == null) return;
    crowdPrediction.value = _crowdPredictor.predict(
      place: place,
      dateTime: predictionDateTime.value,
    );
  }

  bool isOpenNow(PlaceModel place) {
    final now = DateTime.now();
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayKey = weekdays[now.weekday - 1];
    if (place.closingDays.contains(dayKey)) return false;
    final hours = place.openingHours[dayKey];
    if (hours == null || hours.isEmpty) return true;
    final parts = hours.split('-');
    if (parts.length != 2) return true;
    final open = _parseHour(parts[0]);
    final close = _parseHour(parts[1]);
    final current = now.hour * 60 + now.minute;
    return current >= open && current < close;
  }

  int _parseHour(String time) {
    final parts = time.trim().split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    return h * 60 + m;
  }
}
