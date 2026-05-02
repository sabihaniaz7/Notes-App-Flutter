import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_app/core/constants/sizes.dart';
import 'package:notes_app/core/theme/colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final cs = ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: Colors.black,
      surface: AppColors.backgroundColorLight,
      onSurface: Colors.black,
      secondary: Colors.black.withValues(alpha: 0.7),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      outline: Colors.black.withValues(alpha: 0.12),
      surfaceContainerHighest: AppColors.surfaceContainerLight,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.scaffoldBgColorLight,
      fontFamily: 'Poppins',
      // ── AppBar ──────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColorLight,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: AppText.displayMd,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),

      // ------------- Card ----------------------
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Input / TextField ───────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSize.lg,
          vertical: AppSize.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(
            color: cs.outline.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(
            color: cs.outline.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.error, width: 1.8),
        ),
        labelStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.55),
          fontSize: AppText.body,
        ),
        hintStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.38),
          fontSize: AppText.body,
        ),
        prefixIconColor: cs.onSurface.withValues(alpha: 0.45),
        suffixIconColor: cs.onSurface.withValues(alpha: 0.45),
      ),

      // -------------FAB---------------------
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.fabRadius),
        ),
      ),

      // ── FilledButton ─────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.inputRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppText.titleMd,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // ------Snackbar---------------------------
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.md),
        ),
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(
          color: cs.onInverseSurface,
          fontSize: AppText.body,
        ),
      ),

      // ── Chip / SegmentedButton ───────────────
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.chipRadius),
          ),
          selectedBackgroundColor: cs.primaryContainer,
          selectedForegroundColor: cs.onPrimaryContainer,
          textStyle: const TextStyle(
            fontSize: AppText.caption,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ============= DIVIDER =======================
      dividerTheme: DividerThemeData(
        color: cs.outline.withValues(alpha: 0.15),
        thickness: 1,
        space: 1,
      ),

      // =====LIST TILE =============
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.lg,
          vertical: AppSize.xs,
        ),
      ),
    );
  }

  /// =========== DARK THEME
  static ThemeData dark() {
    final cs = ColorScheme.dark(
      primary: Colors.white,
      onPrimary: Colors.black,
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: Colors.white,
      surface: AppColors.backgroundColorDark,
      onSurface: Colors.white,
      secondary: Colors.white.withValues(alpha: 0.7),
      onSecondary: Colors.black,
      error: Colors.redAccent,
      onError: Colors.black,
      outline: Colors.white.withValues(alpha: 0.12),
      surfaceContainerHighest: Colors.black38,
    );

    return ThemeData(
      // useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: AppColors.scaffoldBgColorDark,
      fontFamily: 'Poppins',

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColorDark,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: cs.onSurface,
          fontSize: AppText.displayMd,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: cs.onSurface),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputFillDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSize.lg,
          vertical: AppSize.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(
            color: cs.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(
            color: cs.outline.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.inputRadius),
          borderSide: BorderSide(color: cs.error, width: 1.8),
        ),
        labelStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.5),
          fontSize: AppText.body,
        ),
        hintStyle: TextStyle(
          color: cs.onSurface.withValues(alpha: 0.35),
          fontSize: AppText.body,
        ),
        prefixIconColor: cs.onSurface.withValues(alpha: 0.4),
        suffixIconColor: cs.onSurface.withValues(alpha: 0.4),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.fabRadius),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.inputRadius),
          ),
          textStyle: const TextStyle(
            fontSize: AppText.titleMd,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.md),
        ),
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(
          color: cs.onInverseSurface,
          fontSize: AppText.body,
        ),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.chipRadius),
          ),
          selectedBackgroundColor: cs.primaryContainer,
          selectedForegroundColor: cs.onPrimaryContainer,
          textStyle: const TextStyle(
            fontSize: AppText.caption,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: cs.outline.withValues(alpha: 0.12),
        thickness: 1,
        space: 1,
      ),

      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSize.lg,
          vertical: AppSize.xs,
        ),
      ),
    );
  }
}
