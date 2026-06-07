import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/credits/presentation/controllers/credit_controller.dart';

class RedemptionScreen extends GetView<CreditController> {
  const RedemptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Redeem Credits')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  'Available Balance: ${controller.currentBalance.value} Credits',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            const SizedBox(height: 24),
            Text(
              'Available Offers:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: controller.redemptionOffers.length,
                itemBuilder: (context, index) {
                  final offer = controller.redemptionOffers[index];
                  final id = offer['id'] as String;
                  final title = offer['title'] as String;
                  final description = offer['description'] as String;
                  final cost = offer['cost'] as int;
                  final icon = offer['icon'] as String;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Text(icon, style: const TextStyle(fontSize: 28)),
                      title: Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(description),
                          Text('Cost: $cost Credits',
                              style: const TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: Obx(() => ElevatedButton(
                            onPressed: controller.currentBalance.value >= cost
                                ? () => controller.redeemCredits(id, cost)
                                : null,
                            child: const Text('Redeem'),
                          )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
