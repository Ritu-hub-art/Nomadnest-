import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the travel and hospitality application.
/// Implements Contemporary Spatial Minimalism with NomadNest brand colors.
class AppTheme {
  AppTheme._();

  // NomadNest Brand Color Palette
  static const Color primaryLight = Color(0xFF1B365D); // Navy blue from logo
  static const Color secondaryLight = Color(0xFFFF6B35); // Orange from logo
  static const Color successLight =
      Color(0xFF059669); // Safety confirmation green
  static const Color warningLight =
      Color(0xFFD97706); // Attention-drawing amber
  static const Color errorLight = Color(0xFFDC2626); // Clear danger red
  static const Color surfaceLight = Color(0xFFF8FAFC); // Clean background
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white for cards
  static const Color borderLight =
      Color(0xFFE2E8F0); // Minimal gray for divisions
  static const Color textPrimaryLight = Color(0xFF0F172A); // High contrast text
  static const Color textSecondaryLight = Color(0xFF475569); // Supporting text

  // Dark theme adaptations maintaining brand consistency
  static const Color primaryDark =
      Color(0xFF2D4A70); // Slightly brighter navy for dark mode
  static const Color secondaryDark =
      Color(0xFFFF7A47); // Slightly brighter orange for contrast
  static const Color successDark =
      Color(0xFF10B981); // Brighter green for visibility
  static const Color warningDark =
      Color(0xFFF59E0B); // Enhanced amber for dark backgrounds
  static const Color errorDark = Color(0xFFEF4444); // Softer red for dark mode
  static const Color surfaceDark =
      Color(0xFF0F172A); // Deep professional background
  static const Color cardDark = Color(0xFF1E293B); // Elevated card surface
  static const Color borderDark =
      Color(0xFF334155); // Subtle borders for dark mode
  static const Color textPrimaryDark =
      Color(0xFFF8FAFC); // High contrast on dark
  static const Color textSecondaryDark =
      Color(0xFF94A3B8); // Supporting text on dark

  // Additional semantic colors for travel context
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color onErrorLight = Color(0xFFFFFFFF);

  static const Color onPrimaryDark = Color(0xFFFFFFFF);
  static const Color onSecondaryDark = Color(0xFF000000);
  static const Color onSurfaceDark = Color(0xFFF8FAFC);
  static const Color onErrorDark = Color(0xFFFFFFFF);

