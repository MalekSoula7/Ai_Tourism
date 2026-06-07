import 'package:cloud_firestore/cloud_firestore.dart';

class BehaviorReportModel {
  final String id;
  final String reportedUserId;
  final String? reporterUserId;
  final String reporterRole;
  final String category;
  final String description;
  final List<String> evidenceUrls;
  final String? placeId;
  final String status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? decision;
  final int penaltyPoints;

  const BehaviorReportModel({
    required this.id,
    required this.reportedUserId,
    this.reporterUserId,
    required this.reporterRole,
    required this.category,
    required this.description,
    this.evidenceUrls = const [],
    this.placeId,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.reviewedBy,
    this.decision,
    this.penaltyPoints = 0,
  });

  factory BehaviorReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BehaviorReportModel(
      id: doc.id,
      reportedUserId: data['reportedUserId'] ?? '',
      reporterUserId: data['reporterUserId'],
      reporterRole: data['reporterRole'] ?? 'tourist',
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      evidenceUrls: List<String>.from(data['evidenceUrls'] ?? []),
      placeId: data['placeId'],
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reviewedAt: (data['reviewedAt'] as Timestamp?)?.toDate(),
      reviewedBy: data['reviewedBy'],
      decision: data['decision'],
      penaltyPoints: data['penaltyPoints'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'reportedUserId': reportedUserId,
        if (reporterUserId != null) 'reporterUserId': reporterUserId,
        'reporterRole': reporterRole,
        'category': category,
        'description': description,
        'evidenceUrls': evidenceUrls,
        if (placeId != null) 'placeId': placeId,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
        if (reviewedAt != null) 'reviewedAt': Timestamp.fromDate(reviewedAt!),
        if (reviewedBy != null) 'reviewedBy': reviewedBy,
        if (decision != null) 'decision': decision,
        'penaltyPoints': penaltyPoints,
      };
}

abstract class ReportCategory {
  static const littering = 'Littering';
  static const trafficViolation = 'Traffic Violation';
  static const vandalism = 'Vandalism';
  static const disrespectfulBehavior = 'Disrespectful Behavior';
  static const openingHoursViolation = 'Opening Hours Violation';
  static const other = 'Other';

  static const all = [
    littering,
    trafficViolation,
    vandalism,
    disrespectfulBehavior,
    openingHoursViolation,
    other,
  ];
}

abstract class ReportStatus {
  static const pending = 'pending';
  static const reviewed = 'reviewed';
  static const dismissed = 'dismissed';
  static const approved = 'approved';
}
