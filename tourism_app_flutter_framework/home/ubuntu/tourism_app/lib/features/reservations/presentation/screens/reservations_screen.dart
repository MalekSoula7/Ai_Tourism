import 'package:flutter/material.dart';
import 'package:tourism_app/app/themes/app_colors.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
import 'package:get/get.dart';
import 'package:tourism_app/data/models/reservation_model.dart';
import 'package:tourism_app/features/reservations/presentation/controllers/reservation_controller.dart';

class ReservationsScreen extends GetView<ReservationController> {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadUserReservations,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.userReservations.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyState(
                    icon: Icons.event_outlined, message: 'No reservations yet'),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.userReservations.length,
          itemBuilder: (ctx, i) =>
              _ReservationCard(reservation: controller.userReservations[i]),
        );
      }),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  const _ReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReservationController>();
    final statusColor = _statusColor(reservation.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reservation.placeName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                StatusPill(
                  label: reservation.status.replaceAll('_', ' ').capitalize!,
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _InfoRow(
                icon: Icons.calendar_today,
                text: _formatDt(reservation.selectedDateTime)),
            _InfoRow(
                icon: Icons.people,
                text: '${reservation.visitorCount} visitor(s)'),
            if (reservation.price > 0)
              _InfoRow(
                  icon: Icons.payment,
                  text:
                      '¥${reservation.price.toInt()} – ${reservation.paymentStatus}'),
            const SizedBox(height: 12),
            if (reservation.status == ReservationStatus.confirmed ||
                reservation.status == ReservationStatus.pendingPayment)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _showQrCode(context, reservation.qrCodeData ?? ''),
                      icon: const Icon(Icons.qr_code),
                      label: const Text('View QR'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (reservation.status != ReservationStatus.cancelled)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            controller.cancelReservation(reservation.id),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bougainvillea),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case ReservationStatus.confirmed:
        return AppColors.olive;
      case ReservationStatus.pendingPayment:
        return AppColors.terracotta;
      case ReservationStatus.cancelled:
        return AppColors.bougainvillea;
      case ReservationStatus.used:
        return AppColors.aegean;
      default:
        return AppColors.driftwood;
    }
  }

  String _formatDt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _showQrCode(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your E-Ticket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 120, color: AppColors.ink),
            const SizedBox(height: 8),
            Text(data,
                style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.driftwood),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