  // Shadow and elevation colors for spatial depth
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x1A000000);

  /// Light theme optimized for travel and hospitality applications with NomadNest branding
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: onPrimaryLight,
          primaryContainer: primaryLight.withAlpha(26),
          onPrimaryContainer: primaryLight,
          secondary: secondaryLight,
          onSecondary: onSecondaryLight,
          secondaryContainer: secondaryLight.withAlpha(26),
          onSecondaryContainer: secondaryLight,
          tertiary: successLight,
          onTertiary: onPrimaryLight,
          tertiaryContainer: successLight.withAlpha(26),
          onTertiaryContainer: successLight,
          error: errorLight,
          onError: onErrorLight,
          errorContainer: errorLight.withAlpha(26),
          onErrorContainer: errorLight,
          surface: surfaceLight,
          onSurface: onSurfaceLight,
          onSurfaceVariant: textSecondaryLight,
          outline: borderLight,
          outlineVariant: borderLight.withAlpha(128),
          shadow: shadowLight,
          scrim: shadowLight,
          inverseSurface: surfaceDark,
          onInverseSurface: onSurfaceDark,
          inversePrimary: primaryDark,
          surfaceTint: primaryLight),
      scaffoldBackgroundColor: surfaceLight,
      cardColor: cardLight,
      dividerColor: borderLight,

      // AppBar theme for trust-building navigation
      appBarTheme: AppBarTheme(
          backgroundColor: cardLight,
          foregroundColor: textPrimaryLight,
          elevation: 1,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryLight,
              letterSpacing: -0.02),
          iconTheme: IconThemeData(color: textPrimaryLight, size: 24),
          actionsIconTheme: IconThemeData(color: textPrimaryLight, size: 24)),

      // Card theme with subtle elevation for spatial hierarchy
      cardTheme: CardTheme(
          color: cardLight,
          elevation: 2,
          shadowColor: shadowLight,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation optimized for one-handed use
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: cardLight,
          selectedItemColor: primaryLight,
          unselectedItemColor: textSecondaryLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
          unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4)),

      // Floating action button with gradient for primary CTA
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryLight,
          foregroundColor: onSecondaryLight,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes emphasizing trust and accessibility with brand colors
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: onPrimaryLight,
              backgroundColor: primaryLight,
              elevation: 2,
              shadowColor: shadowLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.02))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(color: primaryLight, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.02))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: secondaryLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.02))),

      // Typography using Inter for geometric clarity
      textTheme: _buildTextTheme(isLight: true),

      // Input decoration for forms with trust-building design
      inputDecorationTheme: InputDecorationTheme(
          fillColor: cardLight,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderLight, width: 1)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderLight, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryLight, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: errorLight, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: errorLight, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondaryLight, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryLight.withAlpha(153), fontSize: 16, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorLight, fontSize: 12, fontWeight: FontWeight.w400)),

      // Interactive elements with brand colors
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return secondaryLight;
        return textSecondaryLight.withAlpha(128);
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return secondaryLight.withAlpha(77);
        return borderLight;
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryLight;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(onPrimaryLight),
          side: BorderSide(color: borderLight, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryLight;
        return textSecondaryLight;
      })),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: secondaryLight, linearTrackColor: borderLight, circularTrackColor: borderLight),
      sliderTheme: SliderThemeData(activeTrackColor: secondaryLight, thumbColor: secondaryLight, overlayColor: secondaryLight.withAlpha(51), inactiveTrackColor: borderLight, trackHeight: 4),

      // Tab bar theme for navigation consistency
      tabBarTheme: TabBarThemeData(labelColor: primaryLight, unselectedLabelColor: textSecondaryLight, indicatorColor: secondaryLight, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1)),

      // Tooltip theme for helpful guidance
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimaryLight.withAlpha(230), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: cardLight, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),

      // Snackbar theme for feedback
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimaryLight, contentTextStyle: GoogleFonts.inter(color: cardLight, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: secondaryLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),

      // Chip theme for tags and filters
      chipTheme: ChipThemeData(backgroundColor: borderLight.withAlpha(77), selectedColor: secondaryLight.withAlpha(26), labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textPrimaryLight), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      dialogTheme: DialogThemeData(backgroundColor: cardLight));

  /// Dark theme maintaining brand consistency in low-light conditions
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: onPrimaryDark,
          primaryContainer: primaryDark.withAlpha(51),
          onPrimaryContainer: primaryDark,
          secondary: secondaryDark,
          onSecondary: onSecondaryDark,
          secondaryContainer: secondaryDark.withAlpha(51),
          onSecondaryContainer: secondaryDark,
          tertiary: successDark,
          onTertiary: onPrimaryDark,
          tertiaryContainer: successDark.withAlpha(51),
          onTertiaryContainer: successDark,
          error: errorDark,
          onError: onErrorDark,
          errorContainer: errorDark.withAlpha(51),
          onErrorContainer: errorDark,
          surface: surfaceDark,
          onSurface: onSurfaceDark,
          onSurfaceVariant: textSecondaryDark,
          outline: borderDark,
          outlineVariant: borderDark.withAlpha(128),
          shadow: shadowDark,
          scrim: shadowDark,
          inverseSurface: surfaceLight,
          onInverseSurface: onSurfaceLight,
          inversePrimary: primaryLight,
          surfaceTint: primaryDark),
      scaffoldBackgroundColor: surfaceDark,
      cardColor: cardDark,
      dividerColor: borderDark,
      appBarTheme: AppBarTheme(
          backgroundColor: cardDark,
          foregroundColor: textPrimaryDark,
          elevation: 1,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimaryDark,
              letterSpacing: -0.02),
          iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
          actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24)),
      cardTheme: CardThemeData(
          color: cardDark,
          elevation: 2,
          shadowColor: shadowDark,
          surfaceTintColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: cardDark,
          selectedItemColor: primaryDark,
          unselectedItemColor: textSecondaryDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
          unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryDark,
          foregroundColor: onSecondaryDark,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: onPrimaryDark,
              backgroundColor: primaryDark,
              elevation: 2,
              shadowColor: shadowDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.02))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(color: primaryDark, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.02))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: secondaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.02))),
      textTheme: _buildTextTheme(isLight: false),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: cardDark,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderDark, width: 1)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderDark, width: 1)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryDark, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: errorDark, width: 1)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: errorDark, width: 2)),
          labelStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textSecondaryDark.withAlpha(153), fontSize: 16, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorDark, fontSize: 12, fontWeight: FontWeight.w400)),
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return secondaryDark;
        return textSecondaryDark.withAlpha(128);
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected))
          return secondaryDark.withAlpha(77);
        return borderDark;
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return primaryDark;
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(onPrimaryDark),
          side: BorderSide(color: borderDark, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return primaryDark;
        return textSecondaryDark;
      })),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: secondaryDark, linearTrackColor: borderDark, circularTrackColor: borderDark),
      sliderTheme: SliderThemeData(activeTrackColor: secondaryDark, thumbColor: secondaryDark, overlayColor: secondaryDark.withAlpha(51), inactiveTrackColor: borderDark, trackHeight: 4),
      tabBarTheme: TabBarThemeData(labelColor: primaryDark, unselectedLabelColor: textSecondaryDark, indicatorColor: secondaryDark, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1)),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: textPrimaryDark.withAlpha(230), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: surfaceDark, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      snackBarTheme: SnackBarThemeData(backgroundColor: textPrimaryDark, contentTextStyle: GoogleFonts.inter(color: surfaceDark, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: secondaryDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      chipTheme: ChipThemeData(backgroundColor: borderDark.withAlpha(77), selectedColor: secondaryDark.withAlpha(51), labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: textPrimaryDark), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
      dialogTheme: DialogThemeData(backgroundColor: cardDark));

  /// Helper method to build text theme using Inter font family
  /// Implements geometric clarity optimized for mobile screens
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? textPrimaryLight : textPrimaryDark;
    final Color textSecondary =
        isLight ? textSecondaryLight : textSecondaryDark;

    return TextTheme(
        // Display styles for large headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles for section headers
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.33),

        // Title styles for cards and components
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.15,
            height: 1.50),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),

        // Body text for content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.5,
            height: 1.50),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4,
            height: 1.33),

        // Label styles for UI elements
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.5,
            height: 1.33),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.5,
            height: 1.45));
  }
}
