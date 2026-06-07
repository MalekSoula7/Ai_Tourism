import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/account_model.dart';

class AccountRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<AccountModel?> getCurrentAccount() async {
    final uid = currentUid;
    if (uid == null) return null;
    try {
      final doc = await _firestore.collection('accounts').doc(uid).get();
      if (!doc.exists) return null;
      return AccountModel.fromFirestore(doc);
    } catch (e) {
      appLogger.e('Error fetching current account', error: e);
      return null;
    }
  }

  Future<AccountModel?> getAccountById(String uid) async {
    try {
      final doc = await _firestore.collection('accounts').doc(uid).get();
      if (!doc.exists) return null;
      return AccountModel.fromFirestore(doc);
    } catch (e) {
      appLogger.e('Error fetching account $uid', error: e);
      return null;
    }
  }

  Future<void> updateAccountStatus(
    String uid,
    String status, {
    String? rejectedReason,
    String? verifiedBy,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (rejectedReason != null) data['passportRejectedReason'] = rejectedReason;
    if (verifiedBy != null) {
      data['verifiedBy'] = verifiedBy;
      data['passportVerifiedAt'] = FieldValue.serverTimestamp();
    }
    await _firestore.collection('accounts').doc(uid).update(data);
    await _logAudit(uid, status, verifiedBy: verifiedBy, reason: rejectedReason);
  }

  Future<void> updatePassportFields(
      String uid, Map<String, dynamic> fields) async {
    await _firestore.collection('accounts').doc(uid).update(fields);
  }

  Future<void> updateBehaviorStatus(String uid, String behaviorStatus) async {
    await _firestore
        .collection('accounts')
        .doc(uid)
        .update({'behaviorStatus': behaviorStatus});
  }

  Future<List<AccountModel>> getPendingVerifications() async {
    try {
      final query = await _firestore
          .collection('accounts')
          .where('status', isEqualTo: 'under_verification')
          .get();
      return query.docs.map(AccountModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching pending verifications', error: e);
      return [];
    }
  }

  Future<void> _logAudit(
    String targetUid,
    String action, {
    String? verifiedBy,
    String? reason,
  }) async {
    try {
      await _firestore.collection('audit_logs').add({
        'targetUid': targetUid,
        'action': action,
        'performedBy': verifiedBy ?? 'system',
        if (reason != null) 'reason': reason,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      appLogger.w('Failed to write audit log', error: e);
    }
  }
}
