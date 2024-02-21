import 'package:flutter/material.dart';
import 'package:lightmeter/res/dimens.dart';
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
      elevation: 4,
      color: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
    ),
    cardTheme: CardTheme(
      clipBehavior: Clip.antiAlias,
      color: scheme.surface,
      elevation: 4,
      margin: EdgeInsets.zero,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.borderRadiusL)),
      surfaceTintColor: scheme.surfaceTint,
    ),
    dialogBackgroundColor: scheme.surface,
    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      elevation: 6,
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
      subtitleTextStyle: theme.textTheme.bodyMedium!.copyWith(color: scheme.onSurfaceVariant),
    ),
  );
}

ColorScheme _colorSchemeFromColor(Color primaryColor, Brightness brightness) {
  final scheme = brightness == Brightness.light ? Scheme.light(primaryColor.value) : Scheme.dark(primaryColor.value);

  return ColorScheme(
    brightness: brightness,
    background: Color(scheme.background),
    error: Color(scheme.error),
    errorContainer: Color(scheme.errorContainer),
    onBackground: Color(scheme.onBackground),
    onError: Color(scheme.onError),
    onErrorContainer: Color(scheme.onErrorContainer),
    primary: Color(scheme.primary),
    onPrimary: Color(scheme.onPrimary),
    primaryContainer: Color(scheme.primaryContainer),
    onPrimaryContainer: Color(scheme.onPrimaryContainer),
    secondary: Color(scheme.secondary),
    onSecondary: Color(scheme.onSecondary),
    surface: Color.alphaBlend(
      Color(scheme.primary).withOpacity(0.05),
      Color(scheme.background),
    ),
    onSurface: Color(scheme.onSurface),
    surfaceVariant: Color.alphaBlend(
      Color(scheme.primary).withOpacity(0.5),
      Color(scheme.background),
    ),
    onSurfaceVariant: Color(scheme.onSurfaceVariant),
    outline: Color(scheme.outline),
    outlineVariant: Color(scheme.outlineVariant),
  );
}
