import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/credit_transaction_model.dart';

class CreditRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<int> getBalance(String uid) async {
    final doc = await _firestore.collection('accounts').doc(uid).get();
    return (doc.data()?['credits'] as num?)?.toInt() ?? 0;
  }

  Future<List<CreditTransactionModel>> getTransactions(String uid) async {
    try {
      final query = await _firestore
          .collection('credit_transactions')
          .where('userId', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .get();
      return query.docs.map(CreditTransactionModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching transactions', error: e);
      return [];
    }
  }

  Future<void> addTransaction({
    required String userId,
    required int amount,
    required String type,
    required String reason,
    String source = 'system',
    String? createdBy,
    String? relatedReportId,
    String? relatedReservationId,
  }) async {
    final batch = _firestore.batch();

    final txRef = _firestore.collection('credit_transactions').doc();
    batch.set(txRef, {
      'userId': userId,
      'amount': amount,
      'type': type,
      'reason': reason,
      'source': source,
      'createdAt': FieldValue.serverTimestamp(),
      if (createdBy != null) 'createdBy': createdBy,
      if (relatedReportId != null) 'relatedReportId': relatedReportId,
      if (relatedReservationId != null)
        'relatedReservationId': relatedReservationId,
    });

    final accountRef = _firestore.collection('accounts').doc(userId);
    batch.update(accountRef, {'credits': FieldValue.increment(amount)});

    await batch.commit();
  }
}
