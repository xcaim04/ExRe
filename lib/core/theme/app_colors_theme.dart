import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Extensión de tema que expone la paleta de ExRE dentro del `BuildContext`.
///
/// Permite escribir `context.colors.colorSurface` en lugar de repetir
/// `AppColors.colorSurface` en cada widget, y mantiene la fuente de verdad
/// única.
@immutable
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.primary,
    required this.primarySoft,
    required this.bg,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.border,
    required this.success,
    required this.warning,
    required this.danger,
    required this.favorite,
    required this.onPrimaryBorder,
  });

  /// Los tokens del diseño, como valor constante (permite listas `const`).
  static const AppColorsTheme tokens = AppColorsTheme(
    primary: AppColors.colorPrimary,
    primarySoft: AppColors.colorPrimarySoft,
    bg: AppColors.colorBg,
    surface: AppColors.colorSurface,
    textPrimary: AppColors.colorTextPrimary,
    textSecondary: AppColors.colorTextSecondary,
    textTertiary: AppColors.colorTextTertiary,
    border: AppColors.colorBorder,
    success: AppColors.colorSuccess,
    warning: AppColors.colorWarning,
    danger: AppColors.colorDanger,
    favorite: AppColors.colorFavorite,
    onPrimaryBorder: AppColors.colorOnPrimaryBorder,
  );

  /// Alias de [tokens].
  factory AppColorsTheme.fromTokens() => tokens;

  final Color primary;
  final Color primarySoft;
  final Color bg;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color border;
  final Color success;
  final Color warning;
  final Color danger;
  final Color favorite;
  final Color onPrimaryBorder;

  @override
  AppColorsTheme copyWith({
    Color? primary,
    Color? primarySoft,
    Color? bg,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? border,
    Color? success,
    Color? warning,
    Color? danger,
    Color? favorite,
    Color? onPrimaryBorder,
  }) {
    return AppColorsTheme(
      primary: primary ?? this.primary,
      primarySoft: primarySoft ?? this.primarySoft,
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      favorite: favorite ?? this.favorite,
      onPrimaryBorder: onPrimaryBorder ?? this.onPrimaryBorder,
    );
  }

  @override
  AppColorsTheme lerp(ThemeExtension<AppColorsTheme>? other, double t) {
    if (other is! AppColorsTheme) return this;
    return AppColorsTheme(
      primary: Color.lerp(primary, other.primary, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      favorite: Color.lerp(favorite, other.favorite, t)!,
      onPrimaryBorder: Color.lerp(onPrimaryBorder, other.onPrimaryBorder, t)!,
    );
  }
}

extension AppColorsThemeContext on BuildContext {
  /// Acceso corto a la paleta desde cualquier widget.
  AppColorsTheme get colors =>
      Theme.of(this).extension<AppColorsTheme>() ?? AppColorsTheme.fromTokens();
}
