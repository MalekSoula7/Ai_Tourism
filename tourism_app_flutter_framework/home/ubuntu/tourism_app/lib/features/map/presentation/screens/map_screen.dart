// lib/views/map_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = Get.put(MapController());

  @override
  void initState() {
    super.initState();
    // Initialize map if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mapController.onInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: mapController.fetchPlaces,
          ),
        ],
      ),
      body: Obx(() {
        if (mapController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GoogleMap(
              onMapCreated: mapController.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: mapController.initialCameraPosition.value,
                zoom: 14,
              ),
              markers: Set<Marker>.from(mapController.markers),
              // Disable myLocation by default to avoid crashes when location permission isn't granted.
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              onCameraMove: (position) => mapController.updateCameraPosition(position),
              compassEnabled: true,
              zoomControlsEnabled: false,
            ),
            _buildCurrentLocationButton(),
            _buildMapControls(),
          ],
        );
      }),
    );
  }

  Widget _buildCurrentLocationButton() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton(
        heroTag: 'location_fab',
        onPressed: () => mapController.animateToLocation(
          mapController.initialCameraPosition.value,
        ),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 20,
      right: 20,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: () => mapController.mapController?.animateCamera(
              CameraUpdate.zoomIn(),
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: () => mapController.mapController?.animateCamera(
              CameraUpdate.zoomOut(),
            ),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}