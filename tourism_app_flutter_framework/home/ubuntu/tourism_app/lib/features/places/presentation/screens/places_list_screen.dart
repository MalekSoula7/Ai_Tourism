import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/themes/app_colors.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
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
                return const EmptyState(
                    icon: Icons.travel_explore, message: 'No places found');
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    final theme = Theme.of(context);
    final accent = AppColors.forCategory(place.category);
    final muted = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            controller.selectPlace(place);
            Get.toNamed(Routes.PLACE_DETAIL);
          },
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 5, color: accent),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(place.name,
                                  style: theme.textTheme.titleMedium),
                            ),
                            StatusPill(
                              label: isOpen ? 'Open' : 'Closed',
                              color: isOpen
                                  ? AppColors.olive
                                  : AppColors.bougainvillea,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        StatusPill(label: place.category, color: accent),
                        const SizedBox(height: 8),
                        Text(
                          place.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: muted),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 15, color: muted),
                            const SizedBox(width: 4),
                            Text(place.city,
                                style: TextStyle(color: muted, fontSize: 13)),
                            const Spacer(),
                            if (place.ticketRequired)
                              StatusPill(
                                icon: Icons.confirmation_number_outlined,
                                label: '¥${place.ticketPrice.toInt()}',
                                color: AppColors.terracotta,
                              )
                            else
                              const StatusPill(
                                icon: Icons.check_circle_outline,
                                label: 'Free',
                                color: AppColors.olive,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
