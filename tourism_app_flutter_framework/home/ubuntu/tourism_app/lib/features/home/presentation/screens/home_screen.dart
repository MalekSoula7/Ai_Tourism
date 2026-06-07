import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/data/models/place_model.dart';
import 'package:tourism_app/features/home/presentation/controllers/home_controller.dart';
import 'package:tourism_app/features/places/presentation/controllers/place_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.find<HomeController>();
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Get.toNamed(Routes.MAP);
        break;
      case 2:
        Get.toNamed(Routes.PLACES_LIST);
        break;
      case 3:
        Get.toNamed(Routes.TRANSPORT);
        break;
      case 4:
        _showMoreSheet();
        break;
    }
  }

  void _showMoreSheet() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.document_scanner),
                title: const Text('Passport'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.PASSPORT_MANAGE);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Credit History'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CREDIT_HISTORY);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('My Reservations'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.RESERVATIONS);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Report Behavior'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.SUBMIT_REPORT);
                },
              ),
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admin Dashboard'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ADMIN_DASHBOARD);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Nomad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => controller.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome & credits header
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.welcomeMessage.value,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.userCredits.value} Credits',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 16),
                        _BehaviorBadge(status: controller.behaviorStatus.value),
                      ],
                    ),
                  ],
                )),
            const SizedBox(height: 24),

            // Quick actions
            _SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 10),
            Row(
              children: [
                _QuickAction(
                  icon: Icons.place,
                  label: 'Places',
                  color: Colors.blue,
                  onTap: () => Get.toNamed(Routes.PLACES_LIST),
                ),
                _QuickAction(
                  icon: Icons.train,
                  label: 'Transport',
                  color: Colors.indigo,
                  onTap: () => Get.toNamed(Routes.TRANSPORT),
                ),
                _QuickAction(
                  icon: Icons.calendar_today,
                  label: 'Reservations',
                  color: Colors.teal,
                  onTap: () => Get.toNamed(Routes.RESERVATIONS),
                ),
                _QuickAction(
                  icon: Icons.map,
                  label: 'Map',
                  color: Colors.green,
                  onTap: () => Get.toNamed(Routes.MAP),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Recommendations
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SectionHeader(title: 'Top Recommendations'),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.PLACES_LIST),
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.recommendedPlaces.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Column(
                children: controller.recommendedPlaces
                    .map((p) => _RecommendationCard(place: p))
                    .toList(),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.place), label: 'Places'),
          BottomNavigationBarItem(icon: Icon(Icons.train), label: 'Transport'),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

class _BehaviorBadge extends StatelessWidget {
  final String status;
  const _BehaviorBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (status) {
      case 'warning':
        color = Colors.orange;
        icon = Icons.warning_amber;
        break;
      case 'sanctioned':
        color = Colors.red;
        icon = Icons.block;
        break;
      case 'suspended':
        color = Colors.red[900]!;
        icon = Icons.gavel;
        break;
      default:
        color = Colors.green;
        icon = Icons.verified_user;
    }
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          status.replaceAll('_', ' ').capitalize!,
          style: TextStyle(color: color, fontSize: 13),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final PlaceModel place;
  const _RecommendationCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          if (Get.isRegistered<PlaceController>()) {
            Get.find<PlaceController>().selectPlace(place);
          }
          Get.toNamed(Routes.PLACE_DETAIL);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.place, color: Colors.blue[700], size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      place.category,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      place.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  Text(
                    place.popularityScore.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
