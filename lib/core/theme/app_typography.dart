import 'package:flutter/material.dart';

class AppTypography {
  const AppTypography._();

  static TextTheme textTheme([TextTheme? base]) {
    final TextTheme fallback = ThemeData.light().textTheme;
    final TextTheme resolved = base ?? fallback;

    return resolved.copyWith();
  }
}
