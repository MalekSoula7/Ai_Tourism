import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/features/transport/presentation/controllers/transport_controller.dart';

class TicketPurchaseScreen extends GetView<TransportController> {
  const TicketPurchaseScreen({super.key});

  static const _ticketOptions = [
    {'type': 'Single Journey', 'price': 180.0, 'desc': 'One-way trip on any line'},
    {'type': '24-Hour Pass', 'price': 600.0, 'desc': 'Unlimited rides for 24 hours'},
    {'type': '72-Hour Pass', 'price': 1500.0, 'desc': 'Unlimited rides for 72 hours'},
    {'type': 'Weekly Pass', 'price': 3000.0, 'desc': 'Unlimited rides for 7 days'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedStation.value?.name ?? 'Buy Ticket')),
      ),
      body: Obx(() {
        final station = controller.selectedStation.value;
        if (station == null) {
          return const Center(child: Text('No station selected'));
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(station.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(station.type, style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: station.lines
                          .map((l) => Chip(
                                label: Text(l, style: const TextStyle(fontSize: 11)),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Select Ticket Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._ticketOptions.map((opt) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: const Icon(Icons.confirmation_number, color: Colors.indigo),
                    title: Text(opt['type'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(opt['desc'] as String),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('¥${(opt['price'] as double).toInt()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.indigo)),
                        const Text('mock pay',
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    onTap: controller.isPurchasing.value
                        ? null
                        : () => _confirmPurchase(
                            context,
                            opt['type'] as String,
                            opt['price'] as double,
                          ),
                  ),
                )),
            if (controller.isPurchasing.value)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  void _confirmPurchase(BuildContext context, String type, double price) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket: $type'),
            Text('Price: ¥${price.toInt()}'),
            const SizedBox(height: 8),
            const Text('Payment will be processed via mock provider.',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.purchaseTicket(type, price);
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}
