import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/core/services/crowd_predictor_service.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class PlaceDetailScreen extends GetView<PlaceController> {
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final place = controller.selectedPlace.value;
      if (place == null) return const Scaffold(body: Center(child: Text('No place selected')));

      return Scaffold(
        appBar: AppBar(title: Text(place.name)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.blue[100],
                child: Center(
                  child: Icon(
                    _categoryIcon(place.category),
                    size: 80,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(place.category),
                          backgroundColor: Colors.blue[50],
                        ),
                        const SizedBox(width: 8),
                        if (place.ticketRequired)
                          Chip(
                            label: Text('¥${place.ticketPrice.toInt()}'),
                            backgroundColor: Colors.orange[50],
                          )
                        else
                          Chip(
                            label: const Text('Free Entry'),
                            backgroundColor: Colors.green[50],
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      place.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(icon: Icons.location_on, text: '${place.address}, ${place.city}'),
                    _InfoRow(icon: Icons.people, text: 'Capacity: ${place.capacity}'),
                    if (place.openingHours.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text('Opening Hours',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      ...place.openingHours.entries.map(
                        (e) => Row(
                          children: [
                            SizedBox(width: 40, child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w500))),
                            Text(e.value, style: TextStyle(color: Colors.grey[700])),
                          ],
                        ),
                      ),
                    ],
                    if (place.rules.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('Rules & Guidelines',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 6),
                      ...place.rules.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber, size: 16, color: Colors.amber),
                              const SizedBox(width: 8),
                              Expanded(child: Text(r)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    _CrowdPredictionCard(controller: controller),
                    const SizedBox(height: 16),
                    if (place.reservationRequired || place.ticketRequired)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.toNamed(Routes.CREATE_RESERVATION),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Make a Reservation'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Temple':
        return Icons.account_balance;
      case 'Museum':
        return Icons.museum;
      case 'Monument':
        return Icons.location_city;
      case 'Park':
        return Icons.park;
      case 'Historical Site':
        return Icons.history_edu;
      default:
        return Icons.place;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: Colors.grey[800]))),
        ],
      ),
    );
  }
}

class _CrowdPredictionCard extends StatelessWidget {
  final PlaceController controller;
  const _CrowdPredictionCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Crowd Prediction',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDateTimePicker(context);
                if (picked != null) controller.updatePredictionTime(picked);
              },
              child: Obx(() => Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        _formatDt(controller.predictionDateTime.value),
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.indigo),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final pred = controller.crowdPrediction.value;
              if (pred == null) return const SizedBox.shrink();
              final color = pred.level == CrowdLevel.high
                  ? Colors.red
                  : pred.level == CrowdLevel.medium
                      ? Colors.orange
                      : Colors.green;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, color: color),
                      const SizedBox(width: 8),
                      Text(
                        '${pred.levelLabel} (${pred.crowdScore}/100)',
                        style: TextStyle(
                            color: color, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: pred.crowdScore / 100,
                    color: color,
                    backgroundColor: color.withOpacity(0.2),
                  ),
                  const SizedBox(height: 8),
                  Text(pred.explanation, style: TextStyle(color: Colors.grey[700])),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String _formatDt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null) return null;
    if (!context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
