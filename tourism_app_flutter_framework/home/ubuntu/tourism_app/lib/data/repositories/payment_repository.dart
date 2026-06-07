import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/payment_model.dart';

class PaymentRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<PaymentModel> createMockPayment({
    required double amount,
    required String currency,
    required String purpose,
    String? relatedReservationId,
    String? relatedTicketId,
  }) async {
    final uid = currentUid!;
    final ref = _firestore.collection('payments').doc();
    final now = DateTime.now();
    final payment = PaymentModel(
      id: ref.id,
      userId: uid,
      amount: amount,
      currency: currency,
      provider: 'mock',
      providerPaymentId: 'MOCK-${now.millisecondsSinceEpoch}',
      status: PaymentStatus.paid,
      purpose: purpose,
      relatedReservationId: relatedReservationId,
      relatedTicketId: relatedTicketId,
      createdAt: now,
      paidAt: now,
    );
    await ref.set(payment.toMap());
    return payment;
  }

  Future<List<PaymentModel>> getUserPayments() async {
    final uid = currentUid;
    if (uid == null) return [];
    try {
      final query = await _firestore
          .collection('payments')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();
      return query.docs.map(PaymentModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching payments', error: e);
      return [];
    }
  }
}
