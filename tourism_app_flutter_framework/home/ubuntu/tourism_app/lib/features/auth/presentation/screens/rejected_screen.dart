import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourism_app/app/routes/app_pages.dart';
import 'package:tourism_app/app/themes/app_colors.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.bougainvilleaLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.document_scanner_outlined,
                    size: 48, color: AppColors.bougainvillea),
              ),
              const SizedBox(height: 24),
              Text('Verification declined',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Your verification appeal was rejected. Please re-upload a clearer passport photo.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => Get.offAllNamed(Routes.PASSPORT_MANAGE),
                icon: const Icon(Icons.upload_outlined),
                label: const Text('Re-upload passport'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
