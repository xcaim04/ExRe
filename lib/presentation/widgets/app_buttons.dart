import 'package:flutter/material.dart';

import '../../core/theme/app_colors_theme.dart';
import '../../core/theme/app_theme.dart';

/// Botón principal: fondo blanco, ícono y label en `colorPrimary`.
///
/// Ancho `fill_container` (máx 326), `cornerRadius: 14`, `padding: [14, 20]`,
/// `gap: 8`, `Inter 14px 600`.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    super.key,
    this.icon,
    this.onPressed,
    this.expand = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _AppButton(
      expand: expand,
      background: Colors.white,
      borderColor: Colors.transparent,
      foreground: context.colors.primary,
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
  }
}

/// Botón secundario: fondo transparente, borde `#FFFFFF66`, texto blanco.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    required this.label,
    super.key,
    this.icon,
    this.onPressed,
    this.expand = true,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return _AppButton(
      expand: expand,
      background: Colors.transparent,
      borderColor: c.onPrimaryBorder,
      foreground: Colors.white,
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
  }
}

/// Implementación compartida por ambos botones.
class _AppButton extends StatelessWidget {
  const _AppButton({
    required this.expand,
    required this.background,
    required this.borderColor,
    required this.foreground,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final bool expand;
  final Color background;
  final Color borderColor;
  final Color foreground;
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: expand ? double.infinity : null,
      constraints: expand
          ? const BoxConstraints(maxWidth: AppSpacing.contentMax)
          : const BoxConstraints(),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: foreground),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body14.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: child,
      ),
    );
  }
}
