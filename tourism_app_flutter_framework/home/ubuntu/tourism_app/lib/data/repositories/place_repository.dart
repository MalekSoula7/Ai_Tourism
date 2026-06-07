import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/place_model.dart';

class PlaceRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<PlaceModel>> getAllPlaces() async {
    try {
      final query = await _firestore.collection('places').get();
      if (query.docs.isEmpty) return _getMockPlaces();
      return query.docs.map(PlaceModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching places', error: e);
      return _getMockPlaces();
    }
  }

  Future<List<PlaceModel>> getPlacesByCategory(String category) async {
    try {
      final query = await _firestore
          .collection('places')
          .where('category', isEqualTo: category)
          .get();
      return query.docs.map(PlaceModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching places by category', error: e);
      return [];
    }
  }

  Future<PlaceModel?> getPlaceById(String id) async {
    try {
      final doc = await _firestore.collection('places').doc(id).get();
      if (!doc.exists) return null;
      return PlaceModel.fromFirestore(doc);
    } catch (e) {
      appLogger.e('Error fetching place $id', error: e);
      return null;
    }
  }

  Future<void> seedSamplePlaces() async {
    final places = _getMockPlaces();
    final batch = _firestore.batch();
    for (final place in places) {
      final ref = _firestore.collection('places').doc(place.id);
      batch.set(ref, place.toMap());
    }
    await batch.commit();
  }

  List<PlaceModel> _getMockPlaces() => [
        PlaceModel(
          id: 'place_tokyo_tower',
          name: 'Tokyo Tower',
          category: PlaceCategory.monument,
          description:
              'Iconic communications and observation tower in Minato, Tokyo.',
          latitude: 35.6586,
          longitude: 139.7454,
          address: '4 Chome-2-8 Shibakoen, Minato City',
          city: 'Tokyo',
          country: 'Japan',
          openingHours: {
            'Mon': '09:00-23:00',
            'Tue': '09:00-23:00',
            'Wed': '09:00-23:00',
            'Thu': '09:00-23:00',
            'Fri': '09:00-23:00',
            'Sat': '09:00-23:00',
            'Sun': '09:00-23:00',
          },
          capacity: 3000,
          ticketRequired: true,
          ticketPrice: 1200,
          popularityScore: 9.2,
          rules: ['No smoking', 'No drones', 'Respect quiet zones'],
        ),
        PlaceModel(
          id: 'place_senso_ji',
          name: 'Senso-ji Temple',
          category: PlaceCategory.temple,
          description:
              'Ancient Buddhist temple in Asakusa, one of the most visited in the world.',
          latitude: 35.7148,
          longitude: 139.7967,
          address: '2 Chome-3-1 Asakusa, Taito City',
          city: 'Tokyo',
          country: 'Japan',
          openingHours: {
            'Mon': '06:00-17:00',
            'Tue': '06:00-17:00',
            'Wed': '06:00-17:00',
            'Thu': '06:00-17:00',
            'Fri': '06:00-17:00',
            'Sat': '06:00-17:00',
            'Sun': '06:00-17:00',
          },
          capacity: 5000,
          ticketRequired: false,
          ticketPrice: 0,
          popularityScore: 9.5,
          rules: ['Dress modestly', 'No loud music', 'No flash photography'],
        ),
        PlaceModel(
          id: 'place_shibuya_crossing',
          name: 'Shibuya Crossing',
          category: PlaceCategory.famousPlace,
          description:
              'The world-famous scramble crossing, one of the busiest intersections on earth.',
          latitude: 35.6595,
          longitude: 139.7004,
          address: 'Shibuya, Tokyo',
          city: 'Tokyo',
          country: 'Japan',
          capacity: 10000,
          ticketRequired: false,
          ticketPrice: 0,
          popularityScore: 9.8,
          rules: ['Do not block traffic', 'Stay on crosswalk'],
        ),
        PlaceModel(
          id: 'place_meiji_shrine',
          name: 'Meiji Shrine',
          category: PlaceCategory.historicalSite,
          description:
              'Shinto shrine dedicated to Emperor Meiji, surrounded by 120,000 trees.',
          latitude: 35.6763,
          longitude: 139.6993,
          address: '1-1 Yoyogikamizonocho, Shibuya City',
          city: 'Tokyo',
          country: 'Japan',
          openingHours: {
            'Mon': '05:00-18:00',
            'Tue': '05:00-18:00',
            'Wed': '05:00-18:00',
            'Thu': '05:00-18:00',
            'Fri': '05:00-18:00',
            'Sat': '05:00-18:00',
            'Sun': '05:00-18:00',
          },
          capacity: 2000,
          ticketRequired: false,
          ticketPrice: 0,
          popularityScore: 9.0,
          rules: [
            'Bow at the torii gate',
            'Be respectful',
            'No photography in prayer areas',
          ],
        ),
        PlaceModel(
          id: 'place_tokyo_national_museum',
          name: 'Tokyo National Museum',
          category: PlaceCategory.museum,
          description:
              "Japan's largest and oldest museum, housing Japanese art and archaeology.",
          latitude: 35.7188,
          longitude: 139.7764,
          address: '13-9 Uenokoen, Taito City',
          city: 'Tokyo',
          country: 'Japan',
          openingHours: {
            'Tue': '09:30-17:00',
            'Wed': '09:30-17:00',
            'Thu': '09:30-17:00',
            'Fri': '09:30-20:00',
            'Sat': '09:30-17:00',
            'Sun': '09:30-17:00',
          },
          closingDays: ['Mon'],
          capacity: 1500,
          ticketRequired: true,
          ticketPrice: 1000,
          popularityScore: 8.8,
          rules: ['No touching exhibits', 'No food or drink', 'No tripods'],
        ),
      ];
}
