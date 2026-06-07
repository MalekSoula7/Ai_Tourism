import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/transport_station_model.dart';

class TransportRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<List<TransportStationModel>> getStations() async {
    try {
      final query = await _firestore.collection('transport_stations').get();
      if (query.docs.isEmpty) return _getMockStations();
      return query.docs.map(TransportStationModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching stations', error: e);
      return _getMockStations();
    }
  }

  Future<TransportTicketModel> purchaseTicket({
    required String stationId,
    required String stationName,
    required String ticketType,
    String? lineId,
  }) async {
    final uid = currentUid!;
    final now = DateTime.now();
    final validUntil = now.add(const Duration(hours: 24));
    final qrData =
        'TKT-${uid.substring(0, 6)}-${stationId.substring(0, 8)}-${now.millisecondsSinceEpoch}';

    final ref = _firestore.collection('transport_tickets').doc();
    final ticket = TransportTicketModel(
      id: ref.id,
      userId: uid,
      stationId: stationId,
      lineId: lineId,
      ticketType: ticketType,
      validFrom: now,
      validUntil: validUntil,
      status: 'active',
      qrCodeData: qrData,
    );
    await ref.set(ticket.toMap());
    return ticket;
  }

  Future<List<TransportTicketModel>> getUserTickets() async {
    final uid = currentUid;
    if (uid == null) return [];
    try {
      final query = await _firestore
          .collection('transport_tickets')
          .where('userId', isEqualTo: uid)
          .orderBy('validFrom', descending: true)
          .get();
      return query.docs.map(TransportTicketModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching tickets', error: e);
      return [];
    }
  }

  List<TransportStationModel> _getMockStations() => [
        TransportStationModel(
          id: 'station_shibuya',
          name: 'Shibuya Station',
          type: StationType.metro,
          latitude: 35.6580,
          longitude: 139.7016,
          lines: ['Yamanote Line', 'Ginza Line', 'Fukutoshin Line'],
          city: 'Tokyo',
        ),
        TransportStationModel(
          id: 'station_shinjuku',
          name: 'Shinjuku Station',
          type: StationType.train,
          latitude: 35.6896,
          longitude: 139.7006,
          lines: ['Yamanote Line', 'Chuo Line', 'Sobu Line'],
          city: 'Tokyo',
        ),
        TransportStationModel(
          id: 'station_asakusa',
          name: 'Asakusa Station',
          type: StationType.metro,
          latitude: 35.7113,
          longitude: 139.7966,
          lines: ['Ginza Line', 'Asakusa Line'],
          city: 'Tokyo',
        ),
        TransportStationModel(
          id: 'station_ueno',
          name: 'Ueno Station',
          type: StationType.train,
          latitude: 35.7141,
          longitude: 139.7774,
          lines: ['Yamanote Line', 'Ginza Line', 'Keihin-Tohoku Line'],
          city: 'Tokyo',
        ),
      ];
}
