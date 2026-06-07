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
              // Placeholder for list of redemption offers
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('10% Discount on Souvenirs'),
                    subtitle: const Text('Cost: 50 Credits'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement redemption logic
                        controller.redeemCredits('souvenir_10');
                      },
                      child: const Text('Redeem'),
                    ),
                  ),
                  ListTile(
                    title: const Text('Free Museum Ticket'),
                    subtitle: const Text('Cost: 100 Credits'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement redemption logic
                        controller.redeemCredits('museum_free');
                      },
                      child: const Text('Redeem'),
                    ),
                  ),
                  // Add more offers here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

