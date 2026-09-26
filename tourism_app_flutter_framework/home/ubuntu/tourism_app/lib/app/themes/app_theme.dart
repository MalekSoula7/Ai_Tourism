import 'package:flutter/material.dart';
import 'package:tourism_app/app/themes/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double radius = 18;

  static final ThemeData lightTheme = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.aegean,
      onPrimary: Colors.white,
      primaryContainer: AppColors.mist,
      onPrimaryContainer: AppColors.aegeanDark,
      secondary: AppColors.terracotta,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.terracottaLight,
      onSecondaryContainer: Color(0xFF5A2410),
      tertiary: AppColors.seafoam,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFD5EFEC),
      onTertiaryContainer: Color(0xFF0F3F3B),
      error: AppColors.bougainvillea,
      onError: Colors.white,
      errorContainer: AppColors.bougainvilleaLight,
      onErrorContainer: Color(0xFF4F0F22),
      surface: Colors.white,
      onSurface: AppColors.ink,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.whitewash,
      surfaceContainer: AppColors.whitewash,
      surfaceContainerHigh: AppColors.sand,
      surfaceContainerHighest: AppColors.sand,
      onSurfaceVariant: AppColors.driftwood,
      outline: AppColors.stone,
      outlineVariant: Color(0xFFEAE1D1),
      shadow: AppColors.aegeanDark,
    ),
    scaffold: AppColors.whitewash,
  );

  static final ThemeData darkTheme = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7CC4E4),
      onPrimary: AppColors.aegeanDark,
      primaryContainer: AppColors.aegean,
      onPrimaryContainer: AppColors.mist,
      secondary: Color(0xFFE8906A),
      onSecondary: Color(0xFF4A1C0A),
      secondaryContainer: Color(0xFF6E3219),
      onSecondaryContainer: AppColors.terracottaLight,
      tertiary: Color(0xFF7FD0C8),
      onTertiary: Color(0xFF0F3F3B),
      tertiaryContainer: Color(0xFF1F5A55),
      onTertiaryContainer: Color(0xFFD5EFEC),
      error: Color(0xFFEB8FA6),
      onError: Color(0xFF4F0F22),
      errorContainer: Color(0xFF7A2640),
      onErrorContainer: AppColors.bougainvilleaLight,
      surface: AppColors.nightSurface,
      onSurface: Color(0xFFEDE6DA),
      surfaceContainerLowest: AppColors.nightSea,
      surfaceContainerLow: AppColors.nightSea,
      surfaceContainer: AppColors.nightSurface,
      surfaceContainerHigh: Color(0xFF1B3549),
      surfaceContainerHighest: Color(0xFF223F55),
      onSurfaceVariant: Color(0xFFB5AC9F),
      outline: Color(0xFF3C5568),
      outlineVariant: Color(0xFF2A4254),
      shadow: Colors.black,
    ),
    scaffold: AppColors.nightSea,
  );

  static ThemeData _build(ColorScheme scheme, {required Color scaffold}) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    // Serif display type evokes old harbour signage; body stays clean sans.
    final text = base.textTheme
        .copyWith(
          displaySmall: base.textTheme.displaySmall
              ?.copyWith(fontFamily: 'serif', fontWeight: FontWeight.w600),
          headlineLarge: base.textTheme.headlineLarge
              ?.copyWith(fontFamily: 'serif', fontWeight: FontWeight.w600),
          headlineMedium: base.textTheme.headlineMedium
              ?.copyWith(fontFamily: 'serif', fontWeight: FontWeight.w600),
          headlineSmall: base.textTheme.headlineSmall
              ?.copyWith(fontFamily: 'serif', fontWeight: FontWeight.w600),
          titleLarge: base.textTheme.titleLarge?.copyWith(
              fontFamily: 'serif',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2),
          titleMedium:
              base.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          labelLarge: base.textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.4),
        )
        .apply(bodyColor: scheme.onSurface, displayColor: scheme.onSurface);

    final rounded =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));
    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    const buttonPadding = EdgeInsets.symmetric(horizontal: 22, vertical: 14);

    return base.copyWith(
      scaffoldBackgroundColor: scaffold,
      canvasColor: scaffold,
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffold,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
        iconTheme: IconThemeData(color: scheme.primary),
        actionsIconTheme: IconThemeData(color: scheme.primary),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: rounded.copyWith(
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.5)),
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.secondary,
          textStyle: text.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.secondary,
        foregroundColor: scheme.onSecondary,
        shape: buttonShape,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.brightness == Brightness.light
            ? AppColors.whitewash
            : scheme.surfaceContainerHigh,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIconColor: scheme.primary,
        suffixIconColor: scheme.onSurfaceVariant,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(color: scheme.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.error),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        selectedColor: scheme.primary,
        secondarySelectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        labelStyle: text.labelLarge
            ?.copyWith(color: scheme.onSurface, fontWeight: FontWeight.w500),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: scheme.onPrimary),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scheme.surface,
        selectedItemColor: scheme.secondary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: text.titleLarge,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.aegeanDark,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        linearTrackColor: scheme.surfaceContainerHigh,
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.secondary,
        dividerColor: scheme.outlineVariant,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? scheme.onPrimary : null),
        trackColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? scheme.tertiary : null),
      ),
    );
  }
}
