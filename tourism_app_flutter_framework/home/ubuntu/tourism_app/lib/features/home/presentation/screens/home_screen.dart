import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/themes/app_colors.dart';
import 'package:tourism_app/app/widgets/coastal_widgets.dart';
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
    final items = <(IconData, String, String, Color)>[
      (
        Icons.document_scanner_outlined,
        'Passport',
        Routes.PASSPORT_MANAGE,
        AppColors.aegean
      ),
      (Icons.history, 'Credit History', Routes.CREDIT_HISTORY, AppColors.lemon),
      (
        Icons.event_outlined,
        'My Reservations',
        Routes.RESERVATIONS,
        AppColors.seafoam
      ),
      (
        Icons.flag_outlined,
        'Report Behavior',
        Routes.SUBMIT_REPORT,
        AppColors.bougainvillea
      ),
      (
        Icons.admin_panel_settings_outlined,
        'Admin Dashboard',
        Routes.ADMIN_DASHBOARD,
        AppColors.olive
      ),
    ];
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: SectionTitle('More'),
              ),
              for (final (icon, label, route, color) in items)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  title: Text(label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.back();
                    Get.toNamed(route);
                  },
                ),
            ],
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HeroHeader(controller: controller)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SectionTitle('Explore'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _QuickAction(
                      icon: Icons.place_outlined,
                      label: 'Places',
                      color: AppColors.terracotta,
                      onTap: () => Get.toNamed(Routes.PLACES_LIST),
                    ),
                    _QuickAction(
                      icon: Icons.directions_boat_outlined,
                      label: 'Transport',
                      color: AppColors.azure,
                      onTap: () => Get.toNamed(Routes.TRANSPORT),
                    ),
                    _QuickAction(
                      icon: Icons.event_outlined,
                      label: 'Bookings',
                      color: AppColors.seafoam,
                      onTap: () => Get.toNamed(Routes.RESERVATIONS),
                    ),
                    _QuickAction(
                      icon: Icons.map_outlined,
                      label: 'Map',
                      color: AppColors.olive,
                      onTap: () => Get.toNamed(Routes.MAP),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SectionTitle(
                  'Top recommendations',
                  trailing: TextButton(
                    onPressed: () => Get.toNamed(Routes.PLACES_LIST),
                    child: const Text('See all'),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.recommendedPlaces.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
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
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Fair winds & calm seas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                activeIcon: Icon(Icons.map),
                label: 'Map'),
            BottomNavigationBarItem(
                icon: Icon(Icons.place_outlined),
                activeIcon: Icon(Icons.place),
                label: 'Places'),
            BottomNavigationBarItem(
                icon: Icon(Icons.directions_boat_outlined),
                activeIcon: Icon(Icons.directions_boat),
                label: 'Transport'),
            BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz), label: 'More'),
          ],
        ),
      ),
    );
  }
}

/// Photo header with a sea gradient and a wave-shaped bottom edge.
class _HeroHeader extends StatelessWidget {
  final HomeController controller;
  const _HeroHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipPath(
      clipper: WaveClipper(),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/elafonissi-beach-crete-greece-WRLDBEACH0421-50fd96fe8e5e45448d154ae43b38b855.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.aegeanDark.withValues(alpha: 0.55),
                    AppColors.aegean.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 56),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.sailing,
                          color: AppColors.lemon, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'AI Nomad',
                        style: theme.textTheme.titleLarge
                            ?.copyWith(color: Colors.white, letterSpacing: 1),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.person_outline,
                            color: Colors.white),
                        onPressed: () => Get.toNamed(Routes.PROFILE),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () => controller.logout(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Text(
                        controller.welcomeMessage.value,
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      )),
                  const SizedBox(height: 4),
                  Text(
                    'Where will the coast take you today?',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: 18),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          _GlassChip(
                            icon: Icons.wb_sunny_rounded,
                            iconColor: AppColors.lemon,
                            label: '${controller.userCredits.value} Credits',
                          ),
                          _BehaviorBadge(
                              status: controller.behaviorStatus.value),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  const _GlassChip({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
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
        color = AppColors.lemon;
        icon = Icons.warning_amber;
        break;
      case 'sanctioned':
        color = AppColors.terracottaLight;
        icon = Icons.block;
        break;
      case 'suspended':
        color = AppColors.bougainvilleaLight;
        icon = Icons.gavel;
        break;
      default:
        color = const Color(0xFFBFE3C0);
        icon = Icons.verified_user_outlined;
    }
    return _GlassChip(
      icon: icon,
      iconColor: color,
      label: status.replaceAll('_', ' ').capitalize!,
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
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: color.withValues(alpha: 0.25)),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
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
    final theme = Theme.of(context);
    final accent = AppColors.forCategory(place.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            if (Get.isRegistered<PlaceController>()) {
              Get.find<PlaceController>().selectPlace(place);
            }
            Get.toNamed(Routes.PLACE_DETAIL);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withValues(alpha: 0.9),
                        accent.withValues(alpha: 0.6)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.place, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(place.name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 4),
                      StatusPill(label: place.category, color: accent),
                      const SizedBox(height: 6),
                      Text(
                        place.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: AppColors.lemon, size: 20),
                    Text(
                      place.popularityScore.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
