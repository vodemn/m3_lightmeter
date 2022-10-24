import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

ColorScheme get lightColorScheme {
  final scheme = Scheme.light(0xFF2196f3);
  return ColorScheme.light(
    primary: Color(scheme.primary),
    onPrimary: Color(scheme.onPrimary),
    primaryContainer: Color(scheme.primaryContainer),
    onPrimaryContainer: Color(scheme.onPrimaryContainer),
    secondary: Color(scheme.secondary),
    onSecondary: Color(scheme.onSecondary),
    error: Color(scheme.error),
    onError: Color(scheme.onError),
    background: Color(scheme.background),
    onBackground: Color(scheme.onBackground),
    surface: Color.alphaBlend(Color(scheme.primary).withOpacity(0.05), Color(scheme.background)),
    onSurface: Color(scheme.onSurface),
    surfaceVariant: Color.alphaBlend(Color(scheme.primary).withOpacity(0.5), Color(scheme.background)),
    onSurfaceVariant: Color(scheme.onSurfaceVariant),
  );
}
