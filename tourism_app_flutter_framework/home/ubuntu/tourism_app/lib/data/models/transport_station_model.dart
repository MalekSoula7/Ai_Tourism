import 'package:cloud_firestore/cloud_firestore.dart';

class TransportStationModel {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final List<String> lines;
  final String city;

  const TransportStationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    this.lines = const [],
    required this.city,
  });

  factory TransportStationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransportStationModel(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      lines: List<String>.from(data['lines'] ?? []),
      city: data['city'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'type': type,
        'latitude': latitude,
        'longitude': longitude,
        'lines': lines,
        'city': city,
      };
}

class TransportTicketModel {
  final String id;
  final String userId;
  final String stationId;
  final String? lineId;
  final String ticketType;
  final DateTime validFrom;
  final DateTime validUntil;
  final String status;
  final String qrCodeData;
  final String? paymentId;

  const TransportTicketModel({
    required this.id,
    required this.userId,
    required this.stationId,
    this.lineId,
    required this.ticketType,
    required this.validFrom,
    required this.validUntil,
    required this.status,
    required this.qrCodeData,
    this.paymentId,
  });

  factory TransportTicketModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransportTicketModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      stationId: data['stationId'] ?? '',
      lineId: data['lineId'],
      ticketType: data['ticketType'] ?? '',
      validFrom: (data['validFrom'] as Timestamp?)?.toDate() ?? DateTime.now(),
      validUntil:
          (data['validUntil'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: data['status'] ?? 'active',
      qrCodeData: data['qrCodeData'] ?? '',
      paymentId: data['paymentId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'stationId': stationId,
        if (lineId != null) 'lineId': lineId,
        'ticketType': ticketType,
        'validFrom': Timestamp.fromDate(validFrom),
        'validUntil': Timestamp.fromDate(validUntil),
        'status': status,
        'qrCodeData': qrCodeData,
        if (paymentId != null) 'paymentId': paymentId,
      };
}

abstract class StationType {
  static const bus = 'Bus';
  static const metro = 'Metro';
  static const train = 'Train';
  static const tram = 'Tram';
  static const ferry = 'Ferry';

  static const all = [bus, metro, train, tram, ferry];
}
