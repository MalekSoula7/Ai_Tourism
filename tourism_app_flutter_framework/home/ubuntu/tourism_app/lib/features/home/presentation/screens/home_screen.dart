import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/features/home/presentation/controllers/home_controller.dart';

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
        // stay on Home
        break;
      case 1:
        Get.toNamed(Routes.MAP);
        break;
      case 2:
        Get.toNamed(Routes.PROFILE);
        break;
      case 3:
        // show options for Passport or Credits
        Get.bottomSheet(
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                    title: const Text('Credits'),
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.CREDIT_HISTORY);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourism AI App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Placeholder for logout
            onPressed: () => controller.logout(),
            // Removed the 'child' parameter as IconButton does not support it
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                  controller.welcomeMessage.value,
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
            const SizedBox(height: 16),
            Obx(() => Text(
                  'Your Credits: ${controller.userCredits.value}',
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            const SizedBox(height: 32),
            Text(
              'Recommendations:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: Center(
                child: Text('Recommendation list placeholder'), // Placeholder for recommendations list
              ),
            ),
            // Placeholder for other sections like dangerous places warning
          ],
        ),
      ),
      
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Color.fromRGBO(103, 80, 164,1)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map, color: Color.fromRGBO(103, 80, 164,1)),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Color.fromRGBO(103, 80, 164,1)),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book, color: Color.fromRGBO(103, 80, 164,1)),
              label: 'Passport/Credits',
            ),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).primaryColor,
          showUnselectedLabels: true,
          onTap: _onTap,
        ),
    );
  }
}

