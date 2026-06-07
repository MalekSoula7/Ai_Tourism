import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;
  final Map<String, String> openingHours;
  final List<String> closingDays;
  final List<String> images;
  final int capacity;
  final bool ticketRequired;
  final double ticketPrice;
  final bool reservationRequired;
  final List<String> rules;
  final double popularityScore;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    this.openingHours = const {},
    this.closingDays = const [],
    this.images = const [],
    this.capacity = 100,
    this.ticketRequired = false,
    this.ticketPrice = 0.0,
    this.reservationRequired = false,
    this.rules = const [],
    this.popularityScore = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  factory PlaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PlaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      address: data['address'] ?? '',
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      openingHours: Map<String, String>.from(data['openingHours'] ?? {}),
      closingDays: List<String>.from(data['closingDays'] ?? []),
      images: List<String>.from(data['images'] ?? []),
      capacity: data['capacity'] ?? 100,
      ticketRequired: data['ticketRequired'] ?? false,
      ticketPrice: (data['ticketPrice'] as num?)?.toDouble() ?? 0.0,
      reservationRequired: data['reservationRequired'] ?? false,
      rules: List<String>.from(data['rules'] ?? []),
      popularityScore: (data['popularityScore'] as num?)?.toDouble() ?? 0.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'category': category,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'city': city,
        'country': country,
        'openingHours': openingHours,
        'closingDays': closingDays,
        'images': images,
        'capacity': capacity,
        'ticketRequired': ticketRequired,
        'ticketPrice': ticketPrice,
        'reservationRequired': reservationRequired,
        'rules': rules,
        'popularityScore': popularityScore,
        'createdAt': createdAt != null
            ? Timestamp.fromDate(createdAt!)
            : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}

abstract class PlaceCategory {
  static const monument = 'Monument';
  static const museum = 'Museum';
  static const theater = 'Theater';
  static const temple = 'Temple';
  static const castle = 'Castle';
  static const park = 'Park';
  static const beach = 'Beach';
  static const historicalSite = 'Historical Site';
  static const famousPlace = 'Famous Place';
  static const publicTransport = 'Public Transport';

  static const all = [
    monument, museum, theater, temple, castle,
    park, beach, historicalSite, famousPlace, publicTransport,
  ];
}
