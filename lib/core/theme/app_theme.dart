import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryNavy,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryNavyLight.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.primaryNavyDark,
      secondary: AppColors.secondaryGold,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryGoldLight.withValues(alpha: 0.15),
      onSecondaryContainer: AppColors.secondaryGoldDark,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.dividerLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardLight,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: const BorderSide(color: AppColors.borderLight, width: AppDimensions.cardBorderWidth),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryNavy, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryLight),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryNavy,
          side: const BorderSide(color: AppColors.borderLight, width: 1.2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryNavy.withValues(alpha: 0.12),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.primaryNavy,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryNavy);
          }
          return const IconThemeData(color: AppColors.textSecondaryLight);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryNavyLight,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryNavyDark,
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondaryGoldLight,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: AppColors.secondaryGoldDark.withValues(alpha: 0.3),
      onSecondaryContainer: Colors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: Colors.white,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: AppDimensions.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          side: const BorderSide(color: AppColors.borderDark, width: AppDimensions.cardBorderWidth),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.primaryNavyLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiaryDark),
        labelStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryNavyLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimaryDark,
          side: const BorderSide(color: AppColors.borderDark, width: 1.2),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space20,
            vertical: AppDimensions.space12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(0, AppDimensions.minTouchTarget),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primaryNavyLight.withValues(alpha: 0.25),
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: AppColors.textPrimaryDark,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.textPrimaryDark);
          }
          return const IconThemeData(color: AppColors.textSecondaryDark);
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
