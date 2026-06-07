import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/data/models/account_model.dart';
import 'package:tourism_app/data/models/behavior_report_model.dart';
import 'package:tourism_app/features/admin/presentation/controllers/admin_controller.dart';

class AdminDashboardScreen extends GetView<AdminController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.document_scanner), text: 'Passports'),
              Tab(icon: Icon(Icons.report), text: 'Reports'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.loadData,
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              _PassportTab(controller: controller),
              _ReportsTab(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

class _PassportTab extends StatelessWidget {
  final AdminController controller;
  const _PassportTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.pendingAccounts.isEmpty) {
        return const Center(child: Text('No pending passport verifications'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.pendingAccounts.length,
        itemBuilder: (ctx, i) =>
            _PassportCard(account: controller.pendingAccounts[i], controller: controller),
      );
    });
  }
}

class _PassportCard extends StatelessWidget {
  final AccountModel account;
  final AdminController controller;
  const _PassportCard({required this.account, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(account.email, style: TextStyle(color: Colors.grey[600])),
            if (account.passportNumber != null)
              Text('Passport: ${account.passportNumber}'),
            if (account.passportExpiryDate != null)
              Text('Expiry: ${account.passportExpiryDate}'),
            if (account.passportUrl != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () => Get.snackbar('Info', 'Open passport image in browser'),
                  icon: const Icon(Icons.image),
                  label: const Text('View Passport Image'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.approvePassport(account.uid),
                    icon: const Icon(Icons.check),
                    label: const Text('Approve'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showRejectDialog(context, account.uid),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String uid) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reject Passport'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason for rejection'),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.rejectPassport(uid, reasonController.text.trim());
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}

class _ReportsTab extends StatelessWidget {
  final AdminController controller;
  const _ReportsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.pendingReports.isEmpty) {
        return const Center(child: Text('No pending behavior reports'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.pendingReports.length,
        itemBuilder: (ctx, i) =>
            _ReportCard(report: controller.pendingReports[i], controller: controller),
      );
    });
  }
}

class _ReportCard extends StatelessWidget {
  final BehaviorReportModel report;
  final AdminController controller;
  const _ReportCard({required this.report, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(report.category),
              backgroundColor: Colors.orange[100],
            ),
            const SizedBox(height: 4),
            Text(report.description),
            Text('Reported user: ${report.reportedUserId}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApproveDialog(context, report),
                    icon: const Icon(Icons.gavel),
                    label: const Text('Apply Penalty'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.dismissReport(report),
                    icon: const Icon(Icons.check),
                    label: const Text('Dismiss'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, BehaviorReportModel report) {
    int penalty = 25;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Apply Penalty'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Category: ${report.category}'),
              const SizedBox(height: 12),
              Text('Penalty Points: $penalty'),
              Slider(
                value: penalty.toDouble(),
                min: 10,
                max: 200,
                divisions: 19,
                label: '$penalty pts',
                onChanged: (v) => setState(() => penalty = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                controller.approveReport(report, penalty);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
