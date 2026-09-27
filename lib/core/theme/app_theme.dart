import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_colors_theme.dart';

/// Tipografías de ExRE.
abstract final class AppTypography {
  /// Display — títulos y valores grandes.
  static const String displayFont = 'Poppins';

  /// Body — todo lo demás.
  static const String bodyFont = 'Inter';

  // ---------------------------------------------------------------------
  // Display (Poppins)
  // ---------------------------------------------------------------------

  static const TextStyle display22 = TextStyle(
    fontFamily: displayFont,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );

  static const TextStyle display18 = TextStyle(
    fontFamily: displayFont,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.colorTextPrimary,
  );

  static const TextStyle display16 = TextStyle(
    fontFamily: displayFont,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );

  // ---------------------------------------------------------------------
  // Body (Inter)
  // ---------------------------------------------------------------------

  static const TextStyle body15 = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );

  static const TextStyle body14 = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );

  static const TextStyle body14Regular = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );

  static const TextStyle body12 = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextSecondary,
  );

  static const TextStyle body11 = TextStyle(
    fontFamily: bodyFont,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.colorTextSecondary,
  );

  static const TextStyle body10 = TextStyle(
    fontFamily: bodyFont,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.colorTextTertiary,
  );

  /// Hora del StatusBar.
  static const TextStyle statusBarClock = TextStyle(
    fontFamily: bodyFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.colorTextPrimary,
  );
}

/// ThemeData de ExRE — tema oscuro, fondo `colorBg`, nunca blanco.
abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.colorPrimary,
      onPrimary: Colors.white,
      secondary: AppColors.colorPrimarySoft,
      onSecondary: Colors.white,
      surface: AppColors.colorSurface,
      onSurface: AppColors.colorTextPrimary,
      error: AppColors.colorDanger,
      onError: Colors.white,
      outline: AppColors.colorBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.colorBg,
      canvasColor: AppColors.colorBg,
      fontFamily: AppTypography.bodyFont,
      splashFactory: InkSparkle.splashFactory,
      extensions: const <ThemeExtension<dynamic>>[AppColorsTheme.tokens],
      textTheme: const TextTheme(
        displayLarge: AppTypography.display22,
        displayMedium: AppTypography.display18,
        titleLarge: AppTypography.display16,
        titleMedium: AppTypography.body15,
        bodyLarge: AppTypography.body14,
        bodyMedium: AppTypography.body14Regular,
        bodySmall: AppTypography.body12,
        labelSmall: AppTypography.body11,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.colorBg,
        foregroundColor: AppColors.colorTextPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.colorBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.colorTextSecondary),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.colorSurface,
        contentTextStyle: AppTypography.body12,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.colorBorder),
        ),
      ),
    );
  }
}

/// Radios y espaciados usados en toda la app.
///
/// Regla general: tarjetas grandes `16`, elementos pill/circulares `18-20`,
/// botones `14`. No inventar radios intermedios.
abstract final class AppRadius {
  static const double card = 16;
  static const double cover = 12;
  static const double button = 14;
  static const double tab = 14;
  static const double quickAccess = 18;
  static const double chip = 20;
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;

  /// Padding horizontal estándar de las pantallas.
  static const double screenH = 20;

  /// Ancho máximo de contenido (botón, listas).
  static const double contentMax = 398;
}
