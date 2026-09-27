import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/themes/app_colors.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
import 'package:tourism_app/core/services/crowd_predictor_service.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class PlaceDetailScreen extends GetView<PlaceController> {
  const PlaceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final place = controller.selectedPlace.value;
      if (place == null)
        return const Scaffold(body: Center(child: Text('No place selected')));

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.forCategory(place.category),
                        _deepen(AppColors.forCategory(place.category)),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.18),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        _categoryIcon(place.category),
                        size: 56,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place.name,
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        StatusPill(
                          label: place.category,
                          color: AppColors.forCategory(place.category),
                        ),
                        if (place.ticketRequired)
                          StatusPill(
                            icon: Icons.confirmation_number_outlined,
                            label: '¥${place.ticketPrice.toInt()}',
                            color: AppColors.terracotta,
                          )
                        else
                          const StatusPill(
                            icon: Icons.check_circle_outline,
                            label: 'Free Entry',
                            color: AppColors.olive,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      place.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(
                        icon: Icons.location_on,
                        text: '${place.address}, ${place.city}'),
                    _InfoRow(
                        icon: Icons.people,
                        text: 'Capacity: ${place.capacity}'),
                    if (place.openingHours.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const SectionTitle('Opening Hours'),
                      const SizedBox(height: 10),
                      ...place.openingHours.entries.map(
                        (e) => Row(
                          children: [
                            SizedBox(
                                width: 40,
                                child: Text(e.key,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500))),
                            Text(e.value,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                    if (place.rules.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const SectionTitle('Rules & Guidelines'),
                      const SizedBox(height: 10),
                      ...place.rules.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 16, color: AppColors.terracotta),
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
                        child: FilledButton.icon(
                          onPressed: () =>
                              Get.toNamed(Routes.CREATE_RESERVATION),
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Make a Reservation'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.terracotta,
                            padding: const EdgeInsets.symmetric(vertical: 16),
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

  Color _deepen(Color c) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness((hsl.lightness * 0.6).clamp(0.0, 1.0)).toColor();
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
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
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
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.waves, color: scheme.primary),
                const SizedBox(width: 8),
                Text('Crowd Prediction',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
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
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: scheme.primary),
                      ),
                    ],
                  )),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final pred = controller.crowdPrediction.value;
              if (pred == null) return const SizedBox.shrink();
              final color = pred.level == CrowdLevel.high
                  ? AppColors.bougainvillea
                  : pred.level == CrowdLevel.medium
                      ? AppColors.terracotta
                      : AppColors.olive;
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
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: pred.crowdScore / 100,
                      color: color,
                      backgroundColor: color.withValues(alpha: 0.2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(pred.explanation,
                      style: TextStyle(color: scheme.onSurfaceVariant)),
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
