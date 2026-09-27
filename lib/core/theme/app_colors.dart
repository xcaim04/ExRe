import 'package:flutter/material.dart';

/// Paleta de colores de ExRE.
///
/// Todos los valores son literales del archivo de diseño. Ningún widget debe
/// hardcodear un color: todo sale de aquí.
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // Tokens base
  // ---------------------------------------------------------------------
  /// Acciones principales, QuickAccessCard.
  static const Color colorPrimary = Color(0xFF4F46E5);

  /// Variante / hover del primario.
  static const Color colorPrimarySoft = Color(0xFF3A32A0);

  /// Fondo general de la app (tema oscuro).
  static const Color colorBg = Color(0xFF231C6B);

  /// Tarjetas, chips, status bar.
  static const Color colorSurface = Color(0xFF2E2789);

  static const Color colorTextPrimary = Color(0xFFFFFFFF);
  static const Color colorTextSecondary = Color(0xFFC5BFEE);
  static const Color colorTextTertiary = Color(0xFF948CCB);

  /// Bordes de tarjetas y chips (stroke width 1).
  static const Color colorBorder = Color(0xFF443BA5);

  static const Color colorSuccess = Color(0xFF16A34A);
  static const Color colorWarning = Color(0xFFF59E0B);
  static const Color colorDanger = Color(0xFFEF4444);

  /// Ícono de favorito activo.
  static const Color colorFavorite = Color(0xFFF43F5E);

  /// Botón secundario: borde translúcido.
  static const Color colorOnPrimaryBorder = Color(0x66FFFFFF);
}

/// Versión "light" (fondos suaves) de cada color de categoría.
abstract final class AppCategoryColors {
  static const Color flutterLight = Color(0xFF54C5F8);
  static const Color androidLight = Color(0xFF4ADE80);
  static const Color layoutsLight = Color(0xFFFCD34D);
  static const Color scrollablesLight = Color(0xFFF9A8D4);
  static const Color sliversLight = Color(0xFFC4B5FD);
  static const Color navegacionLight = Color(0xFFFCA5A5);
}
