import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/behavior_report_model.dart';

class ReportRepository {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get currentUid => _auth.currentUser?.uid;

  Future<BehaviorReportModel> submitReport({
    required String reportedUserId,
    required String category,
    required String description,
    String? placeId,
    List<String> evidenceUrls = const [],
  }) async {
    final uid = currentUid!;
    final ref = _firestore.collection('behavior_reports').doc();
    final report = BehaviorReportModel(
      id: ref.id,
      reportedUserId: reportedUserId,
      reporterUserId: uid,
      reporterRole: 'tourist',
      category: category,
      description: description,
      evidenceUrls: evidenceUrls,
      placeId: placeId,
      status: ReportStatus.pending,
      createdAt: DateTime.now(),
    );
    await ref.set(report.toMap());
    return report;
  }

  Future<List<BehaviorReportModel>> getPendingReports() async {
    try {
      final query = await _firestore
          .collection('behavior_reports')
          .where('status', isEqualTo: ReportStatus.pending)
          .orderBy('createdAt', descending: true)
          .get();
      return query.docs.map(BehaviorReportModel.fromFirestore).toList();
    } catch (e) {
      appLogger.e('Error fetching pending reports', error: e);
      return [];
    }
  }

  Future<void> reviewReport(
      String reportId, String decision, int penaltyPoints) async {
    final uid = currentUid!;
    await _firestore
        .collection('behavior_reports')
        .doc(reportId)
        .update({
      'status': decision == 'approved'
          ? ReportStatus.approved
          : ReportStatus.dismissed,
      'decision': decision,
      'penaltyPoints': penaltyPoints,
      'reviewedBy': uid,
      'reviewedAt': FieldValue.serverTimestamp(),
    });
  }
}
