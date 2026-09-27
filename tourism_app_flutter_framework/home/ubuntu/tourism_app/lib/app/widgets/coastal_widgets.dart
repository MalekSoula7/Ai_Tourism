import 'package:flutter/material.dart';
import 'package:tourism_app/app/themes/app_colors.dart';

/// Full-screen auth layout: beach photo, sea-dusk overlay, brand mark and a
/// whitewashed card holding the form.
class CoastalAuthShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final bool showBack;

  const CoastalAuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.aegeanDark,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover),
          DecoratedBox(decoration: BoxDecoration(gradient: AppColors.photoOverlay)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BrandMark(onDark: true),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.97),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.aegeanDark.withValues(alpha: 0.35),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(title, style: theme.textTheme.headlineSmall),
                            const SizedBox(height: 6),
                            Text(
                              subtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 16),
                            const WaveDivider(),
                            const SizedBox(height: 20),
                            child,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showBack)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// App logo: sun over the sea, with the wordmark.
class BrandMark extends StatelessWidget {
  final bool onDark;
  const BrandMark({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    final fg = onDark ? Colors.white : AppColors.aegean;
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.lemon, AppColors.terracotta],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 2),
          ),
          child: const Icon(Icons.sailing, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          'AI Nomad',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: fg,
                letterSpacing: 1.2,
              ),
        ),
        Text(
          'TRAVEL THE MEDITERRANEAN WAY',
          style: TextStyle(
            color: fg.withValues(alpha: 0.8),
            fontSize: 11,
            letterSpacing: 2.4,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// A short hand-drawn-looking wave used as a decorative divider.
class WaveDivider extends StatelessWidget {
  final Color? color;
  final double width;
  const WaveDivider({super.key, this.color, this.width = 56});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomPaint(
        size: Size(width, 8),
        painter: _WavePainter(color ?? Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  _WavePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(0, size.height / 2);
    const waves = 3;
    final w = size.width / waves;
    for (var i = 0; i < waves; i++) {
      final x = i * w;
      path.quadraticBezierTo(x + w / 4, 0, x + w / 2, size.height / 2);
      path.quadraticBezierTo(x + 3 * w / 4, size.height, x + w, size.height / 2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter old) => old.color != color;
}

/// Clips the bottom edge of a header into a gentle swell.
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final h = size.height;
    final w = size.width;
    return Path()
      ..lineTo(0, h - 28)
      ..quadraticBezierTo(w * 0.25, h, w * 0.5, h - 18)
      ..quadraticBezierTo(w * 0.78, h - 40, w, h - 14)
      ..lineTo(w, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Section title with a small wave underline.
class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const SectionTitle(this.title, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              const WaveDivider(width: 36),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Small rounded label, e.g. "Open", "Paid", a category name.
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color? background;
  final IconData? icon;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.background,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft empty-state with a tinted icon medallion.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const EmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 44, color: scheme.primary),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
