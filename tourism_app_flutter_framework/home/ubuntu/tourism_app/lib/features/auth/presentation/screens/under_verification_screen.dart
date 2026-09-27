import 'package:flutter/material.dart';
import 'package:tourism_app/app/themes/app_colors.dart';

class UnderVerificationScreen extends StatelessWidget {
  const UnderVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.lemonLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    size: 48, color: AppColors.terracotta),
              ),
              const SizedBox(height: 24),
              Text('Almost there', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                'Your account is under verification. Please wait for approval.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
