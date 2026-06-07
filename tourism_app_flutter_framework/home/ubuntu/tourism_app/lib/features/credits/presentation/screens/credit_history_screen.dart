import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/data/models/credit_transaction_model.dart';
import 'package:tourism_app/features/credits/presentation/controllers/credit_controller.dart';

class CreditHistoryScreen extends GetView<CreditController> {
  const CreditHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credit History & Balance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchCreditData,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Current Balance: ${controller.currentBalance.value} Credits',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.REDEMPTION),
              icon: const Icon(Icons.redeem),
              label: const Text('Redeem Credits'),
            ),
            const SizedBox(height: 24),
            Text(
              'Transaction History:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.transactions.isEmpty) {
                  return const Center(child: Text('No transaction history yet.'));
                }
                return ListView.builder(
                  itemCount: controller.transactions.length,
                  itemBuilder: (context, index) {
                    final tx = controller.transactions[index];
                    return _TransactionTile(tx: tx);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final CreditTransactionModel tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isPositive = tx.amount >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final dateStr =
        '${tx.createdAt.year}-${tx.createdAt.month.toString().padLeft(2, '0')}-${tx.createdAt.day.toString().padLeft(2, '0')}';

    return ListTile(
      leading: Icon(
        isPositive ? Icons.add_circle : Icons.remove_circle,
        color: color,
      ),
      title: Text(tx.reason),
      subtitle: Text(dateStr),
      trailing: Text(
        '${tx.amount > 0 ? '+' : ''}${tx.amount}',
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
