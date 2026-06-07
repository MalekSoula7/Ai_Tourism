import 'package:cloud_firestore/cloud_firestore.dart';

class CreditTransactionModel {
  final String id;
  final String userId;
  final int amount;
  final String type;
  final String reason;
  final String source;
  final DateTime createdAt;
  final String? createdBy;
  final String? relatedReportId;
  final String? relatedReservationId;

  const CreditTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.reason,
    required this.source,
    required this.createdAt,
    this.createdBy,
    this.relatedReportId,
    this.relatedReservationId,
  });

  factory CreditTransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CreditTransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: data['amount'] ?? 0,
      type: data['type'] ?? '',
      reason: data['reason'] ?? '',
      source: data['source'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'],
      relatedReportId: data['relatedReportId'],
      relatedReservationId: data['relatedReservationId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'amount': amount,
        'type': type,
        'reason': reason,
        'source': source,
        'createdAt': Timestamp.fromDate(createdAt),
        if (createdBy != null) 'createdBy': createdBy,
        if (relatedReportId != null) 'relatedReportId': relatedReportId,
        if (relatedReservationId != null)
          'relatedReservationId': relatedReservationId,
      };
}

abstract class CreditTransactionType {
  static const entryBonus = 'entry_bonus';
  static const goodBehaviorReward = 'good_behavior_reward';
  static const placeVisitReward = 'place_visit_reward';
  static const reservationReward = 'reservation_reward';
  static const violationPenalty = 'violation_penalty';
  static const sanctionPenalty = 'sanction_penalty';
  static const redemption = 'redemption';
  static const manualAdjustment = 'manual_adjustment';
}
