import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/reservation_model.dart';

class ReservationRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<ReservationModel> createReservation({
    required String placeId,
    required String placeName,
    required DateTime selectedDateTime,
    required int visitorCount,
    required double price,
  }) async {
    final uid = currentUid!;
    final qrData =
        'RES-${uid.substring(0, 6)}-${placeId.substring(0, 8)}-${DateTime.now().millisecondsSinceEpoch}';

    final ref = _firestore.collection('reservations').doc();
    final reservation = ReservationModel(
      id: ref.id,
      userId: uid,
      placeId: placeId,
      placeName: placeName,
      selectedDateTime: selectedDateTime,
      visitorCount: visitorCount,
      status: price == 0
          ? ReservationStatus.confirmed
          : ReservationStatus.pendingPayment,
      price: price,
      paymentStatus: price == 0 ? 'paid' : 'pending',
      qrCodeData: qrData,
      createdAt: DateTime.now(),
    );
    await ref.set(reservation.toMap());
    return reservation;
  }

  Future<List<ReservationModel>> getUserReservations() async {
    final uid = currentUid;
    if (uid == null) return [];
    try {
      final query = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      return query.docs.map(ReservationModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching reservations', error: e);
      return [];
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    await _firestore.collection('reservations').doc(reservationId).update({
      'status': ReservationStatus.cancelled,
      'cancelledAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> confirmPayment(String reservationId) async {
    await _firestore.collection('reservations').doc(reservationId).update({
      'status': ReservationStatus.confirmed,
      'paymentStatus': 'paid',
    });
  }
}
