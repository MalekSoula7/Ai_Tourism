import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/credits/presentation/controllers/credit_controller.dart';
import 'package:tourism_app/app/routes/app_pages.dart'; // Import routes

class CreditHistoryScreen extends GetView<CreditController> {
  const CreditHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credit History & Balance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Current Balance: ${controller.currentBalance.value} Credits',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.toNamed(Routes.REDEMPTION),
              child: const Text('Redeem Credits'),
            ),
            const SizedBox(height: 24),
            Text(
              'Transaction History:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.creditHistory.isEmpty) {
                  return const Center(child: Text('No transaction history yet.'));
                }
                return ListView.builder(
                  itemCount: controller.creditHistory.length,
                  itemBuilder: (context, index) {
                    final transaction = controller.creditHistory[index];
                    final amount = transaction['amount'] as int;
                    final color = amount >= 0 ? Colors.green : Colors.red;
                    return ListTile(
                      leading: Icon(amount >= 0 ? Icons.add_circle : Icons.remove_circle, color: color),
                      title: Text(transaction['description'] ?? 'Unknown Transaction'),
                      subtitle: Text(transaction['date'] ?? 'Unknown Date'),
                      trailing: Text(
                        '${amount > 0 ? '+' : ''}$amount',
                        style: TextStyle(color: color, fontWeight: FontWeight.bold),
                      ),
                    );
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

