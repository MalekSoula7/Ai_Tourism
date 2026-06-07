import 'package:cloud_firestore/cloud_firestore.dart';

class SanctionModel {
  final String id;
  final String userId;
  final String? reportId;
  final String type;
  final String reason;
  final DateTime startAt;
  final DateTime? endAt;
  final bool active;
  final DateTime createdAt;

  const SanctionModel({
    required this.id,
    required this.userId,
    this.reportId,
    required this.type,
    required this.reason,
    required this.startAt,
    this.endAt,
    required this.active,
    required this.createdAt,
  });

  factory SanctionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SanctionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      reportId: data['reportId'],
      type: data['type'] ?? '',
      reason: data['reason'] ?? '',
      startAt: (data['startAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endAt: (data['endAt'] as Timestamp?)?.toDate(),
      active: data['active'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'userId': userId,
        if (reportId != null) 'reportId': reportId,
        'type': type,
        'reason': reason,
        'startAt': Timestamp.fromDate(startAt),
        if (endAt != null) 'endAt': Timestamp.fromDate(endAt!),
        'active': active,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}

abstract class SanctionType {
  static const warning = 'warning';
  static const pointsPenalty = 'points_penalty';
  static const reservationRestriction = 'reservation_restriction';
  static const transportRestriction = 'transport_restriction';
  static const temporarySuspension = 'temporary_suspension';
  static const authorityReview = 'authority_review';
}
