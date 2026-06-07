import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';
import 'package:tourism_app/features/reservations/presentation/controllers/reservation_controller.dart';

class CreateReservationScreen extends StatelessWidget {
  const CreateReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reservationCtrl = Get.find<ReservationController>();
    final placeCtrl = Get.find<PlaceController>();

    final place = placeCtrl.selectedPlace.value;
    if (place != null) reservationCtrl.setPlace(place);

    return Scaffold(
      appBar: AppBar(title: const Text('Make a Reservation')),
      body: Obx(() {
        final selectedPlace = reservationCtrl.selectedPlace.value;
        if (selectedPlace == null) {
          return const Center(child: Text('No place selected'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.blue[50],
                child: ListTile(
                  leading: const Icon(Icons.place, color: Colors.blue),
                  title: Text(selectedPlace.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(selectedPlace.city),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Date & Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  final dt = await _pickDateTime(context);
                  if (dt != null) reservationCtrl.selectedDateTime.value = dt;
                },
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Obx(() => Text(
                            _formatDt(reservationCtrl.selectedDateTime.value),
                            style: const TextStyle(fontSize: 15),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Number of Visitors',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: reservationCtrl.decrementVisitors,
                    icon: const Icon(Icons.remove_circle_outline),
                    iconSize: 32,
                  ),
                  Obx(() => Text(
                        '${reservationCtrl.visitorCount.value}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      )),
                  IconButton(
                    onPressed: reservationCtrl.incrementVisitors,
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (selectedPlace.ticketRequired) ...[
                const Divider(),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          '¥${reservationCtrl.totalPrice.toInt()}',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo),
                        ),
                      ],
                    )),
                const SizedBox(height: 4),
                Text(
                  'Mock payment will be processed automatically',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 16),
              ],
              const SizedBox(height: 8),
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: reservationCtrl.isCreating.value
                          ? null
                          : () async {
                              await reservationCtrl.createReservation();
                              if (reservationCtrl.lastCreatedReservation.value != null) {
                                Get.offNamed(Routes.RESERVATIONS);
                              }
                            },
                      icon: reservationCtrl.isCreating.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.check_circle),
                      label: Text(reservationCtrl.isCreating.value
                          ? 'Confirming...'
                          : 'Confirm Reservation'),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  )),
            ],
          ),
        );
      }),
    );
  }

  String _formatDt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<DateTime?> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
