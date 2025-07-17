import 'dart:ui';

extension ColorOpacityExtension on Color {
  Color withOpacityX(double opacity) {
    return withAlpha((opacity * 255).round());
  }
}