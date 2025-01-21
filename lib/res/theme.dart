import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
import 'package:lightmeter/utils/color_to_int.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const primaryColorsList = [
  Color(0xfff44336),
  Color(0xffe91e63),
  Color(0xff9c27b0),
  Color(0xff673ab7),
  Color(0xff3f51b5),
  Color(0xff2196f3),
  Color(0xff03a9f4),
  Color(0xff00bcd4),
  Color(0xff009688),
  Color(0xff4caf50),
  Color(0xff8bc34a),
  Color(0xffcddc39),
  Color(0xffffeb3b),
  Color(0xffffc107),
  Color(0xffff9800),
  Color(0xffff5722),
];

ThemeData themeFrom(Color primaryColor, Brightness brightness) {
  final scheme = _colorSchemeFromColor(primaryColor, brightness);
  final theme = ThemeData(
    useMaterial3: true,
    brightness: scheme.brightness,
    primaryColor: primaryColor,
    colorScheme: scheme,
    appBarTheme: AppBarTheme(
      elevation: Dimens.elevationLevel0,
      scrolledUnderElevation: Dimens.elevationLevel2,
      color: scheme.surface,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: scheme.surfaceTint,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      color: scheme.surface,
      elevation: Dimens.elevationLevel1,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusL)),
      surfaceTintColor: scheme.surfaceTint,
    ),
    dialogBackgroundColor: scheme.surface,
    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      elevation: Dimens.elevationLevel3,
    ),
    dividerColor: scheme.outlineVariant,
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      space: 0,
    ),
    listTileTheme: ListTileThemeData(
      style: ListTileStyle.list,
      iconColor: scheme.onSurface,
      textColor: scheme.onSurface,
    ),
    scaffoldBackgroundColor: scheme.surface,
  );
  return theme.copyWith(
    listTileTheme: ListTileThemeData(
      style: ListTileStyle.list,
      iconColor: scheme.onSurface,
      textColor: scheme.onSurface,
      subtitleTextStyle: theme.textTheme.bodyMedium,
      leadingAndTrailingTextStyle: theme.textTheme.bodyMedium,
    ),
  );
}

ColorScheme _colorSchemeFromColor(Color primaryColor, Brightness brightness) {
  final scheme = SchemeTonalSpot(
    sourceColorHct: Hct.fromInt(primaryColor.toInt()),
    isDark: brightness == Brightness.dark,
    contrastLevel: 0.0,
  );

  return ColorScheme(
    brightness: brightness,
    error: Color(scheme.error),
    onError: Color(scheme.onError),
    errorContainer: Color(scheme.errorContainer),
    onErrorContainer: Color(scheme.onErrorContainer),
    primary: Color(scheme.primary),
    onPrimary: Color(scheme.onPrimary),
    primaryContainer: Color(scheme.primaryContainer),
    onPrimaryContainer: Color(scheme.onPrimaryContainer),
    secondary: Color(scheme.secondary),
    onSecondary: Color(scheme.onSecondary),
    secondaryContainer: Color(scheme.secondaryContainer),
    onSecondaryContainer: Color(scheme.onSecondaryContainer),
    tertiary: Color(scheme.tertiary),
    onTertiary: Color(scheme.onTertiary),
    tertiaryContainer: Color(scheme.tertiaryContainer),
    onTertiaryContainer: Color(scheme.onTertiaryContainer),
    surface: Color(scheme.surface),
    onSurface: Color(scheme.onSurface),
    surfaceContainerHighest: Color(scheme.surfaceContainerHighest),
    onSurfaceVariant: Color(scheme.onSurfaceVariant),
    outline: Color(scheme.outline),
    outlineVariant: Color(scheme.outlineVariant),
    surfaceTint: Color(scheme.surfaceTint),
    shadow: Color(scheme.shadow),
    scrim: Color(scheme.scrim),
  );
}

extension ElevatedSurfaceTheme on ColorScheme {
  Color _surfaceWithElevation(double elevation) {
    return ElevationOverlay.applySurfaceTint(surface, surfaceTint, elevation);
  }

  Color get surfaceElevated1 => _surfaceWithElevation(Dimens.elevationLevel1);
  Color get surfaceElevated2 => _surfaceWithElevation(Dimens.elevationLevel2);
  Color get surfaceElevated3 => _surfaceWithElevation(Dimens.elevationLevel3);
}
