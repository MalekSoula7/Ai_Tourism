import 'package:flutter/material.dart';

/// Coastal Mediterranean palette.
///
/// Inspired by Aegean water, whitewashed walls, sun-baked terracotta,
/// olive groves and Amalfi lemons. Use these tokens instead of raw
/// `Colors.*` values so every screen stays on-palette.
class AppColors {
  AppColors._();

  // Sea
  static const Color aegean = Color(0xFF0E4C6E); // deep Aegean blue (primary)
  static const Color aegeanDark = Color(0xFF0A3550);
  static const Color azure = Color(0xFF2B86B5); // shallow-water azure
  static const Color seafoam = Color(0xFF3FA7A0); // turquoise cove
  static const Color mist = Color(0xFFDDEEF3); // pale sea mist

  // Land
  static const Color terracotta = Color(0xFFC8643B); // roof tiles (accent)
  static const Color terracottaLight = Color(0xFFF6E2D6);
  static const Color lemon = Color(0xFFE8B44A); // Amalfi lemon / sun
  static const Color lemonLight = Color(0xFFFBF0D5);
  static const Color olive = Color(0xFF6E7F45); // olive grove
  static const Color oliveLight = Color(0xFFE6EBD6);
  static const Color bougainvillea = Color(0xFFB23A5B); // errors / alerts
  static const Color bougainvilleaLight = Color(0xFFF6DDE3);

  // Neutrals
  static const Color whitewash = Color(0xFFFBF8F2); // lime-washed walls
  static const Color sand = Color(0xFFF1E8D9); // warm sand
  static const Color stone = Color(0xFFD9CDB8); // limestone
  static const Color driftwood = Color(0xFF8A7F72); // muted secondary text
  static const Color ink = Color(0xFF1C2B36); // deep-night body text

  // Dark theme surfaces
  static const Color nightSea = Color(0xFF0B1C26);
  static const Color nightSurface = Color(0xFF13293A);

  // Semantic
  static const Color success = olive;
  static const Color successLight = oliveLight;
  static const Color warning = lemon;
  static const Color warningLight = lemonLight;
  static const Color danger = bougainvillea;
  static const Color dangerLight = bougainvilleaLight;
  static const Color info = azure;
  static const Color infoLight = mist;

  /// Accent colour per place category, so lists read as a coastal mosaic.
  static Color forCategory(String category) {
    switch (category) {
      case 'Beach':
        return seafoam;
      case 'Park':
        return olive;
      case 'Museum':
      case 'Theater':
        return bougainvillea;
      case 'Temple':
      case 'Castle':
      case 'Monument':
      case 'Historical Site':
        return terracotta;
      case 'Famous Place':
        return const Color(0xFFC08A1E); // deep lemon for legible contrast
      case 'Public Transport':
        return azure;
      default:
        return aegean;
    }
  }

  /// Sea-to-shore gradient used for hero headers.
  static const LinearGradient seaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [aegeanDark, aegean, azure],
  );

  /// Dusk-over-water overlay for photo backgrounds.
  static LinearGradient photoOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      aegeanDark.withValues(alpha: 0.25),
      aegeanDark.withValues(alpha: 0.85),
    ],
  );
}
