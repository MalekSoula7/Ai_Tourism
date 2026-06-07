import 'package:get/get.dart';
import 'package:tourism_app/core/utils/app_logger.dart';
import 'package:tourism_app/data/models/account_model.dart';
import 'package:tourism_app/data/models/behavior_report_model.dart';
import 'package:tourism_app/data/repositories/account_repository.dart';
import 'package:tourism_app/data/repositories/credit_repository.dart';
import 'package:tourism_app/data/repositories/report_repository.dart';

class AdminController extends GetxController {
  final _accountRepo = AccountRepository();
  final _creditRepo = CreditRepository();
  final _reportRepo = ReportRepository();

  final RxList<AccountModel> pendingAccounts = <AccountModel>[].obs;
  final RxList<BehaviorReportModel> pendingReports = <BehaviorReportModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading(true);
    try {
      final accounts = await _accountRepo.getPendingVerifications();
      final reports = await _reportRepo.getPendingReports();
      pendingAccounts.assignAll(accounts);
      pendingReports.assignAll(reports);
    } catch (e) {
      appLogger.e('Admin load error', error: e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> approvePassport(String uid) async {
    try {
      await _accountRepo.updateAccountStatus(
        uid,
        AccountStatus.verified,
        verifiedBy: _accountRepo.currentUid ?? 'admin',
      );
      await _creditRepo.addTransaction(
        userId: uid,
        amount: 150,
        type: 'entry_bonus',
        reason: 'Passport verified – welcome bonus',
        source: 'admin',
        createdBy: _accountRepo.currentUid,
      );
      pendingAccounts.removeWhere((a) => a.uid == uid);
      Get.snackbar('Approved', 'Passport verified and entry bonus granted.');
    } catch (e) {
      appLogger.e('Error approving passport', error: e);
      Get.snackbar('Error', 'Could not approve passport: $e');
    }
  }

  Future<void> rejectPassport(String uid, String reason) async {
    try {
      await _accountRepo.updateAccountStatus(
        uid,
        AccountStatus.rejected,
        rejectedReason: reason,
        verifiedBy: _accountRepo.currentUid ?? 'admin',
      );
      pendingAccounts.removeWhere((a) => a.uid == uid);
      Get.snackbar('Rejected', 'Passport has been rejected.');
    } catch (e) {
      appLogger.e('Error rejecting passport', error: e);
      Get.snackbar('Error', 'Could not reject passport: $e');
    }
  }

  Future<void> approveReport(
      BehaviorReportModel report, int penaltyPoints) async {
    try {
      await _reportRepo.reviewReport(report.id, 'approved', penaltyPoints);
      if (penaltyPoints > 0) {
        await _creditRepo.addTransaction(
          userId: report.reportedUserId,
          amount: -penaltyPoints,
          type: 'violation_penalty',
          reason: 'Behavior violation: ${report.category}',
          source: 'admin',
          relatedReportId: report.id,
        );
      }
      pendingReports.removeWhere((r) => r.id == report.id);
      Get.snackbar('Done', 'Report approved and penalty applied.');
    } catch (e) {
      appLogger.e('Error approving report', error: e);
      Get.snackbar('Error', 'Could not process report: $e');
    }
  }

  Future<void> dismissReport(BehaviorReportModel report) async {
    try {
      await _reportRepo.reviewReport(report.id, 'dismissed', 0);
      pendingReports.removeWhere((r) => r.id == report.id);
      Get.snackbar('Done', 'Report dismissed.');
    } catch (e) {
      appLogger.e('Error dismissing report', error: e);
    }
  }
}
