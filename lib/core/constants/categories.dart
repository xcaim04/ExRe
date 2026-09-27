import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Las 6 categorías de ExRE.
///
/// Se usan de forma consistente en: el `Cover` de las tarjetas
/// (catálogo/galería), los puntos (`Dot`) del breakdown por categoría en
/// Progreso, y los chips de filtro seleccionados.
enum ResourceCategory {
  flutter('Flutter'),
  android('Android'),
  layouts('Layouts'),
  scrollables('Scrollables'),
  slivers('Slivers'),
  navegacion('Navegación');

  const ResourceCategory(this.value);

  /// Valor persistido en SQLite y mostrado en la UI.
  final String value;

  /// Color fuerte de la categoría (portada de tarjetas, punto de progreso).
  Color get color => switch (this) {
    ResourceCategory.flutter => const Color(0xFF0553B1),
    ResourceCategory.android => const Color(0xFF1DA260),
    ResourceCategory.layouts => AppColors.colorWarning,
    ResourceCategory.scrollables => const Color(0xFFDB2777),
    ResourceCategory.slivers => const Color(0xFF7C3AED),
    ResourceCategory.navegacion => const Color(0xFFDC2626),
  };

  /// Versión "light" para fondos suaves.
  Color get lightColor => switch (this) {
    ResourceCategory.flutter => AppCategoryColors.flutterLight,
    ResourceCategory.android => AppCategoryColors.androidLight,
    ResourceCategory.layouts => AppCategoryColors.layoutsLight,
    ResourceCategory.scrollables => AppCategoryColors.scrollablesLight,
    ResourceCategory.slivers => AppCategoryColors.sliversLight,
    ResourceCategory.navegacion => AppCategoryColors.navegacionLight,
  };

  /// Nombre corto de 3 letras para el `Cover` de las tarjetas.
  String get shortLabel => switch (this) {
    ResourceCategory.flutter => 'FLT',
    ResourceCategory.android => 'AND',
    ResourceCategory.layouts => 'LAY',
    ResourceCategory.scrollables => 'SCR',
    ResourceCategory.slivers => 'SLV',
    ResourceCategory.navegacion => 'NAV',
  };

  static ResourceCategory fromValue(String value) => values.firstWhere(
    (c) => c.value == value,
    orElse: () => ResourceCategory.flutter,
  );
}
