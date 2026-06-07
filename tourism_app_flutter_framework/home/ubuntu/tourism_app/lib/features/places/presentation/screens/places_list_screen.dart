import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class PlacesListScreen extends GetView<PlaceController> {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Places'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadPlaces,
          ),
        ],
      ),
      body: Column(
        children: [
          _CategoryFilter(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.filteredPlaces.isEmpty) {
                return const Center(child: Text('No places found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.filteredPlaces.length,
                itemBuilder: (ctx, i) =>
                    _PlaceCard(place: controller.filteredPlaces[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final PlaceController controller;
  const _CategoryFilter({required this.controller});

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...PlaceCategory.all];
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          return Obx(() => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: controller.selectedCategory.value == cat,
                  onSelected: (_) => controller.filterByCategory(cat),
                ),
              ));
        },
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final PlaceModel place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlaceController>();
    final isOpen = controller.isOpenNow(place);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          controller.selectPlace(place);
          Get.toNamed(Routes.PLACE_DETAIL);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOpen ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isOpen ? 'Open' : 'Closed',
                      style: TextStyle(
                        color: isOpen ? Colors.green[800] : Colors.red[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Chip(
                label: Text(place.category),
                backgroundColor: Colors.blue[50],
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(height: 4),
              Text(
                place.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(place.city, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                  const Spacer(),
                  if (place.ticketRequired)
                    Row(
                      children: [
                        Icon(Icons.confirmation_number, size: 14, color: Colors.orange[700]),
                        const SizedBox(width: 4),
                        Text(
                          '¥${place.ticketPrice.toInt()}',
                          style: TextStyle(color: Colors.orange[700], fontSize: 13),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Icon(Icons.check_circle, size: 14, color: Colors.green[600]),
                        const SizedBox(width: 4),
                        Text('Free', style: TextStyle(color: Colors.green[600], fontSize: 13)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
