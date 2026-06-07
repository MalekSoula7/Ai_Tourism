import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/data/models/transport_station_model.dart';
import 'package:tourism_app/features/transport/presentation/controllers/transport_controller.dart';

class TransportScreen extends GetView<TransportController> {
  const TransportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Public Transport'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.train), text: 'Stations'),
              Tab(icon: Icon(Icons.confirmation_number), text: 'My Tickets'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StationsTab(controller: controller),
            _TicketsTab(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _StationsTab extends StatelessWidget {
  final TransportController controller;
  const _StationsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.stations.isEmpty) {
        return const Center(child: Text('No stations available'));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.stations.length,
        itemBuilder: (ctx, i) =>
            _StationCard(station: controller.stations[i], controller: controller),
      );
    });
  }
}

class _StationCard extends StatelessWidget {
  final TransportStationModel station;
  final TransportController controller;
  const _StationCard({required this.station, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          controller.selectStation(station);
          Get.toNamed(Routes.TICKET_PURCHASE);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_typeIcon(station.type), color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      station.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Chip(
                    label: Text(station.type),
                    backgroundColor: Colors.blue[50],
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                children: station.lines
                    .map((l) => Chip(
                          label: Text(l, style: const TextStyle(fontSize: 11)),
                          backgroundColor: Colors.grey[200],
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(station.city, style: TextStyle(color: Colors.grey[600])),
                  const Spacer(),
                  const Text('Buy Ticket →',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case StationType.metro:
        return Icons.subway;
      case StationType.train:
        return Icons.train;
      case StationType.bus:
        return Icons.directions_bus;
      case StationType.tram:
        return Icons.tram;
      case StationType.ferry:
        return Icons.directions_boat;
      default:
        return Icons.directions_transit;
    }
  }
}

class _TicketsTab extends StatelessWidget {
  final TransportController controller;
  const _TicketsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.userTickets.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.confirmation_number, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No tickets yet', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.userTickets.length,
        itemBuilder: (ctx, i) => _TicketCard(ticket: controller.userTickets[i]),
      );
    });
  }
}

class _TicketCard extends StatelessWidget {
  final TransportTicketModel ticket;
  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    final isValid = ticket.validUntil.isAfter(DateTime.now());
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
                    ticket.ticketType,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(isValid ? 'Valid' : 'Expired'),
                  backgroundColor: isValid ? Colors.green[100] : Colors.red[100],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Valid until: ${_formatDt(ticket.validUntil)}',
                style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showQrCode(context, ticket.qrCodeData),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_2, size: 40),
                  const SizedBox(width: 8),
                  const Text('Tap to show QR code',
                      style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDt(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  void _showQrCode(BuildContext context, String data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Transport Ticket QR'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_2, size: 120),
            const SizedBox(height: 8),
            Text(data, style: const TextStyle(fontSize: 10, fontFamily: 'monospace')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
